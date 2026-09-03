FROM node:18-bookworm-slim AS build
WORKDIR /app
ENV NPM_CONFIG_PRODUCTION=false
ENV CI=
ENV NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=768"
COPY package.json package-lock.json ./
RUN npm ci --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org
COPY . .
RUN npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8082
