from supabase_client import supabase

from fastapi import APIRouter
from pydantic import BaseModel
import base64, json

router = APIRouter()

class CollectionProfileCreate(BaseModel):
    title: str
    author_id: str

class CollectionCreate(BaseModel):
    post_id: str
    collection_id: str

@router.post("/createProfileCollection")
def create_profile_collection(collection: CollectionProfileCreate):
    try:
        data = supabase.table("profile_collection").insert({
            "name": collection.title,
            "author_id": collection.author_id
        }).execute()
        return {"success": True, "data": data.data}
    except Exception as e:
        return {"error": str(e)}

@router.get("/getProfileCollection/{author_id}")
def get_profile_collection(author_id: str):
    try:
        data = supabase.table("profile_collection").select("*").eq("author_id", author_id).execute()
        return {"success": True, "data": data.data}
    except Exception as e:
        return {"error": str(e)}

@router.post("/createCollection")
def create_collection(collection: CollectionCreate):
    try:
        data = supabase.table("collection").insert({
            "post_id": collection.post_id,
            "profile_collection_id": collection.collection_id
        }).execute()
        return {"success": True, "data": data.data}
    except Exception as e:
        return {"error": str(e)}

@router.get("/getCollection/{profile_collection_id}")
def get_collection(profile_collection_id: str):
    try:
        data = supabase.table("collection").select("*").eq("profile_collection_id", profile_collection_id).execute()
        return {"success": True, "data": data.data}
    except Exception as e:
        return {"error": str(e)}