FROM python:3.11-slim

# Tworzenie użytkownika
RUN groupadd -r appuser && useradd -r -g appuser -d /app appuser

WORKDIR /app
COPY --chown=appuser:appuser app.py .

# Przełączenie na nie-root
USER appuser

CMD ["python", "-c", "import os; print(f'UID: {os.getuid()}, User: {os.getenv(\"USER\", \"appuser\")}')"]
