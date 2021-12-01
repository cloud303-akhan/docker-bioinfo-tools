ARG BASE_IMAGE=273623292002.dkr.ecr.us-west-2.amazonaws.com/mirbase:1-12-2021-amzlinux
FROM ${BASE_IMAGE}

# metadata
LABEL base.image="amazonlinux:2.0.20210721.2"
LABEL version="0.1"
LABEL software="mirvie_cfrna"
LABEL software.version="0.1"
LABEL description="cfRNA conda environment"
LABEL website="https://gitlab.com/Mirvie/pipe-cfrna"
LABEL maintainer1="Farooq Siddiqui"
LABEL maintainer1.email="farooq@mirvie.com"
LABEL maintainer2="Elaine Gee"
LABEL maintainer2.email="elaine@mirvie.com"
LABEL maintainer3="Rory Nolan"
LABEL maintainer3.email="rory@mirvie.com"

WORKDIR /pipeline

RUN yum install -y wget gzip which

# Install miniconda
#from https://fabiorosado.dev/blog/install-conda-in-docker/
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
ENV PATH=$CONDA_DIR/bin:$PATH

RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

# The code to run when container is started:
ENTRYPOINT ["/bin/bash"]
