# Stage 1: Build the application
FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

RUN npm run build

# Stage 2: Serve the application
FROM node:18-alpine

WORKDIR /app

COPY --from=build /app/.nuxt ./.nuxt/
COPY --from=build /app/.output /app/.output
COPY --from=build /app/nuxt.config.ts ./nuxt.config.ts

ENV NODE_ENV production

EXPOSE 3000

CMD [ "node", ".output/server/index.mjs" ]