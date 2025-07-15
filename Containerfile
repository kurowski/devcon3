FROM ubuntu:rolling

# Install essential tools and dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y \
    atuin \
    bzip2 \
    curl \
    fd-find \
    git \
    mkdocs-material \
    neovim \
    ripgrep \
    starship \
    sudo \
    tmux \
    zsh
#    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

# Install Node.js
RUN curl -fsSL https://deb.nodesource.com/setup_22.x -o nodesource_setup.sh \
    && bash nodesource_setup.sh \
    && rm nodesource_setup.sh \
    && apt-get install -y nodejs

# Install global npm packages
RUN npm install -g \
  @anthropic-ai/claude-code
#     nodemon \
#     npm-check-updates

# Expose default Expo port
EXPOSE 8081

RUN echo ubuntu ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu

# Fix fd-find path
RUN ln -s $(which fdfind) /usr/local/bin/fd

# Make default shell zsh to match macOS user expectations
RUN chsh -s $(which zsh) ubuntu \
    && cp /etc/zsh/newuser.zshrc.recommended /home/ubuntu/.zshrc

# Set working directory
WORKDIR /workspace

# Switch to non-root user
USER ubuntu

# Configure git
RUN git config --global init.defaultBranch main

# Start our default shell
CMD [ "/bin/zsh", "-l" ]
