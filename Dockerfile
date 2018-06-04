FROM registry.access.redhat.com/rhel:7.5

ENV GOPATH /root/go

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

RUN yum install -y --nogpgcheck --setopt=tsflags=nodocs --disablerepo="*" --enablerepo="rhel-7-server-rpms" --enablerepo="rhel-7-server-extras-rpms" --enablerepo="rhel-server-rhscl-7-rpms" --enablerepo="rhel-7-server-optional-rpms" \
    initscripts \
    gcc \
    glibc-devel \
    git \
    golang \
    rh-nodejs8 \
    rh-nodejs8-npm \
    rh-nodejs8-nodejs-nodemon \
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
    source scl_source enbale rh-nodejs8 \
    npm install -g yarn && \
    yarn install --pure-lockfile && \
    npm run build;

WORKDIR /root/go/src/github.com/grafana/grafana
