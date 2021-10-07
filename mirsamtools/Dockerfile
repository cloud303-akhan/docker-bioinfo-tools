FROM mirbase:latest

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN conda install -y python=3.6 samtools=1.9

ENTRYPOINT ["/bin/bash", "-l", "-c"]
