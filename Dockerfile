FROM toolbox.acsu.buffalo.edu:5000/ubol/perl
COPY . /module
RUN cpanm /module
RUN mkdir /stuffdb
WORKDIR /stuffdb
