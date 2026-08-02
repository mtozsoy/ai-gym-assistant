from ultralytics import YOLO

model = YOLO("yolov8n.pt")

model.train(
    data ="dataset/data.yaml",
    epochs = 50, # 50 Kez bütün fotoğraflara bakıyoruz. 1 epoch = Bütün fotoları 1 kez görmek.
    imgsz = 640,
    batch = 8,
    name  = "gym_machine_detector"

)