FROM debian:stretch-slim

USER root

#==============================
# Locale and encoding settings
#==============================
ENV LANG_WHICH zh
ENV LANG_WHERE CN
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
ENV TZ "Asia/Shanghai"
# Layer size: small: ~9 MB
# Layer size: small: ~9 MB MB (with --no-install-recommends)
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    apt-utils \
    tzdata \
    locales \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/TZ \
  && locale-gen ${LANGUAGE} \
  && echo "export LC_ALL=C" >> /root/.bashrc \
  && dpkg-reconfigure --frontend noninteractive locales \
  && apt-get -y autoremove \
  && rm -rf /var/lib/apt/lists/*
