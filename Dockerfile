FROM node:14.17.1 as base

# Add package file
COPY package*.json ./

# Install deps
RUN npm i

# Copy source
COPY src ./src
COPY tsconfig.json ./tsconfig.json
COPY memcached-deployment.json ./memcached-deployment.json

# Build dist
RUN npm run build

# Start production image build
FROM gcr.io/distroless/nodejs:14

# Copy node modules and build directory
COPY --from=base ./node_modules ./node_modules
COPY --from=base /dist /dist
COPY --from=base /memcached-deployment.json /memcached-deployment.json

CMD ["dist/index.js"]
