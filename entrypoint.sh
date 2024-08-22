#!/bin/bash
set -e

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 0. List the files in the current directory
ls -la

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 1. Create a temporary directory for compression
temp_dir=$(mktemp -d)
echo "Created temporary directory: $temp_dir"

# Copy all files except the .git directory and the temporary directory itself
rsync -av --exclude='.git' --exclude="$(basename "$temp_dir")" . "$temp_dir/"

# Change to the temporary directory
cd "$temp_dir"

# Compress the copied files
tar -czf project.tar.gz .
echo "Created project.tar.gz in $temp_dir"

# 2. Get current date
current_date=$(date +'%Y-%m-%d')
echo "Current date: $current_date"

# 3. Get a presigned URL using the API
response=$(curl -X POST -H "X-API-KEY: $INPUT_API_TOKEN" \
           -H "Content-Type: application/json" \
           -d "{\"object_key\": \"project-$current_date.tar.gz\"}" \
           https://maluki-dev-8091.protoml.xyz/api/generate-presigned-url)
upload_url=$(echo $response | jq -r .data.upload_url)
echo "Upload URL: $upload_url"

# 4. Upload the tar file to the presigned URL
curl -X PUT -T project.tar.gz "$upload_url"
echo "Uploaded project.tar.gz to presigned URL"

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