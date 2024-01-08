FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools

# dt styling
COPY keycloak/themes/dt/themes.properties /opt/jboss/keycloak/themes/dt/themes.properties

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

