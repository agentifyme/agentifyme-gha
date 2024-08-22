FROM ubuntu:24.04

# Install necessary tools, e.g., curl, jq, etc.
RUN apt-get update && apt-get install -y curl jq

# Copy the action script
COPY entrypoint.sh /entrypoint.sh

# Set the entry point to the script
ENTRYPOINT ["/entrypoint.sh"]
