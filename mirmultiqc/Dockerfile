ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN conda install -y python=3.7 multiqc=1.14
