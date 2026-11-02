FROM node:20-slim

# Install standard dependencies for agent tool execution
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install DeepSeek Harness globally
RUN npm install -g @deepseek-ai/dsh

# Pre-create directories and ensure ownership for non-root user
RUN mkdir -p /home/node/.dsh /workspace && chown -R node:node /home/node /workspace

# Copy entrypoint script and normalize line endings
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh && chmod +x /usr/local/bin/entrypoint.sh

USER node
WORKDIR /workspace

EXPOSE 3080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
