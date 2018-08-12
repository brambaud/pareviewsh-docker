FROM php:7.2.8-cli-stretch

MAINTAINER Benjamin Rambaud (beram) <beram.job@gmail.com>

ARG PAREVIEW_VERSION=7.x-1.10
ARG PAREVIEW_DIR=/usr/local/pareviewsh
ARG PAREVIEW_GIT_REPO=https://git.drupal.org/project/pareviewsh.git

ARG NVM_VERSION=v0.33.11
ARG NODE_VERSION=8.11.3

ENV COMPOSER_ALLOW_SUPERUSER=1 \
    NVM_DIR=/usr/local/nvm

ENV PATH=${NVM_DIR}/versions/node/current/bin:/root/.local/bin:$PATH

RUN echo "### Install base..." \
    && apt-get update -y \
    && apt-get upgrade -y \
    && apt-get install -y \
           bash \
           wget \
           zip \
           git \
           curl \
           python \
           python-pip \
    && pip install --upgrade pip \
    && echo "### Base done." \
    && echo "### Install Composer..." \
    && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/local/bin --filename=composer \
    && composer global require --prefer-stable hirak/prestissimo \
    && echo "### Composer done." \
    && echo "### Install Node..." \
    && mkdir -p ${NVM_DIR} \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
    && . ${NVM_DIR}/nvm.sh \
    && nvm install ${NODE_VERSION} && nvm alias default ${NODE_VERSION} && nvm use default \
    && ln -s ${NVM_DIR}/versions/node/v${NODE_VERSION} ${NVM_DIR}/versions/node/current \
    && npm install -g npm@${NPM_VERSION} \
    && echo "### Node done." \ 
    && echo "### Install Pareview.sh..." \
    && git clone --branch ${PAREVIEW_VERSION} ${PAREVIEW_GIT_REPO} ${PAREVIEW_DIR} \
    && cd ${PAREVIEW_DIR} && composer install \
    && echo "### Pareview.sh done."

WORKDIR ${PAREVIEW_DIR}

