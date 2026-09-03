FROM node:18-bookworm-slim AS build
WORKDIR /app
ENV CI=
ENV NODE_OPTIONS="--openssl-legacy-provider --max-old-space-size=768"
COPY . .
RUN NODE_ENV=development npm ci --include=dev --no-audit --no-fund --registry=https://registry.npmjs.org \
    && test -f node_modules/@vue/cli-service/bin/vue-cli-service.js
RUN NODE_ENV=production npm run build

FROM nginx:1.27-alpine
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8082
