# Docker containers of Mirvie bioinformatics tools

Dockerfiles for creating docker containers of bioinformatics tools used at Mirvie

## Building the Images for the Nextflow Pipeline
The `Nextflow` pipeline relies on the Docker containers in this repo to run its processes. 
These containers need to be built and running before the `Nextflow` scripts can run.

1. Clone this repo.
```
git clone https://gitlab.com/Mirvie/docker-bioinfo-tools.git
```
2. The first image to build is the base image `mirbase` from which the other images build from:
```
% cd docker-bioinfo-tools/mirbase
% docker build -t mirbase:latest - < Dockerfile
```
3. Confirm that the `mirbase` image was created
```
 % docker image ls
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
mirbase             latest    781f7ea3283c   17 seconds ago   791MB
```
If using `Docker Desktop` on a Mac, the images can also be see from the 
`Images on disk` page accessed by navigating via `Images` from the sidebar.

4. Then build the remaining images by navigating to the appropriate `image_name`
folder in this repo and building the Dockerfile:
```
% cd docker-bioinfo-tools/<image_name>
% docker build -t <image_name>:latest - < Dockerfile
```

## Run an Image
1. To run an image,
```
docker run <image_name>
```
Alternatively in `Docker Desktop`, click the `Run` button next to each image 
via the `Images on disk` page.

2. Confirm the image (example here is with the `mirsamtools` image) is running:
```
% docker ps
CONTAINER ID   IMAGE                COMMAND       CREATED              STATUS              PORTS     NAMES
372065f80e4a   mirsamtools:latest   "/bin/bash"   About a minute ago   Up About a minute             exciting_greider
```