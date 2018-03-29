FROM ruby:2.4.3
MAINTAINER Campus Code <dev@campuscode.com.br>

RUN apt-get update -qq
RUN apt-get install -y --no-install-recommends \
      vim \
      postgresql-client \
      tzdata

RUN ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
dpkg-reconfigure -f noninteractive tzdata

WORKDIR /gemcounter

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler

RUN bundle install
RUN gem install bundler-audit

ADD . /gemcounter
