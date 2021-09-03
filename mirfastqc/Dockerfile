FROM mirbase:latest

# metadata
LABEL base.image="mirbase"
LABEL version="0.1"
LABEL software="mirvie_fastqc"
LABEL software.version="0.1"
LABEL description="fastqc"
LABEL website="https://gitlab.com/Mirvie/pipe-cfrna"
LABEL maintainer1="Farooq Siddiqui"
LABEL maintainer1.email="farooq@mirvie.com"
LABEL maintainer2="Elaine Gee"
LABEL maintainer2.email="elaine@mirvie.com"
LABEL maintainer3="Rory Nolan"
LABEL maintainer3.email="rory@mirvie.com"

WORKDIR /pipeline

RUN conda install -y fastqc

## Make RUN commands use the new environment:
#SHELL ["conda", "run", "-n", "cfRNA", "/bin/bash", "-c"]
#
# The code to run when container is started:
ENTRYPOINT ["/bin/bash"]
