from supabase_client import supabase

from fastapi import APIRouter


router = APIRouter()

@router.get("/getCommentsByPostId/{post_id}")
def get_comments_by_post_id(post_id : int):
    try:
        data = supabase.table("comments").select("*").eq("post_id",post_id).execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}
