# docker-workshop

![](https://miro.medium.com/max/672/1*glD7bNJG3SlO0_xNmSGPcQ.png)

Why Docker?

- Development/production parity
- Different environments for running applications across different operating systems
- Decoupling infrastructure from application development
- Debugging capabilities

> Begone witht the "But It Works On My Machine!"

## Let's play

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

Docker Desktop installs a few things under which the Docker Command Line Interface (CLI). The Desktop version has some useful features, but we'll mostly be using the CLI. 

### Docker Hub

Before we can use the CLI, we will need to create an account with [DockerHub](https://hub.docker.com/)

### Dockering a Next.js project

Let's spin up a new Next.js project:

```zsh
npx create-next-app@latest
docker-workshop
cd docker-workshop
```

In our project, we're going to manage our CI/CD with **Configuration as code** (CaC). With a CaC approach, you'll configure the settings for your servers, code and other resources into a text (YAML) file. This file will be checked in version control, which will be used for creating and updating these configurations.

Let's start by creating our Dockerfile. Docker was writtin in GO, but a Dockerfile is actually a simple textfile.

```zsh
touch Dockerfile
```

```dockerfile
# Use a compact Linux distribution called Alpine with node installed in our image. Each Dockerfile must begin with a FROM instruction.
FROM node:16-alpine

# Setting a working directory for the image. All **image** paths will be relative to WORKDIR
WORKDIR /app

# Copy both the package.json and package.lock from our project root to destination WORKDIR
COPY package*.json ./

# Check https://blog.npmjs.org/post/171556855892/introducing-npm-ci-for-faster-more-reliable why we're using npm ci
RUN npm ci --only=production

# Copy all source files from root to destination WORKDIR
COPY . .

# Build app
RUN npm run build

# Tell everybody what port we will use. Note - this does not actually expose the port and is meant as indication. We will set the port when running the docker container.
EXPOSE 3000

# Specifies what command to run within the container
CMD ["npm", "start"]
```

> A note about why we're not simply copying over our `node_modules`: The core of this issue for Node.js is that node_modules can contain binaries compiled for your host OS, and if it’s different then the container OS, you’ll get errors trying to run your app when you’re bind-mounting it from the host for development.

> Another note about why we copy our package.json and package-lock.json before we copy our code into the container: Docker will cache installed node_modules as a separate layer, then, if you change your app code and execute the build command, the node_modules will not be installed again if you did not change package.json.

Let's add some files to our project we don't want to include in our Docker image

```zsh
touch .dockerignore
```

```text
Dockerfile
.dockerignore
node_modules
```

All right, we've created the recipe for our cake. Now we're going to actually put the cake together and put it in the oven 🍰

> The Docker Image will not be included in your project as a file. Instead, these are stored on your OS.

```zsh
docker build -t docker-workshop:latest .
# --tag , -t		Name and optionally a tag in the 'name:tag' format
# The . to reference the repository of a Dockerfile.
```

Let's run our image 🏃‍♀️

```zsh
docker run -d -p 3000:3000 docker-workshop
# -detached is still running in the background, whether you like it or not;)
# -p map port 3000 to 3000. Without this, our container will be sealed!
```

Are you running? 💦

```zsh
docker logs abc
docker ps
```

Ok, good workout! 🤾‍♂️

```zsh
docker stop abc
docker ps -a
```

We can also name our tagged container for a better development experience since we can start using that name rather than the randomly generated one. This will also prevent running duplicates.

```zsh
docker run -d -p 3000:3000 --name=docker-workshop docker-workshop
```

Alright, We've had our fun. Now let's kill it 🔪🩸

```zsh
docker images
docker images ls
docker ps
docker images -a

docker stop abc && docker rm $_

# _$ outputs the last field from the last command executed, useful to get something to pass onwards to another command
```


### Registries

So, usually you want your image to be hosted somewhere. This way something like hosting can access it. Docker has its own registry, but Git providers often have their own too. For example: GitHub, GitLab and Azure all have their own container registry.

Create the image like we did before 👷

Now, let's **retag** our image so we can push it to the Docker Hub registry.

```zsh
docker tag docker-workshop rubenwerdmuller/workshop
```

The image is tagged with my username on purpose. This makes it easy for Docker Hub to recoginise the account and it will instantly publish it. I do need to be logged in though:

```zsh
docker login
docker login -u your_dockerhub_username
```

Now push it like it's hot:

```zsh
docker push rubenwerdmuller/workshop
```

Docker images can take up quite some space on systems. Let's destroy all non running containers 🪚🔨

```zsh
docker system prune -a
```

Since we uploaded our image, we can also pull it! 

```zsh
docker pull rubenwerdmuller/workshop
```


### Automating our flow in GitHub Actions

Finally, let's automate our flow!

Let's create a project which we can automate:

```zsh

```

First, we'll want to add our GitHub token (add as `GITHUB_TOKEN`) as a secret to [GitHub secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets). This will be used to login to our Docker Registry. 

Then create a file called `.github/workflows/deploy.prod.yml`

```yaml
name: Push Docker image to Docker Hub

on:
  push:
    branches:
      - '**' # Will fire on every possible branch
      # - '*/*' # Will fire on every branch that has a single slash in it
      # - '*/**' # Will fire on every branch that has a slash in it
      # - 'main' # Will fire on the branch named `main`
      # - '!main' # Will not fire if the branch name is `main`
      
jobs:
  test:
    runs-on: ubuntu-latest #GitHub virtual machine uses the latest version of Ubuntu
    steps:
      - name: Login to GitHub Container Registry
        uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
          
      - name: Build and push
        id: docker_build
        uses: docker/build-push-action@v2
        with:
          push: true
          # Update the latest image and create a back-up
          tags: |
            ghcr.io/${{ github.repository }}:${{ github.ref }}
            ghcr.io/${{ github.repository }}:latest
```

> more information about logging in with Docker [here](https://github.com/marketplace/actions/docker-login).

### Environment variables

Say we'd want to add some possible variants to our recipe (Docker image). They're not secret ingredients, so we can input these freely.

**Using the Docker build**

During the build we can add environment variables. This requires one simple addition to our regular flow. Add the variable as a docker CLI flag:

```sh
docker build --build-arg APP_ENVIRONMENT=preview --no-cache -t our_app_name .
```

**When using `ci/cd` and `next.js`**

You can also add public information through your `ci/cd` flow which has the benefit that the flow act as a single source of truth.

In the next example, after the `script:` line, a `shell` script is used to pass an environment variable to a newly created `.env.production` fle.

```sh
Build and push develop:
  extends: .build
  variables:
    ORY_SDK_URL: https://acc.id.commondatafactory.nl
  script:
    - echo "ORY_SDK_URL=$ORY_SDK_URL" > .env.production
    - docker pull --quiet $CI_REGISTRY_IMAGE:develop || true
    - docker build --build-arg RUNNING_ENV=staging -t $IMAGE_TAG -t $CI_REGISTRY_IMAGE:develop .
    - docker push --quiet $CI_REGISTRY_IMAGE:develop
  only:
    - branches
  except:
    - main
```


### Cheers!

![](https://upload.wikimedia.org/wikipedia/commons/thumb/f/f1/Heart_coraz%C3%B3n.svg/1200px-Heart_coraz%C3%B3n.svg.png)

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
