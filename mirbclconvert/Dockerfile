ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

WORKDIR /pipeline

USER root

RUN yum install -y gdb libudev systemd-libs

COPY bcl-convert-3.8.2_12_g85770e0b-2.el7.x86_64.rpm /pipeline

RUN rpm -i bcl-convert-3.8.2_12_g85770e0b-2.el7.x86_64.rpm && \
    rm bcl-convert-3.8.2_12_g85770e0b-2.el7.x86_64.rpm

ENTRYPOINT ["/bin/bash", "-l", "-c"]
