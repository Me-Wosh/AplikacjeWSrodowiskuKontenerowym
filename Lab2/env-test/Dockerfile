# ARG — dostępny tylko podczas budowania
ARG PYTHON_VERSION=3.11

FROM python:${PYTHON_VERSION}-slim

# ENV — dostępny w kontenerze
ENV APP_NAME="Moja Aplikacja" \
    APP_VERSION="1.0.0" \
    ENVIRONMENT="production"

WORKDIR /app
COPY app.py .

# ARG po FROM musi być ponownie zadeklarowany
ARG BUILD_DATE
LABEL build_date=${BUILD_DATE}

CMD ["python", "app.py"]
