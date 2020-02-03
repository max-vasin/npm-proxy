FROM verdaccio/verdaccio:4.4.2

# Override base image volume
# Temporary switch to root because of ECS volumes permissions
USER root
RUN apk add --update bash python3 make && rm -rf /var/cache/apk/*
RUN mkdir -p /c_verdaccio/plugins /c_verdaccio/conf /c_verdaccio/storage
RUN chown -R verdaccio:root /c_verdaccio

ENV NODE_ENV=production
RUN npm i && npm install verdaccio-github-oauth-ui

ADD ./config.yaml /verdaccio/conf/config.yaml

