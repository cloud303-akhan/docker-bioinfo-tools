ARG GIT_COMMIT
FROM mirbase:$GIT_COMMIT

LABEL git_commit=$GIT_COMMIT
LABEL repo="https://gitlab.com/Mirvie/docker-bioinfo-tools"

USER root

RUN yum update -y \
 && yum install -y \
    curl \
    hostname \
    java \
    unzip \
    graphviz \
    jq \
 && yum clean -y all
RUN rm -rf /var/cache/yum

# Install nextflow
RUN curl -L "https://github.com/nextflow-io/nextflow/releases/download/v21.12.1-edge/nextflow" -o /usr/bin/nextflow && \
 chmod +x /usr/bin/nextflow

# install awscli v2
RUN curl -s "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip" \
 && unzip -q /tmp/awscliv2.zip -d /tmp \
 && /tmp/aws/install -b /usr/bin \
 && rm -rf /tmp/aws*

USER dockworker

# install a custom entrypoint script that handles being run within an AWS Batch Job
COPY --chown=dockworker:dockerunion ./nextflow.aws.sh /opt/bin/nextflow.aws.sh
RUN chmod +x /opt/bin/nextflow.aws.sh

ENV JAVA_HOME /usr/lib/jvm/jre-openjdk/
ENV TMPDIR=/tmp
# invoke nextflow once to download dependencies
RUN nextflow -version

WORKDIR /opt/work
ENTRYPOINT ["/opt/bin/nextflow.aws.sh"]
