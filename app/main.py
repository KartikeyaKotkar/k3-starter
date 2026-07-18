from fastapi import FastAPI

app = FastAPI(title="k3s-starter Sample App")

@app.get("/")
def read_root():
    return {"message": "Welcome to the k3s-starter FastAPI sample application!"}

@app.get("/health")
def health_check():
    return {"status": "ok", "message": "Hello from k3s!"}
