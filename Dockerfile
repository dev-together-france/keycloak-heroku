FROM quay.io/keycloak/keycloak:latest as builder

# Enable health and metrics support
ENV KC_HEALTH_ENABLED=true
ENV KC_METRICS_ENABLED=true

# Configure a database vendor
ENV KC_DB=postgres

WORKDIR /opt/keycloak
#RUN keytool -genkeypair -storepass password -storetype PKCS12 -keyalg RSA -keysize 2048 -dname "CN=server" -alias server -ext "SAN:c=DNS:localhost,IP:127.0.0.1" -keystore conf/server.keystore
RUN /opt/keycloak/bin/kc.sh build

FROM quay.io/keycloak/keycloak:latest
COPY --from=builder /opt/keycloak/ /opt/keycloak/

COPY docker-entrypoint.sh /opt/keycloak
# dt styling
COPY keycloak/themes/dev/login/theme.properties /opt/keycloak/themes/dev/login/theme.properties
COPY keycloak/themes/dev/login/resources/css/keycloak.css /opt/keycloak/themes/dev/login/resources/css/keycloak.css
COPY keycloak/themes/dev/login/resources/js/keycloak.js /opt/keycloak/themes/dev/login/resources/js/keycloak.js
COPY keycloak/themes/dev/login/login-password.ftl /opt/keycloak/themes/dev/login/login-password.ftl
COPY keycloak/themes/dev/login/messages/messages_en.properties /opt/keycloak/themes/dev/login/messages/messages_en.properties


# change these values to point to a running postgres instance
ENV KC_DB=postgres
ENTRYPOINT ["/opt/keycloak/docker-entrypoint.sh"]

