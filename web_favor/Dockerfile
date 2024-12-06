FROM node:21-alpine AS build-stage
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

FROM nginx:latest AS prod
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80