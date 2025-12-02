from typing import Union
import json
import psycopg2
from fastapi import FastAPI
from supabase import create_client, Client

url = "https://cnloedhcnffbfucxoiqb.supabase.co/"
key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNubG9lZGhjbmZmYmZ1Y3hvaXFiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjI4NTA5OTEsImV4cCI6MjA3ODQyNjk5MX0.RCPogOS3JztbWnErbqKP3SUorR2jwUnOjME3VExc19Q"


app = FastAPI()

@app.get("/")
def read_root():
    try:
        supabase: Client = create_client(url, key)
        data = supabase.table("profiles").select("*").execute()
        return data.data

    except Exception as e:
        print(f"Failed to connect: {e}")


@app.get("/items/{item_id}")
def read_item(item_id: int, q: Union[str, None] = None):
    return {"item_id": item_id, "q": q}
