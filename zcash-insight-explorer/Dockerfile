FROM debian:9
# Run 'docker build -t zcash-insight-explorer:latest .' from github clone
# docker run -p80:3001 -v $(pwd)/dot-zcash:/home/zcashd/.zcash zcash-insight-explorer

RUN apt-get update \
    && apt-get install -y gnupg2 wget libzmq3-dev git \
    && apt-get -qqy install \
        build-essential pkg-config libc6-dev m4 g++-multilib \
        autoconf libtool ncurses-dev unzip git python python-zmq \
        zlib1g-dev wget curl bsdmainutils automake gettext-base \
    \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

ARG ZCASH_SIGNING_KEY_ID=6DEF3BAF272766C0
ARG ZCASH_VERSION=2.0.7+2
ARG ZCASHD_USER=zcashd
ARG ZCASHD_UID=2001

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys $ZCASH_SIGNING_KEY_ID \
  && echo "deb [arch=amd64] https://apt.z.cash/ jessie main" > /etc/apt/sources.list.d/zcash.list \
  && apt-get update \
  && apt-get install -y zcash=$ZCASH_VERSION

RUN useradd --home-dir /home/$ZCASHD_USER \
            --shell /bin/bash \
            --create-home \
            --uid $ZCASHD_UID\
            $ZCASHD_USER

USER $ZCASHD_USER
WORKDIR /home/$ZCASHD_USER/
RUN mkdir .npm-global .zcash .zcash-params

ENV PATH=/home/$ZCASHD_USER/.npm-global/bin:$PATH
ENV NPM_CONFIG_PREFIX=/home/$ZCASHD_USER/.npm-global

RUN npm install -g npm@latest
RUN npm -g install zcash-hackworks/bitcore-node-zcash

RUN bitcore-node create zc
ADD bitcore-node.json.template bitcore-node.json.template
ADD entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
