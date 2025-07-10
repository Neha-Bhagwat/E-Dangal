# 🐍 FastAPI Product Survey App (Single File)

from fastapi import FastAPI, Form, HTTPException, status, Depends, Request
from fastapi.security import HTTPBearer, HTTPAuthorizationCredentials
from sqlalchemy import (create_engine, Column, Integer, String, Boolean, Text,
                        DateTime, ForeignKey, Table, TIMESTAMP, func)
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, relationship, Session
from fastapi.encoders import jsonable_encoder
from sqlalchemy.orm import joinedload
from jose import jwt, JWTError
from passlib.context import CryptContext
from datetime import datetime, timedelta, UTC
from typing import Literal, Optional, List
import os, requests
from pydantic import BaseModel

# ------------------ Config ------------------ #
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql+psycopg2://postgres:admin@localhost:5432/surveydb4")
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

# ------------------ Models ------------------ #
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

class Category(Base):
    __tablename__ = "category"
    category_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False)
    parent_id = Column(Integer, ForeignKey("category.category_id"), nullable=True)
    description = Column(String(100), nullable=True)
    is_active = Column(Boolean, default=True)

class Question(Base):
    __tablename__ = "question"
    question_id = Column(Integer, primary_key=True, index=True)
    question_description = Column(String(100), nullable=False)
    question_code = Column(String(20), nullable=True)

question_category = Table(
    "question_category",
    Base.metadata,
    Column("question_id", ForeignKey("question.question_id"), primary_key=True),
    Column("category_id", ForeignKey("category.category_id"), primary_key=True)
)

class Company(Base):
    __tablename__ = "company"
    company_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    country = Column(String(100), default="INDIA")
    sector = Column(String(100), nullable=False)
    parent_category = Column(Integer, ForeignKey("category.category_id"), nullable=False)

class Product(Base):
    __tablename__ = "product"
    product_id = Column(Integer, primary_key=True, index=True)
    name = Column(String(150), nullable=False)
    description = Column(Text, nullable=True)
    image_url = Column(Text, nullable=True)
    company_id = Column(Integer, ForeignKey("company.company_id"), nullable=False)
    company = relationship("Company")

class Response(Base):
    __tablename__ = "response"
    response_id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("user.user_id"), nullable=False)
    question_id = Column(Integer, ForeignKey("question.question_id"), nullable=False)
    category_id = Column(Integer, ForeignKey("category.category_id"), nullable=False)
    product_id = Column(Integer, ForeignKey("product.product_id"), nullable=True)
    answer_text = Column(Text, nullable=False)
    created_at = Column(TIMESTAMP(timezone=True), server_default=func.now())

# ------------------ Pydantic Schemas ------------------ #
class CategoryLiteral(str):
    pass

class QuestionOut(BaseModel):
    question_id: int
    question_description: str

    class Config:
        orm_mode = True

class CompanyOut(BaseModel):
    company_id: int
    name: str

    class Config:
        orm_mode = True

class ProductOut(BaseModel):
    product_id: int
    name: str
    company: CompanyOut

    class Config:
        orm_mode = True

class CategoryDetails(BaseModel):
    questions: List[QuestionOut]
    companies: List[CompanyOut]
    products: List[ProductOut]

class AnswerIn(BaseModel):
    question_id: int
    category_id: int
    product_id: int
    answer_text: str
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
    forwarded = request.headers.get("X-Forwarded-For")
    if forwarded:
        ip = forwarded.split(",")[0]
    else:
        ip = request.client.host
    ip="103.95.173.163"
    return ip

def get_location_from_ip(ip: str) -> str:
    try:
        token = "162351233b46c0"  # Replace with your token
        url = f"https://ipinfo.io/{ip}?token={token}"
        res = requests.get(url, timeout=5)
        if res.status_code == 200:
            data = res.json()
            return f"{data.get('city', '')}, {data.get('region', '')}, {data.get('country', '')}".strip(", ")
    except Exception:
        pass
    return "Unknown"

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

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




@app.get("/category-options", response_model=List[dict])
def get_category_options(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    # This endpoint provides categories as key-value dropdown list items
    categories = db.query(Category).filter(Category.is_active == True).all()
    return [{"label": cat.name, "value": cat.category_id} for cat in categories]

@app.get("/category-details/{category_id}", response_model=CategoryDetails)
def get_category_details(
    category_id: int,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    questions = db.query(Question).join(question_category).filter(
        question_category.c.category_id == category_id
    ).all()

    companies = db.query(Company).filter(Company.parent_category == category_id).all()

    products = db.query(Product).options(joinedload(Product.company)).join(Company).filter(Company.parent_category == category_id).all()

    product_outputs = [
        ProductOut(
            product_id=product.product_id,
            name=product.name,
            company=CompanyOut(company_id=product.company.company_id, name=product.company.name)
        ) for product in products
    ]

    return CategoryDetails(
        questions=[jsonable_encoder(q) for q in questions],
        companies=[jsonable_encoder(c) for c in companies],
        products=product_outputs
    )

@app.post("/submit-responses")
def submit_responses(
    answers: List[AnswerIn],
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
):
    for ans in answers:
        response = Response(
            user_id=current_user.user_id,
            question_id=ans.question_id,
            category_id=ans.category_id,
            product_id=ans.product_id,
            answer_text=ans.answer_text
        )
        db.add(response)
    db.commit()
    return {"msg": "Responses submitted successfully"}

@app.post("/seed-dummy-data")
def seed_dummy_data(db: Session = Depends(get_db)):
    categories = [
        Category(category_id=1, name="Smartphones"),
        Category(category_id=2, name="Laptops"),
        Category(category_id=3, name="Smart TVs")
    ]
    db.add_all(categories)

    questions = [
        Question(question_id=1, question_description="How satisfied are you with battery life?", question_code="Q_BATTERY"),
        Question(question_id=2, question_description="Is the display brightness satisfactory?", question_code="Q_DISPLAY"),
        Question(question_id=3, question_description="Is the sound quality good?", question_code="Q_SOUND"),
        Question(question_id=4, question_description="Does it support fast charging?", question_code="Q_FASTCHG")
    ]
    db.add_all(questions)

    db.commit()

    db.execute(question_category.insert().values([
        {"question_id": 1, "category_id": 1},
        {"question_id": 2, "category_id": 1},
        {"question_id": 4, "category_id": 1},
        {"question_id": 2, "category_id": 2},
        {"question_id": 4, "category_id": 2},
        {"question_id": 3, "category_id": 3}
    ]))

    companies = [
        Company(company_id=1, name="Samsung", country="Korea", sector="Electronics", parent_category=1),
        Company(company_id=2, name="Apple", country="USA", sector="Electronics", parent_category=1),
        Company(company_id=3, name="Lenovo", country="China", sector="Computers", parent_category=2)
    ]
    db.add_all(companies)

    products = [
        Product(product_id=1, name="iPhone 14", description="Flagship Apple phone", image_url="/img/iphone.jpg", company_id=2),
        Product(product_id=2, name="Galaxy S23", description="Samsung smartphone", image_url="/img/s23.jpg", company_id=1),
        Product(product_id=3, name="Lenovo Yoga", description="Touchscreen laptop", image_url="/img/yoga.jpg", company_id=3)
    ]
    db.add_all(products)

    db.commit()
    return {"msg": "Sample data seeded successfully"}

# ------------------ DB Init ------------------ #
Base.metadata.create_all(bind=engine)

