FROM antsx/antspynet:latest

USER root
ENV HOME=/tmp
ENV antsxnet_cache_directory=/tmp/.keras/ANTsXNet
ENV TF_ENABLE_ONEDNN_OPTS=0
ENV OPENBLAS_CORETYPE=GENERIC
WORKDIR /tmp

RUN . "${VIRTUAL_ENV}/bin/activate" && \
    /opt/bin/download_antsxnet_data.py \
        --cache-dir /tmp/.keras/ANTsXNet \
        --strict && \
    chmod -R a+rX /tmp/.antspy && \
    chmod -R a+rwX /tmp/.keras

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
#ENTRYPOINT ["python"]
