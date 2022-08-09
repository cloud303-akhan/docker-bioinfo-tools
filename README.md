# Docker containers of Mirvie bioinformatics tools

## Purpose
The `Nextflow` pipeline relies on the Docker containers in this repo to run its  
processes. This repo houses the Dockerfiles that creates the Docker containers containing the 
bioinformatics tools required by the Nextflow scripts, e.g. the preeclampsia Nextflow
script can be run with Docker containers, see 
[Mirvie's nf-cfrna Repo](https://gitlab.com/Mirvie/nf-cfrna)). 

## Requirements
Docker must be installed. Run `docker --version` to see if Docker is already installed. 
If not, follow the instructions at https://docs.docker.com/get-docker/ to install it 
for your OS.

## Dockerfiles

### A. Images for `nf-cfrna`
There are 11 Docker containers required by the `nf-cfrna` Nextflow pipeline.

| Image | Dependent Nextflow Process(es) | 
| --- | --- |
| mirbase | GET_FLOWCELLIDS, other images are built from this base image|
| mircheckfastq  |CHECK_FASTQ|
| mirfastqc |FASTQC|
| mirtrimmomatic |TRIM|
| mirstar |ALIGN |
| mirpicard |DEDUP, RNAMETRICS|
| mirsamtools | INDEX | 
| mirrseqc | RSEQC|
| mirhtseq | COUNT |
| mirpandas | PREDICT, MAKE_RESULTS_JSON, MAKE_STATS_LG, FINALIZE_RESULTS_JSON |
| mirmultiqc | MULTIQC |

### B. Images for `BCLConvert` Nextflow Pipeline
One Docker container is required by the `BCLConvert` Nextflow pipeline.

| Image | Dependent Nextflow Process(es) | 
| --- | --- |
| mirbclconvert | TBD |

## Building the Images

The Dockerfiles need to be constructed into images before containers can be run. There
are two options for building the images in this repo.

### Option 1: Automatic Build
The build script will build all the containers needed for the `nf-crna` pipeline and `mirbclconvert`, starting first with 
`mirbase` from which all other images are built. The build script will first remove
images that match the name and tag prior to build images tagged by the commit of this
repo.

NOTES: 
* `mirrseqc` requires a significant amount of memory to build, so set the 
memory requirements for the docker engine to 4.0 GB of memory. 
* `mirstar` will need 32 GB (> 16 GB) to run in the pipeline. 
 
1. Clone this repo. 
```
git clone https://gitlab.com/Mirvie/docker-bioinfo-tools.git
```

2. Run the build script, which will delete the latest image if it exists prior to 
building the new image.
```
sh build.sh
```

3. Check that the images are created with the correct tags pulled from the commit.
```
$ docker image ls
REPOSITORY       TAG              IMAGE ID       CREATED        SIZE
mirmultiqc       f232966          18b9b1d3bb72   2 days ago     2.34GB
mirtrimmomatic   f232966          8674feb4ef6c   2 days ago     2.1GB
mirstar          f232966          09899c2c209b   2 days ago     2.03GB
mirsamtools      f232966          ff4ca83b10d3   2 days ago     2.01GB
mirrseqc         f232966          1d5daee4c9a8   2 days ago     2.48GB
mirpicard        f232966          950734544895   2 days ago     2.79GB
mirhtseq         f232966          77aad0acbd29   2 days ago     3.18GB
mirfastqc        f232966          02bb7fc839a8   2 days ago     2.3GB
mirpandas        f232966          f8b2d0263755   2 days ago     2.24GB
mircheckfastq    f232966          bc64d4ee8e90   2 days ago     3.13GB
mirbase          f232966          645458a5771d   2 days ago     1.13GB
```
### Option 2: Manual Build
1. The first image to build is the base image `mirbase` from which the other images 
build from. Replace <tag> with the desired `tag` name, e.g. the commit tag or `latest`:
```
% cd docker-bioinfo-tools/mirbase
% docker build -t mirbase:<tag> - < Dockerfile
```

2. Confirm that the `mirbase` image was created:
```
 % docker image ls
REPOSITORY          TAG       IMAGE ID       CREATED          SIZE
mirbase             latest    781f7ea3283c   17 seconds ago   791MB
```
If using `Docker Desktop` on a Mac, the images can also be see from the 
`Images on disk` page accessed by navigating via `Images` from the sidebar.

3. Build the remaining images by navigating to the appropriate `image_name`
folder in this repo and building the Dockerfile:
```
% cd docker-bioinfo-tools/<image_name>
% docker build -t <image_name>:latest - < Dockerfile
```
If there are local files that need to be copied into the container, these files will need to 
be in the same dir as the Dockerfile and you will need to pass the 
full path of the enclosing dir to `docker build`:
```
% docker build -t <image_name>:latest /PATH/TO/DOCKERFILE/PARENT/DIR
```

## Running a Container
1. To run a container in interactive mode, stepping into a bash shell, execute the following command:
```
docker run -it <image_name> bash
```
Alternatively in `Docker Desktop`, click the `Run` button next to each image 
via the `Images on disk` page.

2. Confirm the image (example here is with the `mirsamtools` image) is running:
```
% docker ps
CONTAINER ID   IMAGE                COMMAND       CREATED              STATUS              PORTS     NAMES
372065f80e4a   mirsamtools:latest   "/bin/bash"   About a minute ago   Up About a minute             exciting_greider
```
