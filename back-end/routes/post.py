from supabase_client import supabase

from fastapi import APIRouter, Body
from pydantic import BaseModel
import base64, json

router = APIRouter()

class PostCreate(BaseModel):
    title: str
    description: str
    image: float

class ProfileCreate(BaseModel):
    # id: str
    username: str
    avatar_url: str | None = None
    bio: str | None = None
    role_id: int
    token_oauth: str

@router.get("/getPostsByAuthorId/{author_id}")
def get_posts_by_author_id(author_id: str):
    try:
        data = supabase.table("posts").select("*").eq("author_id", author_id).execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}

@router.get("/posts")
def get_posts(limit: int = 10, cursor: str | None = None):
    query = (
        supabase
        .table("posts")
        .select("""
            id,
            title,
            summary,
            image_url,
            link,
            tags,
            created_at,
            updated_at,
            author_id,

            profiles:author_id (
                id,
                username,
                avatar_url
            )
        """)
        .order("created_at", desc=True)
        .order("id", desc=True)
        .limit(limit)
    )

    if cursor:
        decoded = json.loads(base64.b64decode(cursor))
        query = query.or_(
            f"created_at.lt.{decoded['createdAt']},"
            f"and(created_at.eq.{decoded['createdAt']},id.lt.{decoded['id']})"
        )

    data = query.execute().data

    next_cursor = None
    if data:
        last = data[-1]
        next_cursor = base64.b64encode(json.dumps({
            "createdAt": last["created_at"],
            "id": last["id"]
        }).encode()).decode()

    return {
        "posts": data,
        "nextCursor": next_cursor
    }


@router.post("/countPostLikes")
def count_post_likes(payload: dict = Body(...)):
    try:
        post_ids = payload.get("post_ids", [])

        if not post_ids:
            return {"success": True, "data": {}}

        res = (
            supabase
            .table("post_liked")
            .select("post_id", count="exact")
            .in_("post_id", post_ids)
            .execute()
        )

        counts = {}
        for row in res.data:
            post_id = row["post_id"]
            counts[post_id] = counts.get(post_id, 0) + 1

        return {
            "success": True,
            "data": counts
        }

    except Exception as e:
        return {"success": False, "error": str(e)}

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
    
@router.post("/createProfile")
def create_profile(profile: ProfileCreate):
    print("Profiles !!!!!")
    try:
        data = supabase.table("profiles").insert({
            # "id": profile.id,
            "username": profile.username,
            "avatar_url": profile.avatar_url,
            "bio": profile.bio,
            "role_id": profile.role_id,
            "token_oauth": profile.token_oauth,
        }).execute()

        return {"success": True, "data": data.data}

    except Exception as e:
        return {"success": False, "error": str(e)}