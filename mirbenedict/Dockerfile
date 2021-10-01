FROM mirbase:latest

LABEL base.image="mirbase"
LABEL version="0.1"
LABEL software="mirvie_htseq"
LABEL software.version="0.1"
LABEL description="htseq"
LABEL website="https://gitlab.com/Mirvie/pipe-cfrna"
LABEL maintainer1="Farooq Siddiqui"
LABEL maintainer1.email="farooq@mirvie.com"
LABEL maintainer2="Elaine Gee"
LABEL maintainer2.email="elaine@mirvie.com"
LABEL maintainer3="Rory Nolan"
LABEL maintainer3.email="rory@mirvie.com"

WORKDIR /pipeline

RUN conda install -y python=3.6 python-benedict=0.24.2
RUN chgrp -R dockerunion /opt/conda

RUN ls -lh /opt/conda

# Switch to non-root user
USER dockworker

ENTRYPOINT ["/bin/bash", "-l", "-c"]
