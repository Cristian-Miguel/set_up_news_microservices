#!/bin/bash

echo "<<<<<<<<<< Start setup ssl files to kafka >>>>>>>>>>"

# Start in base folder
cd ..

# Variables
CA_KEY_PEM="ca-key.pem"
CA_CERT_PEM="ca-cert.pem"
DAYS_VALID=365
STOREPASS="sslkey_creds"
KEYPASS="sslkey_creds"

# Server Variables
SERVER_KEYSTORE="kafka.keystore.jks"
SERVER_CSR="kafka-broker.csr"
SERVER_CERT="kafka-broker-signed.crt"
SERVER_TRUSTSTORE="kafka.truststore.jks"

# Client Variables
CLIENT_KEYSTORE="client.keystore.jks"
CLIENT_CSR="kafka-client.csr"
CLIENT_CERT="kafka-client-signed.crt"

# Output directories
OUTPUT_DIR="etc"
SERVER_DIR="$OUTPUT_DIR/kafka/secrets"

# Create directories
echo "=== Creating Directories ==="
mkdir -p "$SERVER_DIR" 

cd "$SERVER_DIR"

echo "=== Generating CA Key and Certificate ==="
# Generate a private key for the CA
openssl genrsa -out $CA_KEY_PEM 2048

# Generate the self-signed CA certificate
openssl req -new -x509 -key $CA_KEY_PEM -out $CA_CERT_PEM -days $DAYS_VALID <<EOF
MX
Michoacan
Morelia
localhost
localhost
localhost
cristian-m-97@hotmail.com
EOF

echo "=== Generating keytool ==="
# Generate a keystore for the Kafka broker
keytool -genkey -alias kafka-broker -keyalg RSA -keystore $SERVER_KEYSTORE -validity $DAYS_VALID -dname "CN=localhost" -keypass $KEYPASS -storepass $STOREPASS

# Create a CSR (Certificate Signing Request)
keytool -certreq -alias kafka-broker -file $SERVER_CSR -keystore $SERVER_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS

# Sign the CSR with the CA
openssl x509 -req -CA $CA_CERT_PEM -CAkey $CA_KEY_PEM -in $SERVER_CSR -out $SERVER_CERT -days $DAYS_VALID -CAcreateserial

echo "Import the CA certificate and signed certificate into the broker's keystore"
echo yes | keytool -import -alias CARoot -file $CA_CERT_PEM -keystore $SERVER_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS
echo yes | keytool -import -alias kafka-broker -file $SERVER_CERT -keystore $SERVER_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS

echo "Create a truststore and import the CA certificate"
echo yes | keytool -import -alias CARoot -file $CA_CERT_PEM -keystore $SERVER_TRUSTSTORE -keypass $KEYPASS -storepass $STOREPASS

echo "create a keystore for the client"
keytool -genkey -alias kafka-client -keyalg RSA -keystore $CLIENT_KEYSTORE -validity 365 -dname "CN=localhost" -keypass $KEYPASS -storepass $STOREPASS

echo "Create a CSR for the client"
keytool -certreq -alias kafka-client -file $CLIENT_CSR -keystore $CLIENT_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS

echo "Sign the CSR with the CA"
openssl x509 -req -CA $CA_CERT_PEM -CAkey $CA_KEY_PEM -in $CLIENT_CSR -out $CLIENT_CERT -days $DAYS_VALID -CAcreateserial

echo "Import the CA certificate and the signed client certificate into the client's keystore"
echo yes | keytool -import -alias CARoot -file $CA_CERT_PEM -keystore $CLIENT_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS

echo "Import the signed client certificate into the client's keystore"
echo yes | keytool -import -alias kafka-client -file $CLIENT_CERT -keystore $CLIENT_KEYSTORE -keypass $KEYPASS -storepass $STOREPASS

# Save password to files
echo "=== Saving Passwords to Files ==="
echo "$KEYPASS" > "kafka_secret.txt"

echo "=== SSL Files Created Successfully ==="
echo "Server SSL Files Location: $SERVER_DIR"
ls -lh "$SERVER_DIR"

echo ""
echo "<<<<<<<<<< Finish setup ssl files to kafka >>>>>>>>>>"
echo ""