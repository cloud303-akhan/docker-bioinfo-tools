FROM mirbase:latest

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN conda install -y python=3.6 readline=6.2 rseqc=4.0.0

ENTRYPOINT ["/bin/bash", "-l", "-c"]
