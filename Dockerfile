FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools

# dt styling
COPY keycloak/themes/dev-together/login/theme.properties /opt/jboss/keycloak/themes/dev-together/login/theme.properties

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]

