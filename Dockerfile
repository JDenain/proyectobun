# 1. Usamos una base de Debian ligera
FROM debian:bookworm-slim AS base

# 2. Instalamos dependencias necesarias (curl y unzip)
RUN apt-get update && apt-get install -y curl unzip && rm -rf /var/lib/apt/lists/*

# 3. Instalamos la versión BASELINE de Bun
# Esto descarga el binario compatible con CPUs que no tienen AVX2
RUN curl -fsSL https://bun.sh/install | bash -s -- --baseline

# 4. Configuramos la variable de entorno para que el sistema encuentre Bun
ENV PATH="/root/.bun/bin:${PATH}"

WORKDIR /app

# 5. Mantén tus argumentos para las API Keys si los necesitas en el build
ARG CEREBRAS_API_KEY
ARG GROQ_API_KEY
ENV CEREBRAS_API_KEY=$CEREBRAS_API_KEY
ENV GROQ_API_KEY=$GROQ_API_KEY

# 6. Instalamos las dependencias de tu proyecto
COPY package.json bun.lockb* ./
RUN bun install

# 7. Copiamos el resto del código
COPY . .

# Ajusta "index.ts" al nombre de tu archivo principal si es diferente
EXPOSE 3000
CMD ["bun", "run", "index.ts"]
