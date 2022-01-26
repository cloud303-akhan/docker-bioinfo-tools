ARG BASE_IMAGE=273623292002.dkr.ecr.us-west-2.amazonaws.com/mirbase:1-12-2021-amzlinux
FROM ${BASE_IMAGE}

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

# Add dockworker
RUN yum -y install shadow-utils
RUN useradd dockworker --uid 1018
RUN groupadd dockerunion --gid 1019
RUN usermod -g dockerunion -G root dockworker
RUN yum install -y wget gzip which procps make

RUN chmod 777 /opt/

USER dockworker

# Install miniconda (from https://fabiorosado.dev/blog/install-conda-in-docker/)
ENV CONDA_DIR /opt/conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

CMD ["/bin/bash"]

