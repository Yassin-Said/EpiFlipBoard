from supabase_client import supabase

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class PostCreate(BaseModel):
    title: str
    description: str
    image: float

@router.get("/getPostsByAuthorId/{author_id}")
def get_posts_by_author_id(author_id: str):
    try:
        data = supabase.table("posts").select("*").eq("author_id", author_id).execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}

@router.get("/getPosts")
def get_posts():
    try:
        data = supabase.table("posts").select("*").execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}

@router.post("/createPost")
def create_post(post: PostCreate):
    try:
        data = supabase.table("posts").insert({
            "title": post.title,
            "description": post.description
        }).execute()
        return {"success": True, "data": data.data}
    except Exception as e:
        return {"error": str(e)}