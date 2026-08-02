from fastapi import APIRouter, File, UploadFile
from app.services.image_service import process_image

# Bu dosyaya özel router (yönlendirici) nesnesini oluşturuyoruz
router = APIRouter()

@router.post("/detect")
async def detect_machine(file: UploadFile = File(...)):
    # Resim kaydetme ve boyut bulma işlemlerini Service katmanına devrettik
    result = process_image(file)
    
    # İşlemden dönen sonucu formatlayarak istemciye iletiyoruz
    return {
        "message": "Fotoğraf başarıyla işlendi",
        "width": result["width"],
        "height": result["height"],
        "channels": result["channels"],
        "detections": result["detections"]
    }
