import type { Request, Response } from 'express';
const express = require('express');

const app = express();
const PORT = process.env.PORT || 3000;

const FAKE_API_KEY = "SG.x9832148901234.FAKE_KEY_FOR_TESTING"; 

app.get('/', (req: Request, res: Response) => {
  res.json({
    message: "Bienvenue sur l'API Sécurisée ! to test the security measures, use the following API key in the 'Authorization' header: " + FAKE_API_KEY,
    status: "En ligne"
  });
});

app.listen(PORT, () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});