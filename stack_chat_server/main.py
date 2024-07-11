from fastapi import FastAPI, HTTPException
from config.gemini import model
from model.chat_request import ChatRequest



app = FastAPI()



chat_session = model.start_chat()

@app.get("/")
async def root():
    response = chat_session.send_message("Hey Stack")
    return {"response": response.text}

@app.post("/chat/")
async def chat(chat_request: ChatRequest):
    try:
        response = chat_session.send_message(chat_request.message)
        return { "response": response.text}
    except Exception as e:
        return {"response": "Sorry, something went wrong in my otaku brain. Please try again later."}


