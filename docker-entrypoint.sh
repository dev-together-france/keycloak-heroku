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

# usage: file_env VAR [DEFAULT]
#    ie: file_env 'XYZ_DB_PASSWORD' 'example'
# (will allow for "$XYZ_DB_PASSWORD_FILE" to fill in the value of
#  "$XYZ_DB_PASSWORD" from a file, especially for Docker's secrets feature)
file_env() {
	local var="$1"
	local fileVar="${var}_FILE"
	local def="${2:-}"
	if [ "${!var:-}" ] && [ "${!fileVar:-}" ]; then
		echo >&2 "error: both $var and $fileVar are set (but are exclusive)"
		exit 1
	fi
	local val="$def"
	if [ "${!var:-}" ]; then
		val="${!var}"
	elif [ "${!fileVar:-}" ]; then
		val="$(< "${!fileVar}")"
	fi
	export "$var"="$val"
	unset "$fileVar"
}

file_env 'KEYCLOAK_USER'
file_env 'KEYCLOAK_PASSWORD'

if [ $KEYCLOAK_USER ]; then
    export KEYCLOAK_ADMIN=$KEYCLOAK_USER
fi

if [ $KEYCLOAK_PASSWORD ]; then
    export KEYCLOAK_ADMIN_PASSWORD=$KEYCLOAK_PASSWORD
fi

export KC_HTTP_ENABLED=false
export KC_HTTPS_PORT=$PORT

/opt/keycloak/bin/kc.sh start --optimized

# Installed features: [agroal, cdi, hibernate-orm, jdbc-postgresql, keycloak, logging-gelf, narayana-jta, reactive-routes, resteasy-reactive, resteasy-reactive-jackson, smallrye-context-propagation, vertx]