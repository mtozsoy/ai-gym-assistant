import os
import shutil
import cv2
from fastapi import UploadFile, HTTPException
from ultralytics import YOLO

# Yüklenen dosyaların kaydedileceği klasör
UPLOAD_DIR = "uploads"
os.makedirs(UPLOAD_DIR, exist_ok=True)

# YOLOv8n (nano) modelini uygulama başlarken 1 kez yüklüyoruz
# Model dosyası yoksa otomatik olarak indirecektir
model = YOLO("runs/detect/gym_machine_detector/weights/best.pt")

def process_image(file: UploadFile) -> dict:
    # Dosyanın kaydedileceği tam yolu oluşturuyoruz
    file_path = os.path.join(UPLOAD_DIR, file.filename)
    
    # Gelen dosyayı diske yazıyoruz
    with open(file_path, "wb") as buffer:
        shutil.copyfileobj(file.file, buffer)
        
    # OpenCV ile resmi okuyoruz
    img = cv2.imread(file_path)
    
    if img is None:
        os.remove(file_path)
        raise HTTPException(status_code=400, detail="Geçersiz fotoğraf formatı veya bozuk dosya.")
        
    height, width, channels = img.shape
    
    # Resmi YOLO modeline gönderip tahmin sonuçlarını alıyoruz
    results = model(img, conf=0.6)
    
    detected_objects = []
    
    # YOLO'nun döndürdüğü sonuçlardan sınıf adlarını ve güven skorlarını çekiyoruz
    for result in results:
        # result.boxes tespit edilen her bir nesnenin kutusunu içerir
        for box in result.boxes:
            class_id = int(box.cls[0])           # Sınıf ID'si (örneğin 0)
            class_name = model.names[class_id]   # Sınıfın gerçek adı (örneğin 'person')
            confidence = float(box.conf[0])      # Yüzdelik güven skoru (0.0 ile 1.0 arası)
            
            detected_objects.append({
                "name": class_name,
                "confidence": round(confidence, 3)
            })
    
    # İhtiyacımız olan bilgileri döndürüyoruz
    return {
        "width": width,
        "height": height,
        "channels": channels,
        "detections": detected_objects
    }
