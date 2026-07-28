from fastapi import FastAPI, Request

# FastAPI uygulamasını başlatıyoruz
app = FastAPI(title="AI Gym Assistant API")

# POST metodunu dinleyecek /detect endpoint'i
@app.post("/detect")
async def detect_machine(request: Request):
    # İleride gönderilen fotoğraf veya JSON verisi bu 'request' nesnesinden alınacak.
    # Şimdilik doğrudan istenilen statik veriyi dönüyoruz.
    return {
        "machine": "Leg Press",
        "muscles": [
            "Quadriceps",
            "Glutes"
        ]
    }
