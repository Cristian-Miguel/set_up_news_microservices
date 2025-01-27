# Exit script on error
set -e

echo "<<<<<<<<<< Start setup config_service yml files >>>>>>>>>>"

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

CONFIG_FOLDER_YMLS="config_service/src/main/resources/config-repo"

## It's necessary call both arrays data the same name
declare -A EXAMPLE_YMLS_FILES
EXAMPLE_YMLS_FILES=(
    ["api_gateway"]="$CONFIG_FOLDER_YMLS/example-api-gateway.yml"
    ["auth_service"]="$CONFIG_FOLDER_YMLS/example-auth-service.yml"
    ["discovery_service"]="$CONFIG_FOLDER_YMLS/example-discovery-service.yml"
    ["user_service"]="$CONFIG_FOLDER_YMLS/example-user-service.yml"
)

declare -A YMLS_FILES
YMLS_FILES=(
    ["api_gateway"]="$CONFIG_FOLDER_YMLS/api-gateway.yml"
    ["auth_service"]="$CONFIG_FOLDER_YMLS/auth-service.yml"
    ["discovery_service"]="$CONFIG_FOLDER_YMLS/discovery-service.yml"
    ["user_service"]="$CONFIG_FOLDER_YMLS/user-service.yml"
)

echo "-- copy and setup the variable enviroment by service --"
for key in "${!EXAMPLE_YMLS_FILES[@]}"; do
    cp "${EXAMPLE_YMLS_FILES[$key]}" "${YMLS_FILES[$key]}"
    update_file "${YMLS_FILES[$key]}"
done

echo ""
echo "<<<<<<<<<< Finish setup config_service yml files >>>>>>>>>>"
echo ""