# docker-workshop

## Prerequisites
- Create an account with [DockerHub](https://hub.docker.com/)
- Open [PWD](https://labs.play-with-docker.com/) Platform on your browser
- Download Docker Desktop

Run ( en pull als hij niks kan vinden):

```
docker run hello-world
```

kiek maar:
```
docker images
docker ps # hello world stopt zichzelf weer.. :)
docker ps -a
```

inspect de image:
```
docker inspect <eerste letters IMAGE ID> # of id
```

```
docker stop <eerste letters IMAGE ID> # of id
```

<!-- // run your image as container: -->
<!-- docker run -dit hello-world -->

![](https://miro.medium.com/max/3600/0*CP98BIIBgMG2K3u5.png)

## local Docker

Niet verder in PWD omdat het je gegevens bloot legt

dus een nieuw project!

```
npx create-next-app --use-npm
docker-workshop
cd docker-workshop
```

We gaan een docker file maken

Dockerfile (In GO language die ze intern bij Google gebruiken)

touch Dockerfile

```
# This image includes Node.js and npm. Each Dockerfile must begin with a FROM instruction.
FROM node:16-alpine

# ENV is for future running containers. ARG for building your Docker image.
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

# Specifies what command to run within the container
CMD ["npm", "start"]
```


touch .dockerignore

```
Dockerfile
.dockerignore
node_modules
npm-debug.log
```

dan bouwen we die om naar een image
```
docker build -t work-it:latest .
# --tag , -t		Name and optionally a tag in the 'name:tag' format
```

```
docker ps
docker run -d -p 3000:3000 docker-workshop
# detached is still running, whether you like it or not;)
docker logs 4e9
docker ps
```

```
docker stop abc
docker ps -a
```

full remove:

```
full remove:
docker stop abc && docker rm $_

# bash: `_$`
# Outputs the last field from the last command executed, useful to get something to pass onwards to another command
```

## open Docker Desktop

voila!


## Docker Push

```
docker images
docker image rm

docker tag docker-workshop rubenwerdmuller/workshop
```

Dat is mijn username, maar ook mijn toegang

```
docker login
docker login -u your_dockerhub_username
```

Als het mis gaat kun je even uitloggen natuurlijk

```
docker logout
```

en push!

```
docker push rubenwerdmuller/workshop
```

Alles leeg halen, want onze apps zijn groot!

```
docker system prune -a
```

nog een keer dan:

```
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
