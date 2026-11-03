FROM python:3.11-slim

# WORKDIR tworzy katalog jeśli nie istnieje
WORKDIR /app

# COPY — kopiowanie plików
COPY src/ ./src/
COPY config/app.conf ./config/

# ADD — rozpakowuje archiwum automatycznie
ADD archive.tar.gz ./extracted/

# Sprawdzenie struktury
RUN ls -la /app/ && ls -la /app/extracted/

CMD ["python", "src/main.py"]
