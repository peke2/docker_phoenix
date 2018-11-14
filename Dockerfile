#実行
FROM ubuntu:16.04

ENV SERVER_PATH=/var/www
ENV SERVER_NAME=server

RUN apt-get update && apt-get install -y wget && wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && dpkg -i erlang-solutions_1.0_all.deb && apt-get update && apt-get install -y esl-erlang && apt-get install -y elixir
RUN apt-get -y install language-pack-ja-base language-pack-ja ibus-mozc && locale-gen && apt-get -y install tzdata && cp /etc/localtime /etc/localtime.org && ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN apt-get -y install nodejs-legacy && apt-get -y install npm && apt-get -y install inotify-tools

RUN mkdir -p ${SERVER_PATH}
RUN export LC_ALL=ja_JP.UTF-8 && mix local.hex --force && mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez --force

RUN echo 'export LC_ALL=ja_JP.UTF-8' >> /root/.profile
ADD foreground.sh /root

EXPOSE 4000

ENTRYPOINT ["/root/foreground.sh"]
