FROM node:20-alpine AS builder

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

RUN npx tsc || (echo "Erreur de compilation TS" && exit 1)

FROM node:20-alpine

COPY --from=public.ecr.aws/awsguru/aws-lambda-adapter:0.8.4 /lambda-adapter /opt/extensions/lambda-adapter

WORKDIR /app

COPY --from=builder /app/package*.json ./
COPY --from=builder /app/dist ./dist

RUN npm install --omit=dev

ENV PORT=8080
EXPOSE 8080

USER node

CMD ["node", "dist/index.js"]