ARG BUILD_FROM
FROM ${BUILD_FROM}

# Systeem- en ontwikkeltools
RUN apk add --no-cache \
    bash \
    curl \
    wget \
    git \
    jq \
    yq \
    nano \
    vim \
    tree \
    tmux \
    openssh-client \
    nodejs \
    npm \
    python3 \
    py3-pip \
    py3-requests \
    py3-aiohttp \
    py3-yaml \
    py3-beautifulsoup4 \
    uv \
    ttyd

# Claude Code CLI via npm (vermijdt musl-binary-problemen)
RUN npm install -g @anthropic-ai/claude-code@latest \
    && npm cache clean --force

WORKDIR /config

# Helper-scripts
COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh \
    && ln -sf /opt/scripts/welcome.sh        /usr/local/bin/welcome \
    && ln -sf /opt/scripts/claude-login.sh   /usr/local/bin/claude-login \
    && ln -sf /opt/scripts/ha-context.sh     /usr/local/bin/ha-context \
    && ln -sf /opt/scripts/setup-ha-mcp.sh   /usr/local/bin/setup-ha-mcp \
    && ln -sf /opt/scripts/session-picker.sh /usr/local/bin/session-picker

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Exec-vorm voor correcte signaalverwerking
CMD ["/run.sh"]
