#!/bin/bash

echo "Start"

# Set database config from Heroku DATABASE_URL
if [ "$DATABASE_URL" != "" ]; then
    echo "Found database configuration in DATABASE_URL=$DATABASE_URL"

    regex='^postgres://([a-zA-Z0-9_-]+):([a-zA-Z0-9_-]+)@([a-z0-9.-]+):([[:digit:]]+)/([a-zA-Z0-9_-]+)$'
    if [[ "$DATABASE_URL" =~ $regex ]]; then
        export KC_DB_URL="jdbc:postgresql://${BASH_REMATCH[3]}:${BASH_REMATCH[4]}/${BASH_REMATCH[5]}"
        export KC_DB_USERNAME=${BASH_REMATCH[1]}
        export KC_DB_PASSWORD=${BASH_REMATCH[2]}
        export KC_HOSTNAME=${BASH_REMATCH[3]}

        echo "KC_DB_URL=$KC_DB_URL, KC_DB_USERNAME=$KC_DB_USERNAME, KC_DB_PASSWORD=$KC_DB_PASSWORD, KC_HOSTNAME=$KC_HOSTNAME"
    fi
fi

file_env 'KEYCLOAK_USER'
file_env 'KEYCLOAK_PASSWORD'

if [ $KEYCLOAK_USER ]; then
    export KEYCLOAK_ADMIN=$KEYCLOAK_USER
fi

if [ $KEYCLOAK_PASSWORD ]; then
    export KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_PASSWORD
fi

/opt/keycloak/bin/kc.sh start