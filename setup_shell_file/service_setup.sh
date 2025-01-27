# Exit script on error
set -e

echo "<<<<<<<<<< Start setup service repositories >>>>>>>>>>"

# Start in base folder
cd ..

# Path to the .env file
ENV_FILE=".env"

# Check if .env file exists
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: .env file not found!"
    exit 1
fi

# Export variables from the .env file
set -a
source "$ENV_FILE"
set +a

# Function to update a single file
update_file() {
    local file=$1

    if [ ! -f "$file" ]; then
        echo "Error: $file not found!"
        return
    fi

    echo "Updating $file..."

    # Read the .env file and replace placeholders
    while IFS= read -r line; do
        # Skip empty lines and comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Extract key and value
        KEY=$(echo "$line" | cut -d'=' -f1)
        VALUE=$(echo "$line" | cut -d'=' -f2-)

        # Replace the placeholder in the file
        sed -i "s|${KEY}|${VALUE}|g" "$file"
    done < "$ENV_FILE"

    echo "$file updated successfully."
}

BASE_ROUTE_SERVICE="src/main/resources"
EXAMPLE_APPLICATION_YML="$BASE_ROUTE_SERVICE/example.application.yml"
APPLICATION_YML="$BASE_ROUTE_SERVICE/application.yml"

declare -A REPOSITORIES_URL
REPOSITORIES_URL=(
    ["api_gateway"]="https://github.com/Cristian-Miguel/news_api_gateway.git"
    ["auth_service"]="https://github.com/Cristian-Miguel/news_auth_service.git"
    ["config_service"]="https://github.com/Cristian-Miguel/news_config_service.git"
    ["discovery_service"]="https://github.com/Cristian-Miguel/news_discovery_service.git"
    ["user_service"]="https://github.com/Cristian-Miguel/news_user_service.git"
)

declare -A SERVICE_ROUTES_NAMES
SERVICE_ROUTES_NAMES=(
    ["api_gateway"]="api_gateway"
    ["auth_service"]="auth_service"
    ["config_service"]="config_service"
    ["discovery_service"]="discovery_service"
    ["user_service"]="user_service"
)

declare -A EXAMPLES_YMLS_FILES_ROUTES

# Assuming SERVICE_ROUTES_NAMES and EXAMPLE_APPLICATION_YML are already defined:
EXAMPLES_YMLS_FILES_ROUTES=(
    ["api_gateway"]="api_gateway/$EXAMPLE_APPLICATION_YML"
    ["auth_service"]="auth_service/$EXAMPLE_APPLICATION_YML"
    ["config_service"]="config_service/$EXAMPLE_APPLICATION_YML"
    ["discovery_service"]="discovery_service/$EXAMPLE_APPLICATION_YML"
    ["user_service"]="user_service/$EXAMPLE_APPLICATION_YML"
)

declare -A YMLS_FILES_ROUTES
# Assuming SERVICE_ROUTES_NAMES and EXAMPLE_APPLICATION_YML are already defined:
YMLS_FILES_ROUTES=(
    ["api_gateway"]="api_gateway/$APPLICATION_YML"
    ["auth_service"]="auth_service/$APPLICATION_YML"
    ["config_service"]="config_service/$APPLICATION_YML"
    ["discovery_service"]="discovery_service/$APPLICATION_YML"
    ["user_service"]="user_service/$APPLICATION_YML"
)

for key in "${!REPOSITORIES_URL[@]}"; do

    echo "*----==== Get '${SERVICE_ROUTES_NAMES[$key]}' repository ====----*"
    git clone "${REPOSITORIES_URL[$key]}" "${SERVICE_ROUTES_NAMES[$key]}"

    cd "${SERVICE_ROUTES_NAMES[$key]}"

    echo "-- move to the develop branch --"
    git checkout develop

    echo "-- get the pom libraries --"
    mvn install

    cd ..

    echo "-- copy the example yml and create the application yml"
    cp "${EXAMPLES_YMLS_FILES_ROUTES[$key]}" "${YMLS_FILES_ROUTES[$key]}"

    echo "-- set the enviroment variables --"
    update_file "${YMLS_FILES_ROUTES[$key]}"

    echo "*----==== Finish setup "${SERVICE_ROUTES_NAMES[$key]}" repository ====----*"
    echo ""
done

echo "<<<<<<<<<< Finish setup service repositories >>>>>>>>>>"
echo ""