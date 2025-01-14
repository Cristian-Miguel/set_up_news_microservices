# #!/bin/sh

# Docker workaround: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure

# Docker workaround: Ignore cub zk-ready
sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure

# KRaft required step: Format the storage directory with a new cluster ID
echo "kafka-storage format --ignore-formatted --cluster-id=$(kafka-storage random-uuid) -c /etc/kafka/kafka.properties" >> /etc/confluent/docker/ensure

# # Docker workaround: Remove check for KAFKA_ZOOKEEPER_CONNECT parameter
# sed -i '/KAFKA_ZOOKEEPER_CONNECT/d' /etc/confluent/docker/configure

# # Docker workaround: Ignore cub zk-ready
# sed -i 's/cub zk-ready/echo ignore zk-ready/' /etc/confluent/docker/ensure

# # KRaft required step: Format the storage directory with a new cluster ID
# if [ ! -f /var/lib/kafka/meta.properties ]; then
#   kafka-storage format --ignore-formatted --cluster-id=$(kafka-storage random-uuid) -c /etc/kafka/kraft/server.properties
# fi

# # Ensure keystore and truststore files exist
# if [ ! -f /etc/kafka/secrets/kafka.keystore.jks ]; then
#   echo "Keystore file not found!"
#   exit 1
# fi

# if [ ! -f /etc/kafka/secrets/kafka.truststore.jks ]; then
#   echo "Truststore file not found!"
#   exit 1
# fi

# # Start Kafka server
# exec /etc/confluent/docker/run