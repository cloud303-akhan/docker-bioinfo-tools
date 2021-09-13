# Docker containers of Mirvie bioinformatics tools

Dockerfiles for creating docker containers of bioinformatics tools used at Mirvie

## Building the Images for the Nextflow Pipeline

### Option 1: Automation via the Build Script
The `Nextflow` pipeline relies on the Docker containers in this repo to run its processes. 
These containers need to be built and running before the `Nextflow` scripts can run.
The build script will build all the containers in the repo, starting first with `mirbase`.
NOTE: `mirrseqc` requires a significant amount of memory to build, so set the 
memory requirements for the docker engine to 4.0 GB of memory. The `mirstar` container 
will need 32 GB (> 16 GB) to run in the pipeline. 
 
1. Clone this repo. 
```
git clone https://gitlab.com/Mirvie/docker-bioinfo-tools.git
```

2. Run the build script, which will delete the latest image if it exists prior to 
building the new image.
```
sh build.sh
```
### Option 2: Manual Build
1. The first image to build is the base image `mirbase` from which the other images build from:
```
% cd docker-bioinfo-tools/mirbase
% docker build -t mirbase:latest - < Dockerfile
```
2. Confirm that the `mirbase` image was created
```
 % docker image ls
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
mirbase             latest    781f7ea3283c   17 seconds ago   791MB
```
If using `Docker Desktop` on a Mac, the images can also be see from the 
`Images on disk` page accessed by navigating via `Images` from the sidebar.

3. Then build the remaining images by navigating to the appropriate `image_name`
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