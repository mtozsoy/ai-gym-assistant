from fastapi import FastAPI
from app.routers import detect

# FastAPI uygulamasını başlatıyoruz
app = FastAPI(title="AI Gym Assistant API")

# Harici olarak tanımlanan detect router'ını ana uygulamamıza dahil ediyoruz
app.include_router(detect.router)
