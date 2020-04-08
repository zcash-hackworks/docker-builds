FROM debian

RUN apt-get update \
    && apt-get install -y \
    curl git dnsutils hexyl netcat tcpdump zip

ARG bandwhich_version=0.12.0
RUN curl -L https://github.com/imsnif/bandwhich/releases/download/${bandwhich_version}/bandwhich-v${bandwhich_version}-x86_64-unknown-linux-musl.tar.gz | tar zxvf - -C /usr/local/bin

ARG procs_version=v0.9.20
RUN curl -L https://github.com/dalance/procs/releases/download/v0.9.20/procs-v0.9.20-x86_64-lnx.zip -o /tmp/procs.zip \
    && unzip /tmp/procs.zip -d /usr/local/bin/