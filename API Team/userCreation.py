from fastapi import FastAPI, HTTPException
from fake_db import fake_user_db
from pydantic import BaseModel, Field
from typing import Literal

app = FastAPI()

class UserCreate(BaseModel):
    name: str
    email: str
    age_range: Literal["18-20", "21-25", "26-30", "31-35","35-40", "40-50","51-55", "56-60", "61-70", "71-80", "80+"]  # fixed options
    pincode: int = Field(..., ge=100000, le=999999)       # basic 6-digit pin validation
    gender: Literal["Male", "Female", "Other"]
    employment_status: Literal["Employed", "Self-Employed", "Home-Maker", "Unemployed"]
    mobile_number: int =Field(..., ge=0000000000, le=9999999999) 

@app.post("/create-user")
def create_user(user: UserCreate):
    # Optional: Check for duplicates
    for existing_user in fake_user_db:
        if existing_user["name"] == user.name and existing_user["pincode"] == user.pincode:
            raise HTTPException(status_code=400, detail="User already exists")
    
    # Add user to fake db
    user_data = user.dict()
    fake_user_db.append(user_data)
    return {"message": "User created successfully", "user": user_data}
