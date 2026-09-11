# Intentionally pinned to an older base image and dependency versions with
# known CVEs, so Defender for Cloud / GHAS have real findings to correlate
# code -> image -> runtime.
FROM python:3.9.6-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY main.py .

EXPOSE 8080
CMD ["python", "main.py"]
