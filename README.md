# Deploy Keycloak to Sandalone server

## Creation de clée SHA1 pour le SSL

openssl req -newkey rsa:2048 -nodes \
 -keyout ./ssl/keycloak/server.key.pem -x509 -days 3650 -out ./ssl/keycloak/server.crt.pem
chmod 755 ./ssl/keycloak/server.key.pem
