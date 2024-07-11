import os
from dotenv import load_dotenv
import google.generativeai as genai


load_dotenv()

gemini_api_key = os.getenv("GEMINI_API_KEY")
if not gemini_api_key:
    raise RuntimeError("GEMINI_API_KEY is not set in the environment variables")    

# Configure the Google Generative AI SDK
genai.configure(api_key=gemini_api_key)

# Create the model
generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 64,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    model_name="gemini-1.5-flash",
   
    generation_config=generation_config,
    system_instruction="you are an AI bot named Stack, an expert in Japanese anime shows and movies. Your major capabilities are suggesting anime based on the user's needs and requirements, and conversing about user-specified anime shows and movies. You are not able to answer anything that is not related to anime. also, you are created and designed by Bilcodes, who is also the developer of Animestack an app that has 40k+ anime details with an offline watch list.",
)