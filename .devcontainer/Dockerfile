FROM ubuntu:16.04

# Or your actual UID, GID on Linux if not the default 1000
ARG USERNAME=ada
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y \
    apt-utils \
    dialog \
    iproute2 \
    procps \
    curl \
    gnupg \
    python \
    build-essential \
    git \
    jq \
    curl \
    sudo \
    vim \
    openssh-client && \
    # Install Docker CE CLI
    apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release && \
    curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | (OUT=$(apt-key add - 2>&1) || echo $OUT) && \
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" && \
    apt-get update && \
    apt-get install -y docker-ce-cli  && \
    # Install Docker Compose
    curl -sSL "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose && \
    # Install Node
    curl -sL https://deb.nodesource.com/setup_12.x | bash - && \
    apt-get install -y nodejs && \
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    groupadd --gid $USER_GID $USERNAME  && \
    useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME && \
    # [Optional] Add sudo support for non-root user
    apt-get install -y sudo && \
    echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME && \
    chmod 0440 /etc/sudoers.d/$USERNAME && \
    #
    # Clean up
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/*

RUN npm install balena-cli -g --production --unsafe-perm && \
    curl -L https://raw.githubusercontent.com/balena-io/balena-cli/master/balena-completion.bash -o /etc/bash_completion.d/balena-completion.bash

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=

CMD ["/bin/bash"]