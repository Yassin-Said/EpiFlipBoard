from supabase_client import supabase

from pydantic import BaseModel
from fastapi import APIRouter

router = APIRouter()

class ProfileCreate(BaseModel):
    username: str
    avatarUrl: str
    role: int

@router.get("/profile")
def get_profile():
    try:
        data = supabase.table("profiles").select("*").execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}

@router.post("/createProfile")
def create_profile(profile: ProfileCreate):
    try:
        data = supabase.table("profiles").insert({
            "username": profile.username,
            "avatar_url": profile.avatarUrl,
            "role_id":profile.role
        }).execute()
        return {"success": "Profile created", "data" : data}
    except Exception as e:
        return {"error": str(e)}