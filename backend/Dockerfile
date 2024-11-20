FROM node:22-alpine3.19 as dev-dep
LABEL authors="12edwin"
WORKDIR /app
COPY package.json package.json
RUN yarn --frozen-lockfile

FROM node:22-alpine3.19 as dev-prod
LABEL authors="12edwin"
WORKDIR /app
COPY package.json package.json
RUN yarn --frozen-lockfile --production

FROM node:22-alpine3.19 as dev
LABEL authors="12edwin"
WORKDIR /app
COPY --from=dev-dep /app/node_modules ./node_modules
COPY . .
CMD ["./node_modules/.bin/nodemon"]

FROM node:22-alpine3.19 as builder
LABEL authors="12edwin"
WORKDIR /app
COPY --from=dev-dep /app/node_modules ./node_modules
COPY . .
# RUN jest ./src/app.ts

FROM node:22-alpine3.19 as prod
LABEL authors="12edwin"
EXPOSE 3000
EXPOSE 50051
EXPOSE 3001
WORKDIR /app
COPY --from=dev-prod /app/node_modules ./node_modules
COPY . .
CMD ["./node_modules/.bin/nodemon", "./src/app.ts"]