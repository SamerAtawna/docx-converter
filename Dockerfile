FROM node:20-slim

# Install LibreOffice + Hebrew fonts (culmus provides David CLM, Miriam CLM, etc.)
RUN apt-get update && apt-get install -y \
    libreoffice \
    fontconfig \
    fonts-liberation \
    fonts-dejavu-core \
    fonts-culmus \
    fonts-noto-core \
    --no-install-recommends \
  && rm -rf /var/lib/apt/lists/*

# Alias Windows Hebrew font names → culmus equivalents so LibreOffice
# resolves "David" (used in the DOCX) to "David CLM" (available on Linux)
RUN mkdir -p /etc/fonts/conf.d && cat > /etc/fonts/conf.d/99-hebrew-aliases.conf <<'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <alias><family>David</family><prefer><family>David CLM</family></prefer></alias>
  <alias><family>Miriam</family><prefer><family>Miriam CLM</family></prefer></alias>
  <alias><family>Arial</family><prefer><family>Liberation Sans</family></prefer></alias>
  <alias><family>Times New Roman</family><prefer><family>Liberation Serif</family></prefer></alias>
</fontconfig>
EOF

RUN fc-cache -f

WORKDIR /app

COPY package.json .
RUN npm install --omit=dev

COPY server.js .

EXPOSE 3000

CMD ["node", "server.js"]
