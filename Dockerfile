FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ=Europe/Moscow
ENV PATH $PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin

RUN apt-get update && apt-get install -y \
  wget \
  curl \
  libcurl4-openssl-dev \
  g++ \
  clang \
  autoconf \
  automake \
  libtool \
  make \
  cmake protobuf-compiler \
  libunwind-dev git pkg-config

RUN wget https://golang.org/dl/go1.13.15.linux-amd64.tar.gz && \
  tar -C /usr/local -xzf go1.13.15.linux-amd64.tar.gz  \
  # &&  echo "export PATH=$PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/go/bin" > ~/.profile  && \
  # . ~/.profile
  && go version


RUN git clone https://github.com/google/snappy.git && \
  cd snappy && git fetch origin 1.1.8 && git checkout 1.1.8 && \
  mkdir build && cd build && cmake ../ && make && make install

RUN git clone https://github.com/google/leveldb.git && \
  cd leveldb && \
  git fetch origin 1.22 && git checkout 1.22 && \
  mkdir -p build && cd build && cmake -DCMAKE_BUILD_TYPE=Release .. && cmake --build . && make install


RUN go get -a github.com/restream/reindexer && go generate /root/go/src/github.com/restream/reindexer/bindings/builtin

RUN git clone https://github.com/Restream/reindexer && cd reindexer && mkdir -p build && cd build && cmake .. && make -j4 && make install
