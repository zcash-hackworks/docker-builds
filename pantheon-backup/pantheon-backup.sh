#!/bin/bash
# pantheon-backups.sh
# Script to download Pantheon site backups
set -eo pipefail

if [[ ! -n ${PANTHEON_MACHINE_TOKEN} ]];then
  echo "PANTHEON_MACHINE_TOKEN must be set"
  exit 1
fi
if [[ ! -n ${GCP_SERVICEACCOUNT_FILE} ]];then
  echo "GCP_SERVICEACCOUNT_FILE must be set"
  exit 1
fi

/srv/website-backups-pantheon/vendor/bin/terminus auth:login --machine-token="${PANTHEON_MACHINE_TOKEN}"
gcloud auth activate-service-account --key-file "${GCP_SERVICEACCOUNT_FILE}"

# Site names to backup (e.g. 'site-one site-two')
export SITENAMES="cryptocomm electriccoinco-wordpress zcash-wordpress"
# Site environments to backup (any combination of dev, test and live)
export SITEENVS="live"
# Elements of backup to be downloaded.
export ELEMENTS="code files db"
# Add a date and unique string to the filename
BACKUPDATE=$(date +%Y%m%d%s);export BACKUPDATE
# This sets the proper file extension
export EXTENSION="tar.gz"
export DBEXTENSION="sql.gz"
# Hide Terminus update messages
export TERMINUS_HIDE_UPDATE_MESSAGES=1

# iterate through sites to backup
for thissite in $SITENAMES; do
	echo "Making backup of $thissite"

  # iterate through current site environments
  for thisenv in $SITEENVS; do
    # Local backup directory (create if it does not exist, requires trailing slash)
    BACKUPDIR="$thissite.$thisenv"
    mkdir -p "$BACKUPDIR"

    # create backup
    # We don't really do this because Pantheon already creates scheduled backups - Remove to just download those
    ${HOME}/vendor/bin/terminus backup:create "$thissite"."$thisenv"

    # iterate through backup elements
    for element in $ELEMENTS; do
      # download current site backups
      if [[ $element == "db" ]]; then
        ${HOME}/vendor/bin/terminus backup:get --element="$element" --to="$BACKUPDIR"/"$thissite".$thisenv."$element"."$BACKUPDATE".$DBEXTENSION "$thissite"."$thisenv"
        # Upload database backup to Google Cloud Bucket: website-backups-pantheon
        gsutil cp "$BACKUPDIR"/"$thissite".$thisenv."$element"."$BACKUPDATE".$DBEXTENSION gs://website-backups-pantheon/"$BACKUPDIR"/
      else
        ${HOME}/vendor/bin/terminus backup:get --element="$element" --to="$BACKUPDIR"/"$thissite".$thisenv."$element"."$BACKUPDATE".$EXTENSION "$thissite"."$thisenv"
        # Upload files and code backups to Google Cloud Bucket: website-backups-pantheon
        gsutil cp "$BACKUPDIR"/"$thissite".$thisenv."$element"."$BACKUPDATE".$EXTENSION gs://website-backups-pantheon/"$BACKUPDIR"/
      fi
    done
  done
done