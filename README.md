# Deploy Keycloak to Heroku

This repository deploys the [Keycloak](https://www.keycloak.org) Identity and Access Manangement Solution
to Heroku. It is based of Keycloak's official docker image with some slight modifications to use the
Heroku variable for `PORT` and `DATABASE_URL` properly.

The deployment will be made with a single Performance-M dyno (it won't run very well in smaller dynos
due to Java's memory hunger) with a free Postgres database attached.

[![Deploy to Heroku](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)

# Generate .key

1. Generate 2048-bit RSA private key:

openssl genrsa -out key.pem 2048

2. Generate a Certificate Signing Request:

openssl req -new -sha256 -key key.pem -out csr.csr

3. Generate a self-signed x509 certificate suitable for use on web servers.

openssl req -x509 -sha256 -days 365 -key key.pem -in csr.csr -out certificate.pem

4. Create SSL identity file in PKCS12 as mentioned here

openssl pkcs12 -export -out client-identity.p12 -inkey key.pem -in certificate.pem
