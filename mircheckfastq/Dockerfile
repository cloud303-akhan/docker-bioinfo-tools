ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"


WORKDIR /pipeline

USER root

RUN yum install -y amazon-linux-extras
RUN PYTHON=python2 amazon-linux-extras install rust1
RUN cargo install --git https://github.com/stjude/fqlib.git --tag v0.7.0
RUN cp -r /root/.cargo/bin/* /usr/local/bin

USER dockworker

RUN conda install python=3.6 biopet-validatefastq=0.1.1

ENTRYPOINT ["/bin/bash", "-l", "-c"]
