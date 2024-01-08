FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools

# dt styling
COPY keycloak/themes/dt/theme.properties /opt/jboss/keycloak/themes/dt/theme.properties

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

