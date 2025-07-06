from fastapi import FastAPI,Request,status,HTTPException,Form
from fastapi.security import HTTPAuthorizationCredentials,HTTPBearer
from fastapi import Security
from passlib.context import CryptContext
from jose import JWTError,jwt
from datetime import timedelta,datetime,UTC

SECRET_KEY="mysecretkey"
ALGORITHM="HS256"
ACCESS_EXPIRES_TIME_MINUTES =30


app=FastAPI()


fake_db={
    "kausik":{
        "username":"kausik",
        "hashed_password":"$2b$12$TzVmEtfO7tjVJh1XK/4ZbuemVsIT.38KGT8U4YH.EvekFgMdWYKj6"
    }
}


pwd_context=CryptContext(schemes=['bcrypt'],deprecated="auto")
#u are hashing the password and comparing it with hashed password

#to place the token field manually
security_scheme=HTTPBearer()


async def verify_password(plain_password:str,hashed_password:str):
    return pwd_context.verify(plain_password,hashed_password)

#here u r authenticating the user here
async def authenticate_user(username:str,password:str):
    user=fake_db.get(username)
    if not user:
        return None
    if not await verify_password(password,user["hashed_password"]):
        return None
    return user
#here u are encoding or signing the token using the secret key and the algorithm which is HS256
async def create_access_token(data:dict,expires_delta:timedelta=None):
    to_encode=data.copy()
    if expires_delta:
        expire=datetime.now(UTC)+expires_delta
    else:
        expire =datetime.now(UTC)+timedelta(minutes=5)
    to_encode.update({'exp':int(expire.timestamp())})
    return jwt.encode(to_encode,SECRET_KEY,ALGORITHM)

#the route in which u are expected to get a token
@app.post('/token')
async def login(username =Form(...),password=Form(...)):
    user = await authenticate_user(username,password)
    if user is None:
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,detail="invalid username or password")
    
    access_token = await create_access_token(data={"sub":user["username"]})
    return {"access_token":access_token,"token_type":"Bearer"}

@app.get("/secure-data/")
async def get_secure_data(credentials:HTTPAuthorizationCredentials=Security(security_scheme)):
    token =credentials.credentials
    #gets the tokenvalue from the credentials variable and the Bearer string is stored in the scheme var
    
    #now we have to decode the token and we have to get the required payload
    try:
        payload =jwt.decode(token,SECRET_KEY,algorithms=[ALGORITHM])
        username=payload.get("sub")
        expire_time=payload.get("exp")
        if datetime.now(UTC).timestamp() > expire_time:
            raise HTTPException(status_code=401,detail="token has expired")
        if not username:
            raise HTTPException(status_code=401,detail="invalid token payload")
    except JWTError:
        #this error implies that the token had expired
        raise HTTPException(status_code=401,detail="invalid token")
    
    return {"message":f"hello {username},here is ur secure data"}
    
    





