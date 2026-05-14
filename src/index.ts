import type { Request, Response } from 'express';
const express = require('express');

const app = express();
const PORT = process.env.PORT || 8080;

const FAKE_API_KEY = "SG.x9832148901234.FAKE_KEY_FOR_TESTING"; 

app.get('/', (req: Request, res: Response) => {
  res.json({
    message: "Bienvenue sur l'API Sécurisée! Voici une clé API fictive pour les tests :",
    apiKey: FAKE_API_KEY,
    status: "EN LIGNE test",
  });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Serveur démarré sur http://localhost:${PORT}`);
});