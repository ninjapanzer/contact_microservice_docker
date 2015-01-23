FROM ubuntu:14.04

RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

### Base Setup with elixir and erlang
RUN apt-get update
RUN apt-get install -y wget
RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
RUN apt-get update
RUN apt-get install -y gcc
RUN apt-get install -y elixir
RUN apt-get install -y erlang
RUN apt-get install -y git
RUN yes | mix local.hex
RUN yes | mix local.rebar

### Setup Microservice
RUN mkdir /var/web
RUN mkdir /var/web/contact_form_micro_service
WORKDIR /var/web/contact_form_micro_service
RUN git clone https://github.com/ninjapanzer/savvyshots_contact_form_micro_service.git .
RUN MIX_ENV=prod mix do deps.get, compile, release
WORKDIR /

ENV PORT 8888
ENV MIX_ENV prod

EXPOSE 4000
EXPOSE 8888

WORKDIR /var/web/contact_form_micro_service

CMD ["rel/contact_form_micro_service/bin/contact_form_micro_service", "start"]
