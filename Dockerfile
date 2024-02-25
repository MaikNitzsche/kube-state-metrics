ARG GOVERSION=1.19
ARG GOARCH
FROM golang:${GOVERSION} as builder
ARG GOARCH
ENV HTTP_PROXY=http://de001-surf.zone2.proxy.allianz:8080/
ENV HTTPS_PROXY=http://de001-surf.zone2.proxy.allianz:8080/
ENV NO_PROXY=localhost,127.0.0.1,*.uranus,10.0.0.0/8,*.allianz,192.168.0.0/16,172.0.0.0/8,wsl2host
ENV GOARCH=${GOARCH}
WORKDIR /go/src/k8s.io/kube-state-metrics/
COPY . /go/src/k8s.io/kube-state-metrics/

RUN make build-local

FROM gcr.io/distroless/static:latest-${GOARCH}
COPY --from=builder /go/src/k8s.io/kube-state-metrics/kube-state-metrics /

USER nobody

ENTRYPOINT ["/kube-state-metrics", "--port=8080", "--telemetry-port=8081"]

EXPOSE 8080 8081
