FROM rocker/r-ver:4.5.1

RUN /rocker_scripts/install_quarto.sh

# Install `rv`
# Install Linux dependencies
RUN apt-get update && apt-get install -y \
    lsb-release \
    git \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    curl \
    cmake \
    gdal-bin \
    gsfonts \
    libabsl-dev \
    libcurl4-openssl-dev \
    libfontconfig1-dev \
    libfreetype6-dev \
    libfribidi-dev \
    libgdal-dev \
    libgeos-dev \
    libharfbuzz-dev \
    libicu-dev \
    libjpeg-dev \
    libmagick++-dev \
    libnode-dev \
    libpng-dev \
    libproj-dev \
    libsqlite3-dev \
    libssl-dev \
    libtiff-dev \
    libudunits2-dev \
    libx11-dev \
    libxml2-dev \
    make \
    pandoc \
    zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*
RUN curl -sSL https://raw.githubusercontent.com/A2-ai/rv/refs/heads/main/scripts/install.sh | bash

WORKDIR /usr/src/app
