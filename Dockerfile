FROM ubuntu:14.04

MAINTAINER Teruyuki Kobayashi version: 0.1

RUN apt-get update && apt-get install -y git

RUN git clone https://github.com/googlesamples/assistant-sdk-cpp.git

ENV PROJECT_PATH /

RUN apt-get install -y autoconf automake libtool build-essential curl unzip libasound2-dev libcurl4-openssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd assistant-sdk-cpp && git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc

ENV GRPC_PATH ${PROJECT_PATH}/grpc

RUN cd ${GRPC_PATH} && git submodule update --init

RUN cd ${GRPC_PATH}/third_party/protobuf && ./autogen.sh && ./configure && make && sudo make install && sudo ldconfig

ENV LDFLAGS "$LDFLAGS -lm"

RUN cd ${GRPC_PATH} && make clean && make && sudo make install && sudo ldconfig

