from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI(title="k3s-starter Sample App")

# Instrument the app to expose /metrics
Instrumentator().instrument(app).expose(app)


@app.get("/")
def read_root():
    return {"message": "Welcome to the k3s-starter FastAPI sample application!"}

@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Hello from k3s!"}
