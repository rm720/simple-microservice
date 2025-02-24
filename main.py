from fastapi import FastAPI
import uvicorn
from mylib.logic import search_wiki
from mylib.logic import wiki as wikilogic

app = FastAPI()


@app.get("/")
async def root():
    return {"message": "Wikipedia API. Call /search or /wiki"}


@app.get("/search/{value}")
async def search(value: str = "Barack"):
    """Page to search in wikipedia"""
    result = search_wiki(value)
    return {"result": result}


@app.get("/wiki/{value}")
async def wiki(value: str = "Barack"):
    """Page to search in wikipedia"""
    result = wikilogic(value)
    return {"result": result}


if __name__ == "__main__":
    uvicorn.run(app, port=8080, host="0.0.0.0")
