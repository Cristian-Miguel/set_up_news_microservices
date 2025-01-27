# Exit script on error
set -e

echo "<<<<<<<<<< Start setup setup_ssl_in_service yml files >>>>>>>>>>"

# Start in base folder
cd ..

ROUTE_OF_SSL_CERTS="etc/kafka/secrets"
ROUTE_OF_SSL_CERTS_SERVICE="etc/kafka/ssl"
CLIENT_KEYSTORE="$ROUTE_OF_SSL_CERTS/client.keystore.jks"
TRUSTSTORE_KAFKA="$ROUTE_OF_SSL_CERTS/kafka.truststore.jks"

declare -A SERVICE_NEED_SSL
SERVICE_NEED_SSL=(
    ["auth_service"]="auth_service"
    ["user_service"]="user_service"
)

for key in "${!SERVICE_NEED_SSL[@]}"; do
    echo ""
    cd "${SERVICE_NEED_SSL[$key]}"

    echo "-- create etc folder in '${SERVICE_NEED_SSL[$key]}' --"
    mkdir etc
    cd etc

    echo "-- create kafka folder in '${SERVICE_NEED_SSL[$key]}' --"
    mkdir kafka
    cd kafka

    echo "-- create ssl folder in '${SERVICE_NEED_SSL[$key]}' --"
    mkdir ssl
    cd ssl

    cd ..
    cd ..
    cd ..
    cd ..

    SERVICE_ROUTE_KEYSTORE="${SERVICE_NEED_SSL[$key]}/$ROUTE_OF_SSL_CERTS_SERVICE/client.keystore.jks"
    SERVICE_ROUTE_TRUSTSTORE="${SERVICE_NEED_SSL[$key]}/$ROUTE_OF_SSL_CERTS_SERVICE/kafka.truststore.jks"

    echo "-- copy the necessary file in the ssl route --"
    cp "$CLIENT_KEYSTORE" "$SERVICE_ROUTE_KEYSTORE"
    cp "$TRUSTSTORE_KAFKA" "$SERVICE_ROUTE_TRUSTSTORE"

done


echo ""
echo "<<<<<<<<<< Finish setup setup_ssl_in_service yml files >>>>>>>>>>"
echo ""