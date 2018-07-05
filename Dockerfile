FROM registry.access.redhat.com/rhel:7.5

ENV GOPATH=/opt/app-root/go \
    HOME=/opt/app-root/go/src/github.com/grafana/grafana

ENV NODEJS_VERSION=8 \
    NPM_RUN=start \
    NAME=nodejs \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH \
    APP_ROOT=/opt/app-root
    
RUN yum install -y --nogpgcheck --setopt=tsflags=nodocs --disablerepo="*" --enablerepo="rhel-7-server-rpms" --enablerepo="rhel-7-server-extras-rpms" --enablerepo="rhel-server-rhscl-7-rpms" --enablerepo="rhel-7-server-optional-rpms" \
    initscripts \
    gcc \
    glibc-devel \
    git \
    golang \
    rh-nodejs8* \
    nss_wrapper \
    bzip2 ;

RUN mkdir -p $GOPATH/src/github.com/grafana && \
    cd $GOPATH/src/github.com/grafana && pwd && \
    git clone https://github.com/grafana/grafana.git ;

RUN cd $GOPATH/src/github.com/grafana/grafana && \
    go run build.go setup && \
    go run build.go build && \
    source scl_source enable rh-nodejs8 && \
    npm install -g yarn && \
    yarn install --pure-lockfile && \
    npm run build;

COPY files/scl_enable ${APP_ROOT}/etc/

ENV BASH_ENV=${APP_ROOT}/etc/scl_enable \
    ENV=${APP_ROOT}/etc/scl_enable \
    PROMPT_COMMAND=". ${APP_ROOT}/etc/scl_enable"

WORKDIR /opt/app-root/go/src/github.com/grafana/grafana
