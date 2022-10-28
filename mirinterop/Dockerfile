ARG GIT_COMMIT
FROM mirpandas:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

RUN pip install interop 

ENTRYPOINT ["/bin/bash", "-l", "-c"]

