FROM mirbase:latest

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN conda install -y python=3.6 multiqc=1.11

ENTRYPOINT ["/bin/bash", "-l", "-c"]
