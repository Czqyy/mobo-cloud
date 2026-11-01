# Multi-objective Optimisation (MOBO) of Cloud Infrastructure
## Running Web Server with Uvicorn
```bash
uvicorn workload.main:app --host 0.0.0.0 --port 8000 --reload
```

## Build Docker Container
From working directory, build a Docker image:
```bash
docker build -t <image-name> .
```
Start the container:
```bash
docker run --rm --name <container-name> -p 8000:8000 <image-name>
```