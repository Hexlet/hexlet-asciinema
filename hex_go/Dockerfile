FROM hex/base

ARG GO_VERSION=1.26.4
RUN curl -fsSL https://go.dev/dl/go${GO_VERSION}.linux-$(dpkg --print-architecture).tar.gz -o /tmp/go.tar.gz \
    && sudo tar -C /usr/local -xzf /tmp/go.tar.gz \
    && rm /tmp/go.tar.gz

ENV GOPATH=/home/hex/go
ENV PATH=/usr/local/go/bin:/home/hex/go/bin:$PATH
