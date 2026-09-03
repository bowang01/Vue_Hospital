FROM node:18-bookworm-slim AS build
WORKDIR /app
ENV NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=2048"
ENV NPM_CONFIG_PRODUCTION=false
COPY package.json package-lock.json ./
RUN npm ci --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org
COPY . .
RUN unset CI && npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8082
