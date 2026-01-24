from supabase import create_client
import os
from dotenv import load_dotenv

load_dotenv()

SUPABASE_URL = os.getenv("SUPABASE_URL")
SUPABASE_KEY = os.getenv("SUPABASE_KEY")
RSS_CATEGORIES = {
    "Divers": [
        url.strip()
        for url in os.getenv("RSS_SOCIETE_FEEDS", "").split(",")
        if url.strip()
    ],
    "Foot": [
        url.strip()
        for url in os.getenv("RSS_FOOT_FEEDS", "").split(",")
        if url.strip()
    ],
    "Tennis": [
        url.strip()
        for url in os.getenv("RSS_TENNIS_FEEDS", "").split(",")
        if url.strip()
    ],
    "Politique": [
        url.strip()
        for url in os.getenv("RSS_POLITIQUE", "").split(",")
        if url.strip()
    ],
}

supabase = create_client(SUPABASE_URL, SUPABASE_KEY)