# Etap bazowy
FROM node:22-alpine AS base
WORKDIR /app
COPY package*.json ./
RUN npm install

# Etap deweloperski (wykorzystywany przez docker-compose.override.yaml)
FROM base AS development
COPY . .
CMD ["npm", "run", "dev"]

# Etap produkcyjny (domyślny dla samego docker-compose.yaml)
FROM base AS production
COPY . .
CMD ["npm", "start"]
