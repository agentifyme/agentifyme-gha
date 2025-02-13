#!/bin/bash
set -e

echo "Deploying to environment: $INPUT_ENVIRONMENT"

export AGENTIFYME_API_KEY=$INPUT_API_TOKEN
export AGENTIFYME_PROJECT_REF=$INPUT_PROJECT_REF

# 0. List the files in the current directory
ls -la

echo "Deploying to environment: $INPUT_ENVIRONMENT"


echo "===== Ubuntu System Information ====="

# OS Version
echo -n "OS Version: "
lsb_release -d | cut -f2-

# Kernel Version
echo -n "Kernel Version: "
uname -r

# CPU Information
echo "CPU Information:"
lscpu | grep "Model name" | sed 's/Model name: *//'

# Memory Information
echo "Memory Information:"
free -h | grep Mem | awk '{print $2 " total, " $3 " used, " $4 " free"}'

# Disk Usage
echo "Disk Usage:"
df -h / | tail -n 1 | awk '{print $2 " total, " $3 " used, " $4 " available"}'

echo "===== End of System Information ====="


# 1. Download the agentifyme CLI
curl -LsSf https://agentifyme.ai/cli.sh | bash
export PATH=$PATH:$HOME/.agentifyme/bin
echo `agentifyme version`

# 2. Check if you can authenticate with the API
agentifyme auth login --api-key $INPUT_API_TOKEN

# 3. Execute the deploy command
agentifyme deploy
