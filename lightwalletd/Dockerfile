FROM golang:1.13 AS lightwalletd_base
ARG LWD_TAG=v0.3.0

RUN git clone --depth 1 \
  https://github.com/zcash/lightwalletd.git \
  /go/src/github.com/zcash/lightwalletd
WORKDIR /go/src/github.com/zcash/lightwalletd
RUN git checkout ${LWD_TAG}
RUN make

FROM debian:10

COPY --from=lightwalletd_base \
  /go/src/github.com/zcash/lightwalletd/server \
  /usr/bin/server

ARG LWD_USER=lightwalletd
ARG LWD_UID=2002

RUN useradd --home-dir /srv/$LWD_USER \
            --shell /bin/bash \
            --create-home \
            --uid $LWD_UID\
            $LWD_USER
USER $LWD_USER
WORKDIR /srv/$LWD_USER

ENTRYPOINT ["server"]
CMD ["--help"]