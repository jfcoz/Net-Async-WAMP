FROM debian
RUN apt-get update \
 && apt-get install -y git vim libio-async-perl dh-dist-zilla cpanminus \
 && apt-get clean \
 && cpanm Net::Async::WebSocket
ADD . /src/
RUN cd /src \
 && ls -l \
 && dzil authordeps | cpanm \
 && dzil build \
 && dzil test
