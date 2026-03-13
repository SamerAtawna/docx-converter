FROM node:20-slim

# Install LibreOffice and fonts (required for DOCX → PDF conversion)
RUN apt-get update && apt-get install -y \
    libreoffice \
    fonts-liberation \
    fonts-dejavu \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
