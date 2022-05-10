FROM mcr.microsoft.com/dotnet/sdk:6.0
LABEL org.opencontainers.image.authors="Rob Emmerson"

# Install main dependencies
RUN apt -q update && \
    apt -q -y install ca-certificates zip npm ssh && \
    apt -q clean

RUN npm --version

# Install npm + bower + yarn
RUN curl -fsSL https://deb.nodesource.com/setup_12.x | bash - && \
    apt -q -y install nodejs && \
    apt -q clean && \
    npm install -g bower bower-dependency-tree yarn && \
    npm cache clean --force

WORKDIR /opt/sca

ADD yarn.tar.gz /opt/sca/target

COPY entrypoint.sh /opt/sca/

# Download SCA Resolver
RUN wget https://sca-downloads.s3.amazonaws.com/cli/latest/ScaResolver-linux64.tar.gz -O ScaResolver-linux64.tar.gz && \
    tar -xzvf ScaResolver-linux64.tar.gz && \
    rm -rf ScaResolver-linux64.tar.gz && \
    chmod +x ScaResolver && \
    chmod +x entrypoint.sh && \
    echo "alias ls='ls --color=auto'">~/.bashrc && \
    echo "alias ll='ls -la'">>~/.bashrc && \
    yarn config set 'strict-ssl' false && \
    yarn config set 'ignore-scripts' true && \
    yarn config set enableStrictSsl false && \
    yarn config set enableScripts false && \
    ls -la

# Copy European CxSca Datacenter configuration
COPY eu.Configuration.ini /opt/sca/Configuration.ini

ENV PATH="/opt/sca:${PATH}"

ENTRYPOINT ["bash", "-c", "/opt/sca/entrypoint.sh"]
