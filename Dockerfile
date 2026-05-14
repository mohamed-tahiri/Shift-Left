# ÉTAPE 1 : Build (Analyse statique et compilation)
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# Compilation TypeScript
RUN npx tsc || (echo "Erreur de compilation TS" && exit 1)

# ÉTAPE 2 : Production (Image légère et sécurisée)
FROM node:20-alpine

# Utilisation de la version amd64 de l'adapter pour éviter l'erreur d'architecture 
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.1-amd64 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app

# Récupération uniquement des fichiers nécessaires
COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

# Installation des dépendances de production uniquement
RUN npm install --omit=dev

# Configuration pour Lambda Web Adapter
ENV PORT=8080
EXPOSE 8080

# Utilisateur non-root pour la sécurité (Shift-Left)
USER node

CMD ["node", "dist/index.js"]