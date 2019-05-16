FROM verdaccio/verdaccio:3.11.7



# Override base image volume
# Temporary switch to root because of ECS volumes permissions
USER root
RUN apk add --update bash && rm -rf /var/cache/apk/*
RUN mkdir -p /c_verdaccio/plugins /c_verdaccio/conf /c_verdaccio/storage
RUN chown -R verdaccio:verdaccio /c_verdaccio

RUN cd /c_verdaccio/plugins && \
    wget -O ./github-oauth-ui.zip https://github.com/max-vasin/verdaccio-github-oauth-ui/releases/download/v1.0.2/dist.zip && \
    mkdir ./github-oauth-ui && \
    unzip ./github-oauth-ui.zip -d ./github-oauth-ui && rm ./github-oauth-ui.zip && \
    cd ./github-oauth-ui && \
    # because of peer deps
    yarn install --production=false

ADD ./config.yaml /c_verdaccio/conf

CMD $APPDIR/bin/verdaccio --config /c_verdaccio/conf/config.yaml --listen $PROTOCOL://0.0.0.0:${PORT}
