FROM node:20-slim

# Install LibreOffice + base fonts
RUN apt-get update && apt-get install -y \
    libreoffice \
    fontconfig \
    fonts-liberation \
    fonts-dejavu-core \
    fonts-noto-core \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Install the actual Microsoft David Hebrew font (copied from Windows)
COPY david.ttf   /usr/share/fonts/truetype/microsoft/David.ttf
COPY davidbd.ttf /usr/share/fonts/truetype/microsoft/DavidBold.ttf

RUN fc-cache -f

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
