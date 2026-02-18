from supabase_client import supabase

from fastapi import APIRouter

router = APIRouter()

@router.get("/profile")
def get_profile():
    try:
        data = supabase.table("profiles").select("*").execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}   

@router.get("/getProfileByEmail/{email}")
def get_profile_by_email(email: str):
    try:
        data = supabase.table("profiles").select("*").eq("email", email).execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}


@router.get("/items/{item_id}")
def read_item(item_id: int, q: str | None = None):
    return {"item_id": item_id, "q": q}