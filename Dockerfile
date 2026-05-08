# Utilisation d'une version spécifique pour éviter les surprises
FROM node:18-slim

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npx tsc

EXPOSE 3000

USER node

CMD ["node", "dist/index.js"]