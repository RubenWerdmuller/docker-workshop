FROM node:12-alpine
ENV NODE_ENV=production

# Setting working directory. All the path will be relative to WORKDIR
WORKDIR /app

COPY package*.json ./

# Check https://blog.npmjs.org/post/171556855892/introducing-npm-ci-for-faster-more-reliable why we're using npm ci
RUN npm ci --only=production

# Copy all source files from root to destination WORKDIR
COPY . .

# Build app
RUN npm run build

# Prune all dev-dependencies from the package.json prior to copy
RUN npm prune --production

# EXPOSE does not publish the port, but instead functions as a way of documenting which ports on the container will be published at runtime.
EXPOSE 3000

# Specifies what command to run within the container
CMD ["npm", "start"]
