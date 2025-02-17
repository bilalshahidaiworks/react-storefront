FROM node:16
WORKDIR /app

# Setup pnpm package manager
RUN npm install -g pnpm@7.5.2

# Setup proxy to API used in saleor-platform
RUN apt-get update && apt-get install -y nginx
COPY apps/storefront/nginx/dev.conf /etc/nginx/conf.d/default.conf

COPY . .
RUN pnpm install


ARG SALEOR_API_URL
ENV SALEOR_API_URL ${SALEOR_API_URL:-http://localhost:8000/graphql/}
RUN pnpm build

EXPOSE 3000
CMD pnpm turbo run build --parallel --cache-dir=.turbo
