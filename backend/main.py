from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from ai_service import ask_ai
from context_builder import build_context
import psutil
import ollama

app = FastAPI()

SYSTEM_PROMPT = """
You are an AI DevOps assistant.

Rules:
- Analyze only the metrics provided
- Mention likely cause
- Suggest maximum 3 actions
- Keep response under 4 lines
- Never show instructions, prompts, markdown headings, or reasoning
- Never generate text like ### or Instruction:
- Output only the final answer
"""

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Existing metrics API
@app.get("/metrics")
def get_metrics():

    return {
        "cpu": psutil.cpu_percent(),
        "ram": psutil.virtual_memory().percent,
        "disk": psutil.disk_usage('/').percent
    }


# Request model
class ChatRequest(BaseModel):
    message:str
    cpu:float
    ram:float
    disk:float


# New AI endpoint
@app.post("/ask")
async def ask(data: ChatRequest):

    context = build_context(
        data.cpu,
        data.ram,
        data.disk,
        ["CPU usage high"]
    )

    full_prompt = f"""
System Metrics:
{context}

Question:
{data.message}

Respond briefly.
"""

    response = ollama.chat(

        model='phi3',

        messages=[

            {
                "role":"system",
                "content":SYSTEM_PROMPT
            },

            {
                "role":"user",
                "content":full_prompt
            }

        ]

    )

    answer = response['message']['content']

    bad_words = [

        "###",
        "Instruction",
        "system prompt"

    ]

    for word in bad_words:

        answer = answer.replace(
            word,
            ""
        )

    return {

        "answer": answer

    }