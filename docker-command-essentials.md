<!-- https://keraton.gitbooks.io/docker-cheat-sheet/content/dockerfile_essentials.html?q= -->

# Docker Command Essentials
The idea of docker essentials is to summarize all the most use full docker commands.

## Docker
Docker status related command

## docker info
To check that the docker is working correctly. You need at least to have server detected.

```
$ docker info
```

## Container
Container related command

### docker run


To create and run a container. You need to give at least a docker image as a parameter.

```
$ docker run hello-world
```

**Interactive shell options**

- -i, --interactive : Keep STDIN open
- -t, --tty : Allocate pseudo-tty (terminal)

```
$ docker run -i -t ubuntu /bin/bash
...
root@9b5e9657f47b:/#
```

Run ubuntu container, and launch the bin/bash command.

The container will run, as long as the application keep run.

**Container naming**

--name : define name.
$ docker run --name container_name -i -t ubuntu /bin/bash
By default docker will give a container a name.

**Detached mode**

-d, --detach : Run container in background and print container ID

**Port Publish**

-p, --publish : Publish a container's port(s) to the host
Two ways of publish a port

- Let docker to define the host port
```$ docker run -d -p 80 image_name```
- Define a specific port in the host. Here map the port 80 of the container to the port 80 of the host.
```
$ docker run -d -p 80:80 image_name
```

### docker ps

List containers.

```
$ docker ps

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS               NAMES
8841e75b49a3        ubuntu              "/bin/bash"         2 minutes ago       Up 7 seconds                            container_name
```

**List all container**

- -a, --all : Show all containers (default shows just running)

```
$ docker ps -a
```

### docker start

Start docker by using its name or id.

Using name

```
$ docker start container_name
```

Using id

```
$ docker start 8841e75b49a3
```

### docker stop

Stop docker by using its name or id.

Using name

$ docker stop container_name
Using id

$ docker stop 8841e75b49a3

### docker attach

Attach to the container session.

Using name

$ docker attach container_name
Using id

$ docker attach 8841e75b49a3
In this case is the /bin/bash command launched.

### docker logs
Fetch the log of a container

$ docker logs container_name
Use Ctrl-C to exit.

### docker top
Inspect the processes inside the container

$ docker top container_name
docker stats
Show statistics for one or more running containers.

$ docker top container_a container_b

### docker exec
Execute a command inside a container.

$ docker exec -t -i container_name /bin/bash
See the docker run for the -t -i options

### docker inspect
To gather more information.

$ docker inspect container_name

### docker rm

To delete a container

$ docker rm container_name

## Images

Images related command.

docker images
Lists all images in a docker hosts.

$ docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
hello-world         latest              693bce725149        11 days ago         967 B
ubuntu              latest              2fa927b5cdd3        3 weeks ago         122 MB
docker pull
Pull an image from docker registry.

$ docker pull ubuntu
We can specify a tag for a docker image

$ docker pull ubuntu:12.04
Where 12.04 is a tag.

docker search
Search an image from docker hub

$ docker search ubuntu
docker commit
Commit an state of a container to an image, this method is not recommended, instead use Dockerfile

$ docker commit 8841e75b49a3 container_new_name
commit information

-m : commit message
-a : commit author
We can also add tag to a commit

$ docker commit -m "message" -a "bowie brotosumpeno" 8841e75b49a3 container_new_name:new
docker build
Build a docker image from a Dockerfile

Define repository/name

-t : define a repository/name of an image
$ docker build -t="keraton/container_name:tag_v1 .
The . to reference the repository of a Dockerfile.

docker history
Show history of an image.

$ docker history 2fa927b5cdd3
docker port
To get an information about container to host mapping.

$ docker port 2fa927b5cdd3 80
0.0.0.0:49154
In this example the port 80 of contianer 2fa927b5cdd3 is mapped to port 49154 of host
