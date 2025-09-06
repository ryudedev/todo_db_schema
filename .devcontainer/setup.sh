#!/usr/bin/env bash
set -eu

declare -r SOURCE_DIR=$(cd $(dirname ${0}); pwd)
declare -r APP_DIR=$(cd ${SOURCE_DIR}/..; pwd)
# Create docker-compose .env for devcontainer from the template.
cp ${SOURCE_DIR}/.env.example ${SOURCE_DIR}/.env

# Replace placeholders for environment values with host user ID and group ID.
sed -i '' \
  -e "s@##APP_DIR##@${APP_DIR}@g" \
  ${SOURCE_DIR}/.env


exit 0
