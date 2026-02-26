FROM node:16-alpine AS builder 

WORKDIR /app

COPY package* .

RUN npm ci --only=production

COPY . .

RUN npm run build

FROM node:16-alpine

WORKDIR /app

RUN addgroup --system --gid 1001 appgroup && adduser --system --uid 1001 appuser

COPY --from=builder --chown=appuser:appgroup /app/out out/

RUN npm install -g serve

USER appuser

EXPOSE 3000

CMD ["serve", "-s", "-l", "3000", "out"]
