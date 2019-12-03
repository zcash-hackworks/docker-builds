FROM ubuntu:16.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y \
       build-essential \
       autoconf \
       cmake \
       pkg-config \
       curl \
       git \
       wget \
       python-dev \
       python-pip \
       libtool \
       lcov \
       valgrind \
       bsdmainutils \
       python-requests \
    && pip install \
       virtualenv \
       pyblake2 \
       pip

RUN wget -O /usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.2/dumb-init_1.2.2_amd64
RUN chmod +x /usr/bin/dumb-init

# Buildbot user
ARG BUILDBOT_USER=zcbbworker
ARG BUILDBOT_UID=2001
RUN useradd --home-dir /home/$BUILDBOT_USER \
            --shell /bin/bash \
            --create-home \
            --uid $BUILDBOT_UID\
            $BUILDBOT_USER

USER $BUILDBOT_USER
WORKDIR /home/$BUILDBOT_USER

RUN /usr/local/bin/virtualenv venv \
    && . venv/bin/activate \
    && pip install \
       buildbot-worker \
       pyflakes \
       pyblake2 \
       pyzmq \
       requests \
       twisted[tls]

# Buildbot worker
ARG BUILDBOT_WORKER_NAME=ubuntu16.04-docker
ARG BUILDBOT_WORKER_PASS=thisgetssetwhenpodisstarted
ARG BUILDBOT_MASTER_HOST=dev-ci.z.cash
ARG BUILDBOT_MASTER_PORT=9899

WORKDIR /home/$BUILDBOT_USER
RUN venv/bin/buildbot-worker create-worker $BUILDBOT_WORKER_NAME \
      $BUILDBOT_MASTER_HOST:$BUILDBOT_MASTER_PORT \
      $BUILDBOT_WORKER_NAME $BUILDBOT_WORKER_PASS \
    && echo "OS: Ubuntu 16.04" > $BUILDBOT_WORKER_NAME/info/host
ADD buildbot.tac $BUILDBOT_WORKER_NAME/buildbot.tac

WORKDIR /home/$BUILDBOT_USER/$BUILDBOT_WORKER_NAME
CMD ["/usr/bin/dumb-init", "../venv/bin/twistd", "--pidfile=", "-ny", "buildbot.tac"]
