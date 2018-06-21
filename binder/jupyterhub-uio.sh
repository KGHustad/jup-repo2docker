#!/bin/bash

echo "Sync on start"
echo "============="
rsync -az --ignore-existing --exclude '.git' /src/* /work/

echo "Check for maintenance"
echo "====================="
cp /src/.maintenance.txt ${HOME}/.jupyter/custom/maintenance.txt

echo "Run notebook"
echo "============"
jupyterhub-singleuser \
  --port=8888 \
  --ip=0.0.0.0 \
  --user="$JPY_USER" \
  --cookie-name=$JPY_COOKIE_NAME \
  --base-url=$JPY_BASE_URL \
  --hub-prefix=$JPY_HUB_PREFIX \
  --hub-api-url=$JPY_HUB_API_URL \
  --notebook-dir='/work'

