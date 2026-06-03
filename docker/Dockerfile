FROM python:3.12.12-bookworm AS builder

# ANTsPy version just used to get the data directory from its source zip
ARG ANTSPY_DATA_VERSION=0.6.2

ENV VIRTUAL_ENV=/opt/venv

# Copy source code to container
COPY . /opt/src/ANTsPyNet

RUN apt-get update && \
    python3 -m venv ${VIRTUAL_ENV} && \
    . ${VIRTUAL_ENV}/bin/activate && \
    pip install wheel && \
    pip install /opt/src/ANTsPyNet && \
    wget -O /opt/antsPy-${ANTSPY_DATA_VERSION}.zip \
      https://github.com/ANTsX/ANTsPy/archive/refs/tags/v${ANTSPY_DATA_VERSION}.zip && \
    unzip /opt/antsPy-${ANTSPY_DATA_VERSION}.zip -d /opt/ANTsPy && \
    cp -r /opt/ANTsPy/ANTsPy-${ANTSPY_DATA_VERSION}/data /opt/antspydata

FROM python:3.12.12-slim-bookworm

ARG INSTALL_ANTSXNET_DATA=0

ENV VIRTUAL_ENV=/opt/venv
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"
ENV HOME=/tmp
ENV antsxnet_cache_directory="/tmp/.keras/ANTsXNet"
ENV TF_ENABLE_ONEDNN_OPTS=0
ENV OPENBLAS_CORETYPE=GENERIC

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

RUN apt-get update && \
    apt-get install -y \
      libpng16-16 \
      procps && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /tmp/.antspy /tmp/.keras

COPY --from=builder /opt/antspydata/ /tmp/.antspy/

COPY download_antsxnet_data.py /opt/bin/

RUN echo "Install data option: ${INSTALL_ANTSXNET_DATA}" && \
    if [ "${INSTALL_ANTSXNET_DATA}" = "1" ]; then \
        . "${VIRTUAL_ENV}/bin/activate" && \
        /opt/bin/download_antsxnet_data.py \
            --cache-dir /tmp/.keras/ANTsXNet \
            --strict ; \
    else \
        echo "Skipping ANTsXNet data download"; \
    fi && \
    chmod -R a+rX /tmp/.antspy && \
    chmod -R a+rwX /tmp/.keras

WORKDIR /tmp

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
