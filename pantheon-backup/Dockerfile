FROM php:7.4.10-cli

RUN apt-get update \
  && echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" > /etc/apt/sources.list.d/google-cloud-sdk.list \
  && apt-get install -y apt-transport-https ca-certificates git gnupg \
  && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg |  apt-key --keyring /usr/share/keyrings/cloud.google.gpg add - \
  && apt-get update \
  && apt-get install -y  google-cloud-sdk
RUN useradd --home-dir /srv/website-backups-pantheon \
            --shell /bin/bash \
            --create-home \
            website-backups-pantheon
USER website-backups-pantheon
WORKDIR /srv/website-backups-pantheon
RUN curl -O https://raw.githubusercontent.com/pantheon-systems/terminus-installer/master/builds/installer.phar && php installer.phar install

ADD pantheon-backup.sh /srv/website-backups-pantheon/pantheon-backup.sh
ENTRYPOINT [ "/srv/website-backups-pantheon/pantheon-backup.sh" ]