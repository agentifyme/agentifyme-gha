FROM ubuntu:20.04

# Avoid prompts from apt
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools: curl, jq, rsync
RUN apt-get update && apt-get install -y \
    curl \
    jq \
    rsync \
    && rm -rf /var/lib/apt/lists/*

# Copy the action script
COPY entrypoint.sh /entrypoint.sh

# Ensure the script is executable
RUN chmod +x /entrypoint.sh

# Set the entry point to the script
ENTRYPOINT ["/entrypoint.sh"]