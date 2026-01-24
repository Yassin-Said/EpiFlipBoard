import feedparser
import httpx
from datetime import datetime
from supabase_client import supabase, RSS_CATEGORIES
from bs4 import BeautifulSoup
from apscheduler.schedulers.asyncio import AsyncIOScheduler

mediaUuid = {
    "lactualite.com" : "f067b4de-7fe0-436c-8f61-da5d9bb38802",
    "franceinfo": "18d614c0-155a-4019-a1fc-3390e105d0e6",
    "7sur7": "18df2d10-10ee-4ac9-8094-085a6fc42e82",
    "01net": "684b77e3-644c-4cc9-aebf-9b73975869c9",
    "20minutes": "0fcbf378-8244-4031-b4d3-2626e79d9be2",
    "bfmtv": "0bf3d415-5cd8-43b8-8b36-af996fe95caa",
    "lexpress": "e8aebc8c-387e-468d-8a5e-aa16a71f4c04",
    "lindependant": "9b405ed1-e400-4fbf-af6d-1bf23a6507a5",
    "foot-sur7" : "ed35fc1d-e88d-42c7-97bf-15e5d313eb9a"
}
scheduler = AsyncIOScheduler()
articles = []

def extract_image(url, entry):
    if 'media_content' in entry:
        return entry.media_content[0].get('url')

    if 'enclosures' in entry and entry.enclosures:
        return entry.enclosures[0].get('url')
    
    if 'summary' in entry:
        soup = BeautifulSoup(entry.summary, 'html.parser')
        img = soup.find('img')
        if img and img.get('src'):
            return img['src']
    return None

async def fetch_rss(url: str, tags:str):
    async with httpx.AsyncClient(timeout=10) as client:
        response = await client.get(url)
        response.raise_for_status()

    feed = feedparser.parse(response.text)

    for entry in feed.entries:
        articles.append({
            "rss_url": url,
            "tags": tags,
            "title": entry.get("title"),
            "summary": entry.get("summary"),
            "link": entry.get("link"),
            "image_url": extract_image(url, entry),
            "author_id": ""
        })

def dedupe_links(currentArticle):
    seen = []
    unique_articles = []
    for article in currentArticle:
        if article["link"] not in seen:
            seen.append(article["link"])
            unique_articles.append(article)
    return unique_articles

def save_articles(clearedArticles):
    supabase.table("posts") \
        .upsert(clearedArticles, on_conflict="link") \
        .execute()
    print("saved")

def find_profile():
    for article in articles:
        found = False
        for name, uuid in mediaUuid.items():
            if name in article["rss_url"]:
                article["author_id"] = uuid
                found = True
                break
        if found == False:
            print("Didn't find uuid: ", article["rss_url"])

@scheduler.scheduled_job("interval", minutes=60)
async def update_all_feeds():
    for key, urls in RSS_CATEGORIES.items():
        for url in urls: 
            await fetch_rss(url, key)
    find_profile()
    clearedArticles = dedupe_links(articles)
    save_articles(clearedArticles)
