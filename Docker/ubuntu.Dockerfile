FROM ubuntu:22.04

LABEL maintainer="Guajira Bikes - Enginnering Team"
ARG DEBIAN_FRONTEND=noninteractive

# Instalamos:
# 1. Herramientas base (git, make, wget)
# 2. Ninja (para compilar rápido)
# 3. gcc-arm-none-eabi (El compilador para  STM32)
# 4. libnewlib-arm-none-eabi (Librerías estándar de C para micros)
RUN apt-get update && apt-get install -y \
      build-essential \
      git \
      wget \
      python3-pip \
      ninja-build \
      gcc-arm-none-eabi \
      libnewlib-arm-none-eabi \
      libstdc++-arm-none-eabi-newlib \
      && apt-get clean && rm -rf /var/lib/apt/lists/*

# Instalamos CMake V4.2.1
RUN wget https://github.com/Kitware/CMake/releases/download/v4.2.1/cmake-4.2.1-linux-x86_64.sh \
      -q -O /tmp/cmake-install.sh \
      && chmod u+x /tmp/cmake-install.sh \
      && mkdir /usr/bin/cmake \
      && /tmp/cmake-install.sh --skip-license --prefix=/usr/bin/cmake \
      && rm /tmp/cmake-install.sh

ENV PATH="/usr/bin/cmake/bin:${PATH}"

WORKDIR /home/project