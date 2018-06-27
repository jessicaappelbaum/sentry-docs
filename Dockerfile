FROM ruby:2.4

ENV LANG=C.UTF-8 \
    JEKYLL_ENV=production

RUN set -x \
    && export NODE_VERSION=8.9.1 \
    && export YARN_VERSION=1.3.2 \
    && export GNUPGHOME="$(mktemp -d)" \
    && export NPM_CONFIG_CACHE="$(mktemp -d)" \
    # gpg keys listed at https://github.com/nodejs/node
    && for key in \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      B9AE9905FFD7803F25714661B63B535A4C206CA9 \
      77984A986EBC2AA786BC0F66B01FBB92821C587A \
      56730D5401028683275BD23C23EFEFE93C4CFFFE \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      FD3A5288F042B6850C66B31F09FE44734EB7990E \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
    ; do \
      gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
    done \
    && apt-get update && apt-get install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/* \
    && wget "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && wget "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm -r "$GNUPGHOME" "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
    && apt-get purge -y --auto-remove wget \
    && npm install -g yarn@$YARN_VERSION \
    && rm -r "$NPM_CONFIG_CACHE"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN export NPM_CONFIG_CACHE="$(mktemp -d)" \
    && npm install -g node-zopfli@2.0.2 --unsafe-perm \
    && rm -r "$NPM_CONFIG_CACHE"

COPY package.json yarn.lock /usr/src/app/
RUN export YARN_CACHE_FOLDER="$(mktemp -d)" \
    && yarn install --production --pure-lockfile \
    && rm -r "$YARN_CACHE_FOLDER"

COPY Gemfile Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

RUN set -x \
    && bundle exec jekyll build --verbose --trace \
    && find _site \
        -type f \
        -name '*.html' -o \
        -name '*.js' -o \
        -name '*.css' -o \
        -name '*.svg' \
    | xargs -P 4 -I '{}' zopfli -i 9 '{}'

FROM nginx:1.12-alpine

COPY --from=0 /usr/src/app/_site/ /usr/share/nginx/html/
ADD nginx.conf /etc/nginx/conf.d/default.conf
