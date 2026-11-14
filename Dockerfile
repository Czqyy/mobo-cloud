FROM python:3.13

WORKDIR /app

COPY requirements.txt .
RUN python -m pip install --no-cache-dir -r requirements.txt "uvicorn[standard]"

COPY workload/ ./workload/

EXPOSE 8000

CMD ["uvicorn", "workload.main:app", "--host", "0.0.0.0", "--port", "8000"]

HEALTHCHECK --interval=15s --timeout=5s --start-period=10s --retries=3 \
  CMD python -c "import requests; requests.get('http://127.0.0.1:8000/health', timeout=3).raise_for_status()" || exit 1
