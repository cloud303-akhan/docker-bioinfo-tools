FROM amazonlinux:2.0.20210721.2

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN yum -y install shadow-utils
RUN useradd dockworker --uid 1018
RUN groupadd dockerunion --gid 1019
RUN usermod -g dockerunion dockworker
RUN yum install -y wget gzip which procps make git

RUN chmod 777 /opt/

# Add dockworker
USER dockworker

# Install miniconda (from https://fabiorosado.dev/blog/install-conda-in-docker/)
ENV CONDA_DIR /opt/conda
RUN wget --quiet \
    https://repo.anaconda.com/miniconda/Miniconda3-py39_4.10.3-Linux-x86_64.sh \
    -O ~/miniconda.sh && \
     /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path
ENV PATH=$CONDA_DIR/bin:$PATH
RUN conda config --add channels bioconda
RUN conda config --add channels conda-forge

ENTRYPOINT ["/bin/bash", "-l", "-c"]

