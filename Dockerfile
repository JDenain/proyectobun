# Usamos la imagen baseline que es compatible con CPUs más antiguas
FROM ovosadia/bun:1.1-baseline AS base
WORKDIR /app

# Instalar dependencias
COPY package.json bun.lockb ./
RUN bun install --frozen-lockfile

# Copiar el resto del código
COPY . .

# Comando para iniciar la app (ajusta 'index.ts' según tu archivo principal)
EXPOSE 3000
CMD ["bun", "run", "index.ts"]
