import os
import shutil
from fastapi import FastAPI, File, UploadFile

# FastAPI uygulamasını başlatıyoruz
app = FastAPI(title="AI Gym Assistant API")

# Kaydedilecek fotoğraflar için klasör adını belirliyoruz
UPLOAD_DIR = "uploads"

# Eğer uploads klasörü yoksa projede bu klasörü oluşturuyoruz
os.makedirs(UPLOAD_DIR, exist_ok=True)

# POST metodunu dinleyecek ve multipart/form-data kabul edecek endpoint
@app.post("/detect")
async def detect_machine(file: UploadFile = File(...)):
    # Dosyanın kaydedileceği tam disk yolunu oluşturuyoruz (uploads/fotograf.jpg gibi)
    file_path = os.path.join(UPLOAD_DIR, file.filename)
    
    # Gelen dosyayı byte byte okuyup sunucudaki (file_path) konumuna yazıyoruz
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    # Başarılı kayıt sonrası istenen başarı mesajını JSON olarak dönüyoruz
    return {
        "message": "Fotoğraf başarıyla alındı"
    }
