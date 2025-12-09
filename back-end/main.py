from typing import Union
from fastapi import FastAPI
from supabase import create_client
import os

app = FastAPI()

@app.get("/")
def read_root():
    try:
        url = os.environ["SUPABASE_URL"]
        key = os.environ["SUPABASE_KEY"]

        supabase = create_client(url, key)
        data = supabase.table("profiles").select("*").execute()
        return data.data
    except Exception as e:
        return {"error": str(e)}

@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}