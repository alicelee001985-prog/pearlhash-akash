FROM nvidia/cuda:12.4.1-runtime-ubuntu22.04

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl libgomp1 tini \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/pearl

ARG MINER_URL=https://pearlhash.xyz/downloads/pearl-miner-v4
RUN curl -fsSL -o pearl-miner "$MINER_URL" && chmod +x pearl-miner

ENV PEARL_POOL=84.32.220.219:9000 \
    PEARL_WALLET="prl1p78wshuqyrmy9pmmca94wj5dfcyj6rhthc9ltdchumw6l388d6krqq9gnyw" \
    PEARL_WORKER=akash

ENTRYPOINT ["/usr/bin/tini","--","/bin/sh","-c","exec /opt/pearl/pearl-miner --host \"$PEARL_POOL\" --user \"$PEARL_WALLET\" --worker \"$PEARL_WORKER\""]
