FROM registry.access.redhat.com/rhel:7.5

ENV GOPATH /root/go

ENV NODEJS_VERSION=6 \
    NPM_RUN=start \
    NAME=nodejs \
    NPM_CONFIG_PREFIX=$HOME/.npm-global \
    PATH=$HOME/node_modules/.bin/:$HOME/.npm-global/bin/:$PATH

RUN yum install -y --nogpgcheck --setopt=tsflags=nodocs --disablerepo="*" --enablerepo="rhel-7-server-rpms" --enablerepo="rhel-7-server-extras-rpms" --enablerepo="rhel-server-rhscl-7-rpms" --enablerepo="rhel-7-server-optional-rpms" \
    initscripts \
    gcc \
    glibc-devel \
    git \
    golang \
    rh-nodejs6* \
    nss_wrapper \
    bzip2 ;

RUN mkdir -p $GOPATH/src/github.com/grafana && \
    cd $GOPATH/src/github.com/grafana && pwd && \
    git clone https://github.com/mrsiano/grafana.git && \
    cd grafana && pwd && git branch -a && \
    git checkout generic_oauth;


RUN cd $GOPATH/src/github.com/grafana/grafana && \
    go run build.go setup && \
    go run build.go build && \
    source scl_source enable rh-nodejs6 && \
    npm install -g yarn && \
    yarn install --pure-lockfile && \
    npm run build;

WORKDIR /root/go/src/github.com/grafana/grafana
