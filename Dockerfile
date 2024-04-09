FROM quay.io/keycloak/keycloak:latest as builder

COPY docker-entrypoint.sh /opt/jboss/tools

# dt styling
COPY keycloak/themes/dev/login/theme.properties /opt/jboss/keycloak/themes/dev/login/theme.properties
COPY keycloak/themes/dev/login/resources/css/keycloak.css /opt/jboss/keycloak/themes/dev/login/resources/css/keycloak.css
COPY keycloak/themes/dev/login/resources/js/keycloak.js /opt/jboss/keycloak/themes/dev/login/resources/js/keycloak.js
COPY keycloak/themes/dev/login/login-password.ftl /opt/jboss/keycloak/themes/dev/login/login-password.ftl
COPY keycloak/themes/dev/login/messages/messages_en.properties /opt/jboss/keycloak/themes/dev/login/messages/messages_en.properties

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

