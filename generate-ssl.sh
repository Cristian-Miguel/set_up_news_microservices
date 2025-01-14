#!/bin/bash

# Variables
CA_KEY="ca.key"
CA_CERT="ca.crt"
CA_SERIAL="ca.srl"
DAYS_VALID=365
SERVER_KEY="kafka.server.key"
SERVER_CSR="kafka.server.csr"
SERVER_CERT="kafka.server.crt"
SERVER_KEYSTORE="kafka.keystore.jks"
SERVER_TRUSTSTORE="kafka.truststore.jks"
CLIENT_KEY="client.key"
CLIENT_CSR="client.csr"
CLIENT_CERT="client.crt"
CLIENT_KEYSTORE="client.keystore.jks"
CLIENT_TRUSTSTORE="client.truststore.jks"
STOREPASS="sslkey_creds"
KEYPASS="sslkey_creds"

# Create directories for output
OUTPUT_DIR="ssl"
mkdir -p $OUTPUT_DIR

# Move to the output directory
cd $OUTPUT_DIR

echo "=== Generating CA Key and Certificate ==="
openssl genrsa -out $CA_KEY 2048
openssl req -new -x509 -key $CA_KEY -out $CA_CERT -days $DAYS_VALID -subj "/CN=Kafka CA"

echo "=== Generating Server Key and Certificate ==="
openssl genrsa -out $SERVER_KEY 2048
openssl req -new -key $SERVER_KEY -out $SERVER_CSR -subj "/CN=kafka"
openssl x509 -req -in $SERVER_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $SERVER_CERT -days $DAYS_VALID

echo "=== Creating Server Keystore ==="
keytool -keystore $SERVER_KEYSTORE -alias kafka -validity $DAYS_VALID -genkey -keyalg RSA -storepass $STOREPASS -keypass $KEYPASS -dname "CN=kafka"
keytool -keystore $SERVER_KEYSTORE -alias CARoot -import -file $CA_CERT -storepass $STOREPASS -noprompt
keytool -keystore $SERVER_KEYSTORE -alias kafka -import -file $SERVER_CERT -storepass $STOREPASS -noprompt

echo "=== Creating Server Truststore ==="
if keytool -keystore $SERVER_TRUSTSTORE -alias CARoot -import -file $CA_CERT -storepass $STOREPASS -noprompt; then
  echo "Server Truststore created successfully."
else
  echo "ERROR: Failed to create Server Truststore!" >&2
  exit 1
fi

echo "=== Generating Client Key and Certificate ==="
openssl genrsa -out $CLIENT_KEY 2048
openssl req -new -key $CLIENT_KEY -out $CLIENT_CSR -subj "/CN=client"
openssl x509 -req -in $CLIENT_CSR -CA $CA_CERT -CAkey $CA_KEY -CAcreateserial -out $CLIENT_CERT -days $DAYS_VALID

echo "=== Creating Client Keystore ==="
keytool -keystore $CLIENT_KEYSTORE -alias client -validity $DAYS_VALID -genkey -keyalg RSA -storepass $STOREPASS -keypass $KEYPASS -dname "CN=client"
keytool -keystore $CLIENT_KEYSTORE -alias CARoot -import -file $CA_CERT -storepass $STOREPASS -noprompt
keytool -keystore $CLIENT_KEYSTORE -alias client -import -file $CLIENT_CERT -storepass $STOREPASS -noprompt

echo "=== Creating Client Truststore ==="
if keytool -keystore $CLIENT_TRUSTSTORE -alias CARoot -import -file $CA_CERT -storepass $STOREPASS -noprompt; then
  echo "Client Truststore created successfully."
else
  echo "ERROR: Failed to create Client Truststore!" >&2
  exit 1
fi

echo "=== SSL Files Created ==="
echo "Output Directory: $OUTPUT_DIR"
ls -lh
