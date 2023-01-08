FROM kaiso4786/ruby-http:3.1.2

WORKDIR /worker

COPY / .

RUN bundle install

CMD rake worker