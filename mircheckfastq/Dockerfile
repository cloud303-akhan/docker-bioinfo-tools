ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN conda install python=3.6 fq=0.9.1 biopet-validatefastq=0.1.1

ENTRYPOINT ["/bin/bash", "-l", "-c"]
