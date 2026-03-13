const express = require('express');
const { convert } = require('libreoffice-convert');
const { promisify } = require('util');

const convertAsync = promisify(convert);
const app = express();

// CORS — allow mobile app WebView origin
app.use((req, res, next) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  if (req.method === 'OPTIONS') return res.sendStatus(200);
  next();
});

// Health check — Render uses this to detect the service is up
app.get('/health', (_req, res) => res.json({ ok: true }));

// POST /convert — body: raw DOCX bytes, response: PDF bytes
app.post(
  '/convert',
  express.raw({ type: 'application/octet-stream', limit: '50mb' }),
  async (req, res) => {
    if (!req.body || !req.body.length) {
      return res.status(400).json({ error: 'No file data received' });
    }
    try {
      const pdfBuffer = await convertAsync(req.body, '.pdf', undefined);
      res.set('Content-Type', 'application/pdf');
      res.set('Content-Length', pdfBuffer.length);
      res.send(pdfBuffer);
    } catch (err) {
      console.error('Conversion error:', err);
      res.status(500).json({ error: err.message ?? 'Conversion failed' });
    }
  }
);

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Docx converter running on port ${PORT}`));
