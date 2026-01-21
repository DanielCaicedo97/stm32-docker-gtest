FROM debian:bookworm-slim

# ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    wget \
    ninja-build \
    python3 \
    python3-pip \
    gcc-arm-none-eabi \
    libnewlib-arm-none-eabi \
    libstdc++-arm-none-eabi-newlib \
    libc6-dev \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# CMake 4.2.1
RUN mkdir -p /opt/cmake && \
    wget -q https://github.com/Kitware/CMake/releases/download/v4.2.1/cmake-4.2.1-linux-x86_64.sh \
    -O /tmp/cmake.sh && \
    chmod +x /tmp/cmake.sh && \
    /tmp/cmake.sh --skip-license --prefix=/opt/cmake && \
    rm /tmp/cmake.sh

ENV PATH="/opt/cmake/bin:${PATH}"

WORKDIR /home/project
