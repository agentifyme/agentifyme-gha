#!/bin/bash
set -e

echo "Deploying to environment: $INPUT_ENVIRONMENT"

export AGENTIFYME_API_KEY=$INPUT_API_TOKEN
export AGENTIFYME_PROJECT_REF=$INPUT_PROJECT_REF

# 0. List the files in the current directory
ls -la

echo "Deploying to environment: $INPUT_ENVIRONMENT"


# 1. Download the agentifyme CLI
curl -sSL https://agentifyme.ai/install.sh | bash
export PATH=$PATH:$HOME/.agentifyme/bin
echo "Agentifyme CLI installed successfully"
echo `agentifyme version`

# 2. Check if you can authenticate with the API
agentifyme auth --api-key $INPUT_API_TOKEN
echo "Successfully authenticated with the API"

# 3. Execute the deploy command
agenitfyme deploy
