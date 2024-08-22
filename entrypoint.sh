#!/bin/bash
set -e

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 0. List the files in the current directory
ls -la

echo "Deploying to environment: $INPUT_ENVIRONMENT"

# 1. Compress the current directory, excluding .git and the script itself
tar --exclude='./.git' --exclude='./entrypoint.sh' -czf /tmp/project.tar.gz .
echo "Created project.tar.gz in /tmp"

# 2. Get current date
current_date=$(date +'%Y-%m-%d')
echo "Current date: $current_date"

# 3. Get a presigned URL using the API
response=$(curl -X POST -H "X-API-KEY: $INPUT_API_TOKEN" \
           -H "Content-Type: application/json" \
           -d "{\"object_key\": \"project-$current_date.tar.gz\", \"bucket_name\": \"protoml-projects-prod\"}" \
           https://api.agentifyme.ai/api/generate-presigned-url)
echo "Presigned URL response: $response"
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