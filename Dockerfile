# ÉTAPE 1 : Build
FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# On force la création du dossier dist et on lance le build
RUN npx tsc || (echo "Erreur de compilation TS" && exit 1)

# ÉTAPE 2 : Production
FROM node:20-alpine
COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.1 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app
COPY --from=builder /app/package*.json ./

# C'est ici que ça bloquait : on vérifie que dist existe bien avant de copier
COPY --from=builder /app/dist ./dist

RUN npm install --omit=dev

ENV PORT=8080
CMD ["node", "dist/index.js"]