# 1. Usamos una base de Debian ligera
FROM debian:bookworm-slim AS base

# 2. Instalamos dependencias necesarias
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# 3. Instalamos la versión BASELINE de Bun correctamente
# Primero definimos la versión y luego pasamos el flag --baseline
RUN curl -fsSL https://bun.sh/install | bash -s -- bun-v1.1.0 --baseline

# 4. Configuramos el PATH
ENV PATH="/root/.bun/bin:${PATH}"

WORKDIR /app

# 5. Argumentos y variables de entorno
ARG CEREBRAS_API_KEY
ARG GROQ_API_KEY
ENV CEREBRAS_API_KEY=$CEREBRAS_API_KEY
ENV GROQ_API_KEY=$GROQ_API_KEY

# 6. Instalamos dependencias del proyecto
COPY package.json bun.lockb* ./
RUN bun install

# 7. Copiamos el resto del código
COPY . .

EXPOSE 3000
CMD ["bun", "run", "index.ts"]
