import os
import shutil
import cv2
from fastapi import UploadFile, HTTPException

# Yüklenen dosyaların kaydedileceği klasör
UPLOAD_DIR = "uploads"

# Sunucu başlarken klasörün var olduğundan emin oluyoruz
os.makedirs(UPLOAD_DIR, exist_ok=True)

def process_image(file: UploadFile) -> dict:
    # Dosyanın kaydedileceği tam yolu oluşturuyoruz
    file_path = os.path.join(UPLOAD_DIR, file.filename)
    
    # Gelen dosyayı diske yazıyoruz
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    # OpenCV ile resmi okuyoruz
    img = cv2.imread(file_path)
    
    if img is None:
        # Hatalı/Bozuk dosyayı sunucuda tutmuyoruz
        os.remove(file_path)
        raise HTTPException(status_code=400, detail="Geçersiz fotoğraf formatı veya bozuk dosya.")
        
    # Resim verilerini alıyoruz
    height, width, channels = img.shape
    
    # İhtiyacımız olan bilgileri sözlük (dict) olarak geri dönüyoruz
    return {
        "width": width,
        "height": height,
        "channels": channels
    }
