# Obraz do budowania
FROM python:3.11-slim AS builder

# Wyłączenie tworzenia skompilowanego kodu bajtowego, celem oszczędzania miejsca na dysku i zmniejszenia operacji I/O
ENV PYTHONDONTWRITEBYTECODE=1

WORKDIR /app

# Środowisko wirtualne
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

# Instalacja zależności w celu umożliwienia ich cachowania
COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt


# Obraz dla runtime
FROM python:3.11-slim AS runner

ENV PYTHONDONTWRITEBYTECODE=1 \
    PATH="/opt/venv/bin:$PATH"

WORKDIR /app

# Utworzenie grupy i użytkownika niebędącego rootem dla bezpieczeństwa
RUN groupadd -g 10001 appuser && \
    useradd -u 10001 -g appuser -s /bin/sh appuser

COPY --from=builder /opt/venv /opt/venv
COPY --chown=appuser:appuser . .

USER appuser

CMD ["python", "main.py"]
