#!/bin/bash

[[ "TRACE" ]] && set -x

if [ -z "$ULU_CLOUDBREAK_ADDRESS" ] && [ -z "$ULU_CLOUDBREAK_SERVICEID" ]; then
  echo ULU_CLOUDBREAK_ADDRESS or ULU_CLOUDBREAK_SERVICEID must be set;
  MISSING_ENV_VARS=true;
fi

if [ -z "$ULU_IDENTITY_ADDRESS" ] && [ -z "$ULU_IDENTITY_SERVICEID" ]; then
  echo ULU_IDENTITY_ADDRESS or ULU_IDENTITY_SERVICEID must be set;
  MISSING_ENV_VARS=true;
fi

if [ -z "$ULU_SULTANS_ADDRESS" ] && [ -z "$ULU_SULTANS_SERVICEID" ]; then
  echo ULU_SULTANS_ADDRESS or ULU_SULTANS_SERVICEID must be set;
  MISSING_ENV_VARS=true;
fi

if [ -z "$ULU_OAUTH_CLIENT_ID" ]; then
  echo ULU_OAUTH_CLIENT_ID must be set;
  ULU_OAUTH_CLIENT_ID=true;
fi

if [ -z "$ULU_OAUTH_CLIENT_SECRET" ]; then
  echo ULU_OAUTH_CLIENT_SECRET must be set;
  MISSING_ENV_VARS=true;
fi

if [ -z "$ULU_HOST_ADDRESS" ]; then
  echo ULU_HOST_ADDRESS must be set;
  MISSING_ENV_VARS=true;
fi

if [ -z "$ULU_PRODUCTION" ]; then
  export ULU_PRODUCTION=false;
fi

if [ $MISSING_ENV_VARS ]; then
  exit 1;
fi

if [ -z "$ULU_SULTANS_BACKEND_ADDRESS" ]; then
  if [ -n "$ULU_SULTANS_ADDRESS" ]; then
    ULU_SULTANS_BACKEND_ADDRESS=$ULU_SULTANS_ADDRESS;
  else
    ULU_SULTANS_BACKEND_ADDRESS=$ULU_SULTANS_SERVICEID;
  fi
fi

cd /uluwatu
if [ "$ULU_PRODUCTION" = true ]; then
  npm install newrelic
  cp node_modules/newrelic/newrelic.js .
  sed -i -E "s/license key here/$ULU_NEW_RELIC_KEY/g" newrelic.js
  sed -i -E "s/My Application/$ULU_NEW_RELIC_APP/g" newrelic.js
  echo "require('newrelic');" > new_server.js
  cat server.js >> new_server.js
  rm server.js
  mv new_server.js server.js
fi;
node server.js
