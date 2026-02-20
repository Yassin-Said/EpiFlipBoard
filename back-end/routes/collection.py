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

class CollectionDelete(BaseModel):
    profile_collection_id: str
    post_id: str

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

@router.delete("/deleteCollection")
def delete_collection(params: CollectionDelete):
    try:
        data = supabase.table("collection").delete().eq("profile_collection_id", params.profile_collection_id).eq("post_id", params.post_id).execute()
        return {"success": True, "data": data}

    except Exception as e:
        return {"error": str(e)}
    
@router.delete("/deleteCollectionById/{id}")
def delete_collection():
    try:
        data = supabase.table("collection").delete().eq("id", id).execute()
        return {"success": True, "data": data}

    except Exception as e:
        return {"error": str(e)}

@router.delete("/deleteProfileCollection/{profile_collection_id}")
def delete_profile_collection(profile_collection_id: str):
    try:
        data = supabase.table("collection").delete().eq("profile_collection_id", profile_collection_id).execute()
        data2 = supabase.table("profile_collection").delete().eq("id", profile_collection_id).execute()
        return {"success": True, "data": data,"data2": data2}

    except Exception as e:
        return {"error": str(e)}