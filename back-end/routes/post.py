from supabase_client import supabase

from fastapi import APIRouter
from pydantic import BaseModel
import base64, json

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
            ),

            post_liked(count)
        """)
        .order("created_at", desc=True)
        .limit(limit)
    )
    if cursor:
        decoded = json.loads(base64.b64decode(cursor))

        query = query.or_(
            f"created_at.lt.{decoded['createdAt']},"
            f"and(created_at.eq.{decoded['createdAt']},id.lt.{decoded['id']})"
        )
    data = query.execute().data

    for post in data:
        post["likes"] = post["post_liked"]["count"] if post.get("post_liked") else 0
        del post["post_liked"]

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