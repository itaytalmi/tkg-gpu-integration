# syntax=docker/dockerfile:1
FROM ubuntu:20.04

ARG KUBECTL_VERSION=v1.24.10

COPY ffmpeg-nvidia-job-template.yaml /root
COPY coordinator-service.sh /usr/local/bin/coordinator-service

RUN apt-get update && apt-get install -y curl gettext-base lsof \
    && curl -fSslL "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" -o /usr/local/bin/kubectl && chmod +x /usr/local/bin/kubectl \
    && chmod +x /usr/local/bin/coordinator-service

ENTRYPOINT ["/usr/local/bin/coordinator-service"]