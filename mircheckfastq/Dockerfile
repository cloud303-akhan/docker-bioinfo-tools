ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

# Install fq. Rust installation adapted from https://hub.docker.com/r/liuchong/rustup/dockerfile.
USER root
WORKDIR /root
RUN yum install -y \
    ca-certificates curl file \
    build-essential make \
    autoconf automake autotools-dev libtool xutils-dev && \
    rm -rf /var/lib/apt/lists/*
ENV SSL_VERSION=1.0.2u
RUN curl https://www.openssl.org/source/openssl-$SSL_VERSION.tar.gz -O && \
    tar -xzf openssl-$SSL_VERSION.tar.gz && \
    cd openssl-$SSL_VERSION && ./config && make depend && make install && \
    cd .. && rm -rf openssl-$SSL_VERSION*
ENV OPENSSL_LIB_DIR=/usr/local/ssl/lib \
    OPENSSL_INCLUDE_DIR=/usr/local/ssl/include \
    OPENSSL_STATIC=1
RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- --default-toolchain 1.56.1 -y
ENV PATH=/root/.cargo/bin:$PATH
RUN cargo install --git https://github.com/stjude/fqlib.git --tag v0.7.0
RUN cp -r /root/.cargo/bin/* /usr/local/bin

# Install biopet-validatefastq
USER dockworker
WORKDIR /pipeline
RUN conda install python=3.6 biopet-validatefastq=0.1.1

CMD ["/bin/bash"]
