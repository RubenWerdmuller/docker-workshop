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

## Local Docker

let's steer clear from PWD to start our own project!

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
# This image includes Node.js and npm. Each Dockerfile must begin with a FROM instruction.
FROM node:16-alpine

# ENV is for future running containers. ARG for building your Docker image.
ENV NODE_ENV=production

# Setting working directory. All the path will be relative to WORKDIR
WORKDIR /app

# Copy both the package.json and package.lock from root to destination WORKDIR
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

Let's add some files we don't want to include in our to be created image

```zsh
touch .dockerignore
```

```text
Dockerfile
.dockerignore
node_modules
npm-debug.log
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

### Open Docker Desktop

- Download [Docker Desktop](https://www.docker.com/products/docker-desktop)

Here you can quickly see what containers are running. While it might look useful, working from the terminal gives us everything we need, while Docker Desktop only gives us so much.

## Docker Hub

- Create an account with [DockerHub](https://hub.docker.com/)

```zsh
docker images
docker image rm

docker tag docker-workshop rubenwerdmuller/workshop
```

That is my username choosen on purpose. Now I can easily send it over to the Docker Hub.

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
