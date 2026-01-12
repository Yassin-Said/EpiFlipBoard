from fastapi import FastAPI
from routes.profile import router as profile_router
from routes.post import router as post_router
from routes.comment import router as comment_router

app = FastAPI(
    swagger_ui_parameters={"syntaxHighlight": False}
)

app.include_router(profile_router)
app.include_router(post_router)
app.include_router(comment_router)

@app.get("/")
def root():
    return {"status": "ok"}