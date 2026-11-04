FROM python:3.11-slim
WORKDIR /app
RUN pip install --no-cache-dir flask==3.0.0
COPY app.py .

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
    CMD python -c "import urllib.request; urllib.request.urlopen('http://localhost:5000/health')" || exit 1

EXPOSE 5000
CMD ["python", "app.py"]
