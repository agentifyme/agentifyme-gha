#!/bin/bash
set -e

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 0. List the files in the current directory
ls -la

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 1. Compress the current directory, excluding .git and the script itself
tar --exclude='./.git' --exclude='./entrypoint.sh' -czf /tmp/repo.tar.gz .
echo "Created repo.tar.gz in /tmp"

# Check if the tar file was created successfully
if [ -f "/tmp/repo.tar.gz" ]; then
    echo "Successfully created repo.tar.gz in /tmp"
    # Optional: You can add a size check here
    tar_size=$(du -h /tmp/repo.tar.gz | cut -f1)
    echo "Size of repo.tar.gz: $tar_size"
else
    echo "Error: Failed to create repo.tar.gz"
    exit 1
fi


# 2. Get current date and time
current_datetime=$(date +'%Y%m%d-%H%M%S')
echo "Current date and time: $current_datetime"

# 3. Get a presigned URL using the API
object_key="/$INPUT_PROJECT_REF/$GITHUB_SHA/repo.tar.gz"
response=$(curl -X POST -H "X-API-KEY: $INPUT_API_TOKEN" \
           -H "Content-Type: application/json" \
           -d "{\"object_key\": \"$object_key\", \"bucket_name\": \"protoml-projects-prod\"}" \
           https://api.agentifyme.ai/api/generate-presigned-url)
upload_url=$(echo $response | jq -r .data.upload_url)

# 4. Upload the tar file to the presigned URL
curl -X PUT -T /tmp/repo.tar.gz "$upload_url"
echo "File uploaded to: protoml-projects-prod$object_key"

# 5. Print the path to which the file was uploaded

# # 5. Make an API call to deploy (POST request)
# deploy_response=$(curl -X POST -H "X-API-KEY: $INPUT_API_TOKEN" \
#                   -H "Content-Type: application/json" \
#                   -d "{\"project_ref\": \"$INPUT_PROJECT_REF\", \"environment\": \"$INPUT_ENVIRONMENT\"}" \
#                   https://maluki-dev-8091.protoml.xyz/api/deploy)

# # Output the deployment response
# echo "Deployment response: $deploy_response"

# # Extract and print the deployment URL
# deployment_url=$(echo $deploy_response | jq -r .data.deployment_url)
# echo "Deployment URL: $deployment_url"

# # Print other relevant information
# echo "Command output: $(echo $deploy_response | jq -r .data.command_output)"
# echo "Command stderr: $(echo $deploy_response | jq -r .data.command_stderr)"