FROM verdaccio/verdaccio:3.4



# Override base image volume
USER root
RUN mkdir -p /c_verdaccio/plugins /c_verdaccio/conf /c_verdaccio/storage
RUN chown -R verdaccio:verdaccio /c_verdaccio
USER verdaccio

RUN cd /c_verdaccio/plugins && \
    wget -O ./verdaccio-github-oauth-ui.zip https://github.com/max-vasin/verdaccio-github-oauth-ui/archive/v1.0.1.zip && \
    unzip ./verdaccio-github-oauth-ui.zip && \
    mv ./verdaccio-github-oauth-ui-1.0.1 ./github-oauth-ui && \
    rm verdaccio-github-oauth-ui.zip && \
    cd ./github-oauth-ui && \
    yarn install

ADD ./config.yaml /c_verdaccio/conf

CMD $APPDIR/bin/verdaccio --config /c_verdaccio/conf/config.yaml --listen $PROTOCOL://0.0.0.0:${PORT}