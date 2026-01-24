from supabase_client import supabase

from fastapi import APIRouter
from pydantic import BaseModel

router = APIRouter()

class PostCreate(BaseModel):
    title: str
    description: str
    image: float

class PostCreate(BaseModel):
    postId: str
    profileId: str


@router.get("/getPostsByAuthorId/{authorId}")
def get_posts_by_author_id(authorId: str):
    try:
        data = supabase.table("posts").select("*").eq("author_id", authorId).execute()
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
        return {"data": data.data}
    except Exception as e:
        return {"error": str(e)}
    
@router.post("/likePost")
def like_post(post: PostCreate):
    try:
        data = supabase.table("post_liked").insert({
            "post_id": post.postId,
            "profile_id": post.profileId
        }).execute()
        return {"data": data.data}
    except Exception as e:
        return {"error": str(e)}

@router.get("/getPostLike/{postId}")
def like_post(postId: str):
    try:
        data = supabase.table("post_liked").count("*").eq("post_id", postId)
        return {"data": data.data}
    except Exception as e:
        return {"error": str(e)}