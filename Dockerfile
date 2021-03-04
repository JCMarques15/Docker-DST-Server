FROM centos:8
LABEL maintainer="João Marques <jcnmarques@protonmail.com>"

# Define some build arguments
ARG user=LinuxGSM
ARG uid=5000
ARG gid=5000

# Setup dependencies
RUN dnf install -y --allowerasing epel-release file nmap-ncat curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux diffutils ncurses glibc.i686 libstdc++.i686 libcurl.i686

# Setup user
RUN groupadd --gid ${gid} ${user}
RUN useradd --create-home --shell /bin/bash --uid ${uid} --gid ${gid} ${user}

# Change working directory and user
WORKDIR /home/${user}
USER ${user}

# Download and install LinuxGSM
RUN curl -L https://linuxgsm.sh --output linuxgsm.sh
RUN chmod +x linuxgsm.sh

# Install Dont Starve Together server
RUN ./linuxgsm.sh dstserver
RUN ./dstserver auto-install

# Copy configuration
COPY --chown=${user}:${user} build/*.cfg lgsm/config-lgsm/dstserver/
COPY --chown=${user}:${user} build/cluster .klei/DoNotStarveTogether/Cluster_1/
COPY --chown=${user}:${user} build/dedicated_server_mods_setup.lua serverfiles/mods/dedicated_server_mods_setup.lua

# Copy entrypoint
COPY --chown=${user}:${user} build/entrypoint.sh ./entrypoint.sh
RUN chmod +x entrypoint.sh

# Start Server
HEALTHCHECK --interval=1m --timeout=30s --start-period=1m --retries=3 CMD [ "./dstserver", "monitor", "||", "exit", "1" ]
ENTRYPOINT [ "./entrypoint.sh" ]