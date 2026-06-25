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
    ttyd

# Claude Code CLI via npm (vermijdt musl-binary-problemen)
RUN npm install -g @anthropic-ai/claude-code@latest \
    && npm cache clean --force

WORKDIR /config

# Helper-scripts (welkomstbanner + begeleide login)
COPY scripts/ /opt/scripts/
RUN chmod +x /opt/scripts/*.sh \
    && ln -sf /opt/scripts/welcome.sh /usr/local/bin/welcome \
    && ln -sf /opt/scripts/claude-login.sh /usr/local/bin/claude-login

COPY run.sh /run.sh
RUN chmod +x /run.sh

# Exec-vorm voor correcte signaalverwerking
CMD ["/run.sh"]
