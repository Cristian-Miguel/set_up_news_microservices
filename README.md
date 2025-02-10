# Basic files to set up the ecosystem of the news microservice

## Repository linked
- configuration serive https://github.com/Cristian-Miguel/news_config_service
- discovery service https://github.com/Cristian-Miguel/news_discovery_service
- api gateway https://github.com/Cristian-Miguel/news_api_gateway
- user service https://github.com/Cristian-Miguel/news_user_service
- auth service https://github.com/Cristian-Miguel/news_auth_service

# Other commands
``` 
keytool -importkeystore \
  -srckeystore client.keystore.jks \
  -destkeystore client.keystore.p12 \
  -srcstoretype JKS \
  -deststoretype PKCS12 \
  -deststorepass changeit
```
```
openssl pkcs12 -in client.keystore.p12 -nocerts -nodes -out client.key
```
```
openssl pkcs12 -in client.keystore.p12 -clcerts -nokeys -out client.crt
```
