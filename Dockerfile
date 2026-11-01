FROM python:3.13

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt "uvicorn[standard]"

COPY workload/ ./workload/

EXPOSE 8000

CMD ["uvicorn", "workload.main:app", "--host", "0.0.0.0", "--port", "8000"]
