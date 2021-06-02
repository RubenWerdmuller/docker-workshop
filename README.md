# docker-workshop

- Create an account with [DockerHub](https://hub.docker.com/)
- Open [PWD](https://labs.play-with-docker.com/) Platform on your browser
- Download Docker Desktop

docker run hello-world

docker images

docker inspect eerste letters IMAGE ID
of
docker inspect hello

// docker run -d -p 80:80 nginx

// run your image as container:
docker run -dit hello-world

The docker ps command only shows running containers by default. To see all containers, use the -a (or --all) flag:

$ docker ps -a

![](https://www.saagie.com/wp-content/uploads/2019/07/2-1024x251.png)

DAN, niet in PWD omdat het je gegevens bloot legt

dus een nieuw project:

npx create-next-app --use-npm
cd naam (ik heb docker-workshop)

docker login

> Gaan we de docker file maken

Dockerfile (In GO language die ze intern bij Google gebruiken)

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



.dockerignore

Dockerfile
.dockerignore
node_modules
npm-debug.log


docker build -t work-it:latest .
// --tag , -t		Name and optionally a tag in the 'name:tag' format

docker ps
docker run -d -p 3000:3000 docker-workshop
// detached is still running, whether you like it or not;)
docker logs 4e9
docker ps

docker stop abc

docker ps -a

docker stop abc && docker rm $_

bash: `_$`
Outputs the last field from the last command executed, useful to get something to pass onwards to another command

open Docker Desktop

voila!

<!-- docker inspect  -->

<!-- docker pushen -->

docker images
docker image rm

docker tag docker-workshop rubenwerdmuller/workshop

// Dat is mijn username, maar ook mijn toegang
// docker login
// docker login -u your_dockerhub_username
// als het mis gaat kun je even uitloggen natuurlijk
// docker logout

docker push rubenwerdmuller/workshop

docker system prune -a

docker pull rubenwerdmuller/workshop







<!-- Express API Generator -->
npx express-generator --no-view api
// maakt een mapje /api met een Express starter 

var port = normalizePort(process.env.PORT || '3001');
// aanpassen port in bin/wwww

cd api
npm i
open http://localhost:3001/
