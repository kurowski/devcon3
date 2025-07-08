FROM ubuntu:rolling

# Install essential tools and dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive && apt-get install -y \
    fd-find \
    git \
    mkdocs-material \
    neovim \
    nodejs \
    npm \
    ripgrep \
    starship \
    sudo \
    tmux \
    zsh
#    && apt-get clean -y && rm -rf /var/lib/apt/lists/*

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
