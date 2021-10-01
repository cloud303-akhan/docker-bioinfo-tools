FROM mirbase:latest

# metadata
LABEL base.image="mirbase"
LABEL version="0.1"
LABEL software="mirvie_trimmomatic"
LABEL software.version="0.1"
LABEL description="trimmomatic"
LABEL website="https://gitlab.com/Mirvie/pipe-cfrna"
LABEL maintainer1="Farooq Siddiqui"
LABEL maintainer1.email="farooq@mirvie.com"
LABEL maintainer2="Elaine Gee"
LABEL maintainer2.email="elaine@mirvie.com"
LABEL maintainer3="Rory Nolan"
LABEL maintainer3.email="rory@mirvie.com"

WORKDIR /pipeline

RUN yum install -y gdb libudev systemd-libs

COPY bcl-convert-3.8.2_12_g85770e0b-2.el7.x86_64.rpm .
RUN rpm -i bcl-convert-3.8.2_12_g85770e0b-2.el7.x86_64.rpm

# Switch to non-root user
USER dockworker

# The code to run when container is started:
ENTRYPOINT ["/bin/bash"]
