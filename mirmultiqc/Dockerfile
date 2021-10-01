FROM mirbase:latest

LABEL base.image="mirbase"
LABEL version="0.1"
LABEL software="mirvie_STAR"
LABEL software.version="0.1"
LABEL description="STAR"
LABEL website="https://gitlab.com/Mirvie/pipe-cfrna"
LABEL maintainer1="Farooq Siddiqui"
LABEL maintainer1.email="farooq@mirvie.com"
LABEL maintainer2="Elaine Gee"
LABEL maintainer2.email="elaine@mirvie.com"
LABEL maintainer3="Rory Nolan"
LABEL maintainer3.email="rory@mirvie.com"

WORKDIR /pipeline

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN conda install -y python=3.6 multiqc=1.11

# Switch to non-root user
USER dockworker

ENTRYPOINT ["/bin/bash", "-l", "-c"]
