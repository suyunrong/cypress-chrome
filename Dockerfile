FROM debian:stretch-slim

USER root

#==============================
# Locale and encoding settings
#==============================
ENV LANG_WHICH en
ENV LANG_WHERE US
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
# Layer size: small: ~9 MB
# Layer size: small: ~9 MB MB (with --no-install-recommends)
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    locales \
  && locale-gen ${LANGUAGE} \
  && echo "export LC_ALL=C" >> /root/.bashrc \
  && dpkg-reconfigure locales \
  && rm -rf /var/lib/apt/lists/*
