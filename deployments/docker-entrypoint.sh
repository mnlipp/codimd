#!/usr/bin/env bash

set -euo pipefail

if [[ "$#" -gt 0 ]]; then
    exec "$@"
    exit $?
fi

# check database and redis is ready
pcheck -env CMD_DB_URL

# run DB migrate
NEED_MIGRATE=${CMD_AUTO_MIGRATE:=true}

if [[ "$NEED_MIGRATE" = "true" ]] && [[ -f .sequelizerc ]] ; then
    npx sequelize db:migrate
fi

# Use config.json if supplied
if [ -r "/etc/codimd/config.json" ]; then
    ln -s /etc/codimd/config.json .
fi

# start application
node app.js
