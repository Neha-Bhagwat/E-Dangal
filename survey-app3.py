from fastapi import FastAPI, Form, HTTPException, status, Depends, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy import create_engine, Column, Integer, String, Boolean, Text, DateTime
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from jose import jwt, JWTError
from passlib.context import CryptContext
from datetime import datetime, timedelta, UTC
from typing import Literal
import os, requests

# ------------------ Config ------------------ #
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+psycopg2://postgres:admin@localhost:5432/surveydb2")
SECRET_KEY = "your-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")
security = HTTPBearer()

app = FastAPI()
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(bind=engine, autocommit=False, autoflush=False)
Base = declarative_base()

# ------------------ Literals ------------------ #
AgeRange = Literal["15-20", "21-25", "26-30", "31-35", "36-40", "41-50", "51-60", "61-70", "71-80", "80+"]
Gender = Literal["male", "female", "other"]

# ------------------ User Model ------------------ #
class User(Base):
    __tablename__ = "user"
    user_id = Column(Integer, primary_key=True, index=True)
    full_name = Column(String(100), nullable=False)
    email = Column(String(100), unique=True, nullable=False, index=True)
    education = Column(String(100), nullable=True)
    income_bracket = Column(String(50), nullable=True)
    profile_pic = Column(Text, nullable=True)
    gender = Column(String(10), nullable=False)
    age = Column(String(10), nullable=False)
    phone_number = Column(String(15), nullable=True)
    hashed_password = Column(String, nullable=False)
    location = Column(String, nullable=True)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=lambda: datetime.now(UTC), nullable=False)
    updated_at = Column(DateTime, nullable=True)

# ------------------ Utility Functions ------------------ #
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

def verify_password(plain: str, hashed: str) -> bool:
    return pwd_context.verify(plain, hashed)

def create_access_token(data: dict, expires_delta: timedelta = None):
    to_encode = data.copy()
    expire = datetime.now(UTC) + (expires_delta or timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": int(expire.timestamp())})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_client_ip(request: Request) -> str:
    # Handles proxies by checking X-Forwarded-For first
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0]
    else:
        ip = request.client.host
    ip="103.95.173.163"
    return ip

def get_location_from_ip(ip: str) -> str:
    try:
        ACCESS_TOKEN = "162351233b46c0"  # Replace with your real token
        url = f"https://ipinfo.io/{ip}?token={ACCESS_TOKEN}"
        res = requests.get(url, timeout=5)
        if res.status_code == 200:
            data = res.json()
            city = data.get("city", "")
            region = data.get("region", "")
            country = data.get("country", "")
            return f"{city}, {region}, {country}".strip(", ")
    except Exception:
        pass
    return "Unknown"

def get_current_user(credentials: HTTPAuthorizationCredentials = Depends(security)):
    token = credentials.credentials
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_id = int(payload.get("sub"))
    except (JWTError, ValueError):
        raise HTTPException(status_code=401, detail="Invalid or expired token")

    db = SessionLocal()
    user = db.query(User).filter(User.user_id == user_id).first()
    db.close()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user

# ------------------ Routes ------------------ #
@app.post("/register")
def register_user(
    full_name: str = Form(...),
    email: str = Form(...),
    password: str = Form(...),
    education: str = Form(None),
    income_bracket: str = Form(None),
    gender: Gender = Form(...),
    age: AgeRange = Form(...),
    phone_number: str = Form(None),
    profile_pic: str = Form(None),
    request: Request = None
):
    db = SessionLocal()
    if db.query(User).filter(User.email == email).first():
        db.close()
        raise HTTPException(status_code=400, detail="Email already registered")

    ip = get_client_ip(request)
    location = get_location_from_ip(ip)
    hashed_pw = hash_password(password)

    user = User(
        full_name=full_name,
        email=email,
        hashed_password=hashed_pw,
        education=education,
        income_bracket=income_bracket,
        gender=gender,
        age=age,
        phone_number=phone_number,
        profile_pic=profile_pic,
        location=location
    )
    db.add(user)
    db.commit()
    db.refresh(user)
    db.close()
    return {"msg": "User registered successfully", "user_id": user.user_id, "location": location}

@app.post("/token")
def login(email: str = Form(...), password: str = Form(...)):
    db = SessionLocal()
    user = db.query(User).filter(User.email == email).first()
    db.close()
    if not user or not verify_password(password, user.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    token = create_access_token({"sub": str(user.user_id)})
    return {"access_token": token, "token_type": "bearer"}

@app.get("/me")
def get_profile(current_user: User = Depends(get_current_user)):
    return {
        "user_id": current_user.user_id,
        "full_name": current_user.full_name,
        "email": current_user.email,
        "gender": current_user.gender,
        "age": current_user.age,
        "education": current_user.education,
        "income_bracket": current_user.income_bracket,
        "location": current_user.location,
        "created_at": current_user.created_at
    }

# ------------------ DB Init ------------------ #
Base.metadata.create_all(bind=engine)
