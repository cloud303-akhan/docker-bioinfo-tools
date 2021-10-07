FROM mirbase:latest

LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN conda install -y python=3.7 pandas=1.3.2 

ENTRYPOINT ["/bin/bash", "-l", "-c"]
