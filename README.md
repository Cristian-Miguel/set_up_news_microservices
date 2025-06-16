# Basic files to set up the ecosystem of the news microservice

## Repository linked
- configuration serive https://github.com/Cristian-Miguel/news_config_service
- discovery service https://github.com/Cristian-Miguel/news_discovery_service
- api gateway https://github.com/Cristian-Miguel/news_api_gateway
- user service https://github.com/Cristian-Miguel/news_user_service
- auth service https://github.com/Cristian-Miguel/news_auth_service

## Configurate .env
To start the setup you need write all the varibles with you information, some data is divide in microservice.
Check the port that you need are not used by others programs.

## Run the shell to setup the data
First, make the shell file executable
```bash
chmod +x setup_project.sh
```
and run the shell
```bash
./setup_project.sh
```
This execute all the files and the repositories that you need to run this project.
