# docker-workshop

![](https://miro.medium.com/max/672/1*glD7bNJG3SlO0_xNmSGPcQ.png)

Why Docker?

- Development/production parity
- Different environments for running applications across different operating systems
- Decoupling infrastructure from application development
- Debugging capabilities

> But It Works On My Machine!

- Open [PWD](https://labs.play-with-docker.com/) Platform on your browser

First we'll pull a Docker Image from the Docker Registry. This can be done by using `pull`, but we can also use `docker run` as it will checkout both local files and the Docker Hub:

```zsh
docker run hello-world
```

Let's check it out:

```zsh
docker images
docker ps # hello world closes in on itself
docker ps -a
```

Inspect the image:

```zsh
docker inspect <first unique characters of the image id>
```

```zsh
docker stop <id>
```

![](https://miro.medium.com/max/3600/0*CP98BIIBgMG2K3u5.png)

## Dockerizing our own project

let's steer clear from PWD to start our own project!

### Open Docker Desktop

- Download [Docker Desktop](https://www.docker.com/products/docker-desktop)

Docker Desktop gives us the Docker CLI and the opportunity to visually display what containers are running. This might be useful from time to time, but working from the terminal gives us everything we need. Docker Desktop only gives us so much.

### Docker Hub

Before we can use the CLI, we will need to create an account with [DockerHub](https://hub.docker.com/)

### Dockering a Next.js project

Let's spin up a new Next.js project:

```zsh
npx create-next-app --use-npm
docker-workshop
cd docker-workshop
```

In our project, we're going to manage our CI/CD with **Configuration as code** (CaC). With a CaC approach, you'll configure the settings for your servers, code and other resources into a text (YAML) file. This file will be checked in version control, which will be used for creating and updating these configurations.

Let's start creating our Dockerfile. We'll write this in the GO language which is used internally by Google

```zsh
touch Dockerfile
```

```dockerfile
# Use a compact Linux distribution called Alpine with node installed in our image. Each Dockerfile must begin with a FROM instruction.
FROM node:16-alpine

# Environment variables: ENV is for future running containers. Use ARG for variables needed during the build of your Docker image.
ENV NODE_ENV=production

# Setting a working directory for the image. All the image paths will be relative to WORKDIR
WORKDIR /app

# Copy both the package.json and package.lock from our project root to destination WORKDIR
COPY package*.json ./

# Check https://blog.npmjs.org/post/171556855892/introducing-npm-ci-for-faster-more-reliable why we're using npm ci
RUN npm ci --only=production

# Copy all source files from root to destination WORKDIR
COPY . .

# Build app
RUN npm run build

# Specifies what command to run within the container
CMD ["npm", "start"]
```

> A note about why we're not simply copying over our node_modules: The core of this issue for Node.js is that node_modules can contain binaries compiled for your host OS, and if it’s different then the container OS, you’ll get errors trying to run your app when you’re bind-mounting it from the host for development.

> Another note about why we copy our package.json and package-lock.json before we copy our code into the container: Docker will cache installed node_modules as a separate layer, then, if you change your app code and execute the build command, the node_modules will not be installed again if you did not change package.json.

Let's add some files we don't want to include in our to be created image

```zsh
touch .dockerignore
```

```text
Dockerfile
.dockerignore
node_modules
```

Ok. Let's start building our Docker image! It will not be included in your project! Images are however stored on your system.

```zsh
docker build -t docker-workshop:latest .
# --tag , -t		Name and optionally a tag in the 'name:tag' format
# The . to reference the repository of a Dockerfile.
```

```zsh
docker ps
docker run -d -p 3000:3000 docker-workshop
# -detached is still running in the background, whether you like it or not;)
# -p map port 3000 to 3000. Without this, our container will be sealed!
docker logs abc
docker ps
```

```zsh
docker stop abc
docker ps -a
```

We can also name our container for a better development experience since we can start using that name rather than the randomly generated one. This will also prevent running duplicates.

```zsh
docker run -d -p 3000:3000 --name=docker-workshop docker-workshop
```

Fully remove:

```zsh
docker stop abc && docker rm $_

# bash: `_$`
# Outputs the last field from the last command executed, useful to get something to pass onwards to another command
```

.............

```zsh
docker images
docker image rm

docker tag docker-workshop rubenwerdmuller/workshop
```

That is my username choosen on purpose. Now Docker Hub will recoginise the account and will publish it for me.

```zsh
docker login
docker login -u your_dockerhub_username
```

Now push it like it's hot:

```zsh
docker push rubenwerdmuller/workshop
```

Images can take up quite some space. Let's remove all non running containers:

```zsh
docker system prune -a
```

We can pull it from the Hub too:

```zsh
docker pull rubenwerdmuller/workshop
```

Cheers!

<!-- ## Express API Generator

```
npx express-generator --no-view api
# maakt een mapje /api met een Express starter
```

```
var port = normalizePort(process.env.PORT || '3001');
# aanpassen port in bin/wwww
```

```
cd api
npm i
open http://localhost:3001/
``` -->
