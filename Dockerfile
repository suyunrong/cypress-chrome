FROM cypress/base:12.1.0

USER root

#==============================
# Locale and encoding settings
#==============================
ENV LANG C.UTF-8
ENV TZ "Asia/Shanghai"
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    apt-utils \
    tzdata \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/TZ \
  && rm -rf /var/lib/apt/lists/*

#==============================
# Timezone & Encoding
#==============================
ENV LANG_WHICH zh
ENV LANG_WHERE CN
ENV ENCODING UTF-8
ENV LANGUAGE ${LANG_WHICH}_${LANG_WHERE}.${ENCODING}
ENV LANG ${LANGUAGE}
ENV LC_ALL ${LANGUAGE}
ENV TZ "Asia/Shanghai"
RUN apt-get update \
  && apt-get install --no-install-recommends -y \
    tzdata \
    locales \
  && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
  && echo $TZ > /etc/TZ \
  && sed -i -e 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=${LANGUAGE} \
  && rm -rf /var/lib/apt/lists/*

#==============================
# install Chromebrowser
#==============================
RUN \
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
  echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list && \
  apt-get update && \
  apt-get install -y dbus-x11 google-chrome-stable && \
  rm -rf /var/lib/apt/lists/*

#==============================
# "fake" dbus address to prevent errors
# https://github.com/SeleniumHQ/docker-selenium/issues/87
#==============================
ENV DBUS_SESSION_BUS_ADDRESS=/dev/null

#==============================
# Add zip utility - it comes in very handy
#==============================
RUN apt-get update && apt-get install -y zip \
  && rm -rf /var/lib/apt/lists/*
  
#==============================
# avoid too many progress messages
# https://github.com/cypress-io/cypress/issues/1243
#==============================
ENV CI=1
ARG CYPRESS_VERSION="3.2.0"

RUN echo "whoami: $(whoami)"
RUN npm config -g set user $(whoami)
RUN npm install -g "cypress@${CYPRESS_VERSION}"
RUN cypress verify

#==============================
# Cypress cache and installed version
#==============================
RUN cypress cache path
RUN cypress cache list

#==============================
# versions of local tools
#==============================
RUN echo  " node version:    $(node -v) \n" \
  "npm version:     $(npm -v) \n" \
  "yarn version:    $(yarn -v) \n" \
  "debian version:  $(cat /etc/debian_version) \n" \
  "user:            $(whoami) \n"

ENTRYPOINT ["cypress", "run"]
