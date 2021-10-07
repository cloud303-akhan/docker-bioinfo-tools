FROM mirbase:latest

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN conda install -y python=3.6 star=2.6.1b

ENTRYPOINT ["/bin/bash", "-l", "-c"]
