from fastapi import FastAPI, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy import create_engine, Column, Integer, String, Boolean, ForeignKey, Text
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship
from jose import JWTError, jwt
from passlib.context import CryptContext
from datetime import datetime, timedelta,UTC
import os
from fastapi import Request
import requests

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+psycopg2://postgres:admin@localhost:5432/surveydb")

app = FastAPI()
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="token")

# ------------------ Models ------------------ #
class User(Base):
    __tablename__ = "user"
    user_id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, index=True, nullable=False)
    education = Column(String(100), nullable=True)
    income_bracket = Column(String(50), nullable=True)
    hashed_password = Column(String, nullable=False)
    location = Column(String, nullable=True)

class Question(Base):
    __tablename__ = "question"
    question_id = Column(Integer, primary_key=True, index=True)
    question_description = Column(String(100), nullable=False)
    question_code = Column(String(20), nullable=True)

class Category(Base):
    __tablename__ = "category"
    category_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    parent_id = Column(Integer, ForeignKey("category.category_id"), nullable=True)
    description = Column(String(100), nullable=True)
    is_active = Column(Boolean, default=True)

class Company(Base):
    __tablename__ = "company"
    company_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    country = Column(String(100), default="INDIA")
    sector = Column(String(100), nullable=False)
    parent_category = Column(Integer, ForeignKey("category.category_id"))

class Product(Base):
    __tablename__ = "product"
    product_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(Text, nullable=True)
    company_id = Column(Integer, ForeignKey("company.company_id"), nullable=False)

# ------------------ Auth Utils ------------------ #
def verify_password(plain_password, hashed_password):
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password):
    return pwd_context.hash(password)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.now(UTC) + expires_delta
    else:
        expire = datetime.now(UTC) + timedelta(minutes=15)
    to_encode.update({"exp": int(expire.timestamp())})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

#this function is said to get the currently authenticated user and we are defining a credentials exception by ourselves
async def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
    #here we are extracting the payload and getting the user_id using the sub claim
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id: int = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    #here we are getting catching token expiry errors and jwt decoding errors 
    except JWTError:
        raise credentials_exception
    #creating a new session obect used for adding querying users based on their ids
    db = SessionLocal()
    user = db.query(User).filter(User.user_id == user_id).first()
    #we are closing the session as well
    db.close()
    if user is None:
        raise credentials_exception
    return user

#here we are checking for the header used by proxies and if it exists then we take the first ip address as we can hav multiple ip addresses
#
def get_client_ip(request: Request) -> str:
    # Check common header used by proxies
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0]
    else:
        ip = request.client.host
    return ip


#utility function to get geolocation details from the clients ip address
def get_location_from_ip(ip: str):
    try:
        #thru this api key we would be able to get the users geolocation as well by making a http get request to a third party API
        access_key = "6a27abcf72b32752edf84354e82ed1d0"  
        res = requests.get(f"http://api.ipapi.com/api/{ip}?access_key={access_key}")
        if res.status_code == 200:
            data = res.json()
            city = data.get("city", "")
            region = data.get("region", "")
            country = data.get("country_name", "")
            return f"{city}, {region}, {country}"
    except Exception:
        pass
    return "Unknown"


# ------------------ Routes ------------------ #
#this is nothing but registration in which we get the clients ip address as well 
@app.post("/register")
def register_user(
    full_name: str,
    email: str,
    password: str,
    education: str = None,
    income_bracket: str = None,
    request: Request = None
):
    db = SessionLocal()
    hashed_pw = get_password_hash(password)

    ip_address = get_client_ip(request)

    location = get_location_from_ip(ip_address)

    user = User(
        full_name=full_name,
        email=email,
        hashed_password=hashed_pw,
        education=education,
        income_bracket=income_bracket,
        location=location
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    db.close()
    return {"msg": "User registered successfully", "location": location}


#here for login u have to send the username and password as and u have to verify this and accordingly send a jwt token 
@app.post("/token")
def login(form_data: OAuth2PasswordRequestForm = Depends()):
    db = SessionLocal()
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user or not verify_password(form_data.password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect username or password")
    access_token = create_access_token(data={"sub": str(user.user_id)})
    db.close()
    return {"access_token": access_token, "token_type": "bearer"}
#gwt the profile of the currently authenticated user 
@app.get("/me")
def get_my_profile(current_user: User = Depends(get_current_user)):
    return {
        "user_id": current_user.user_id,
        "full_name": current_user.full_name,
        "email": current_user.email,
        "education": current_user.education,
        "income_bracket": current_user.income_bracket
    }

# ------------------ Create Tables ------------------ #
Base.metadata.create_all(bind=engine)  # Run only once or manage via alembic
