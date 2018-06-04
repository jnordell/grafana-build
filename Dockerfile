FROM registry.access.redhat.com/rhel:7.5

ENV GOPATH /root/go

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -

RUN yum install -y --nogpgcheck --setopt=tsflags=nodocs --disablerepo="*" --enablerepo="rhel-7-server-rpms" --enablerepo="rhel-7-server-extras-rpms" \
    initscripts \
    curl \
    tar \
    gcc \
    libc6-dev \
    git \
    go \
    nodejs \
    bzip2 \
    bzip2-libs;

RUN mkdir -p $GOPATH/src/github.com/grafana && \
    cd $GOPATH/src/github.com/grafana && pwd && \
    git clone https://github.com/mrsiano/grafana.git && \
    cd grafana && pwd && git branch -a && \
    git checkout generic_oauth;

RUN cd $GOPATH/src/github.com/grafana/grafana && \
    go run build.go setup && \
    go run build.go build && \
    npm install -g yarn && \
    yarn install --pure-lockfile && \
    npm run build;

WORKDIR /root/go/src/github.com/grafana/grafana
