FROM verdaccio/verdaccio:3.4



# Override base image volume
USER root
RUN mkdir -p /c_verdaccio/plugins /c_verdaccio/conf /c_verdaccio/storage
RUN chown -R verdaccio:verdaccio /c_verdaccio
USER verdaccio

RUN cd /c_verdaccio/plugins && \
    wget -O ./verdaccio-github-oauth.zip https://github.com/max-vasin/verdaccio-github-oauth/archive/v1.1.1.zip && \
    unzip ./verdaccio-github-oauth.zip && \
    mv ./verdaccio-github-oauth-1.1.1 ./github-oauth && \
    rm verdaccio-github-oauth.zip && \
    cd ./github-oauth && \
    yarn install

ADD ./config.yaml /c_verdaccio/conf

CMD $APPDIR/bin/verdaccio --config /c_verdaccio/conf/config.yaml --listen $PROTOCOL://0.0.0.0:${PORT}