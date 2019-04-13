#!/bin/bash

certDir=$1

if [ -z "$certDir" ]; then
    certDir=$HOME/certs
fi

mkdir $certDir 
cd $certDir

echo "Creating certs at: `pwd`"

# Create CA certificate
openssl genrsa 2048 > ca-key.pem
openssl req -new -x509 -nodes -days 3600 -key ca-key.pem -out ca.pem -subj '/C=HK/ST=Hong Kong/L=Hong Kong/O=gmoynihan/CN=genemoynihan.com'

# Create server certificate, remove passphrase, and sign it
# server-crt.pem = public key, server-key.pem = private key
openssl req -newkey rsa:2048 -days 3600 -nodes -keyout server-key.pem -out server-req.pem -subj '/C=HK/ST=Hong Kong/L=Hong Kong/O=gmoynihan/CN=genemoynihan.com'
openssl rsa -in server-key.pem -out server-key.pem
openssl x509 -req -in server-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out server-crt.pem

# Create client certificate, remove passphrase, and sign it
# client-crt.pem = public key, client-key.pem = private key
openssl req -newkey rsa:2048 -days 3600  -nodes -keyout client-key.pem -out client-req.pem -subj '/C=HK/ST=Hong Kong/L=Hong Kong/O=gmoynihan/CN=gmoynihan.com'
openssl rsa -in client-key.pem -out client-key.pem
openssl x509 -req -in client-req.pem -days 3600 -CA ca.pem -CAkey ca-key.pem -set_serial 01 -out client-crt.pem
