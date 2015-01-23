FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

### Base Setup with elixir and erlang
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get install -y nginx
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y elixir
RUN apt-get install -y erlang
RUN apt-get install -y git
RUN mkdir /phoenixframework
WORKDIR /phoenixframework
RUN git clone https://github.com/phoenixframework/phoenix.git && cd phoenix && git checkout v0.8.0 && yes | mix local.hex && yes | mix local.rebar && mix do deps.get, compile
WORKDIR /

ADD /site.conf /etc/nginx/sites-available/default

### Setup Microservice
RUN mkdir /var/web
RUN mkdir /var/web/contact_form_micro_service
WORKDIR /var/web/contact_form_micro_service
RUN git clone https://github.com/ninjapanzer/savvyshots_contact_form_micro_service.git .
RUN MIX_ENV=prod mix do deps.get, compile, release
WORKDIR /

EXPOSE 4000
EXPOSE 8888
EXPOSE 80

#CMD /var/web/contact_form_micro_service/rel/contact_form_micro_service/bin/contact_form_micro_service start

CMD nginx

#CMD nginx
