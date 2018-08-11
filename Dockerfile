FROM ubuntu:14.04

MAINTAINER Teruyuki Kobayashi version: 0.1

ENV PROJECT_PATH assistant-sdk-cpp
ENV GRPC_PATH ${PROJECT_PATH}/grpc
ENV LDFLAGS "$LDFLAGS -lm"
ENV GOOGLEAPIS_GENS_PATH googleapis/gens

RUN apt-get update && apt-get install -y git autoconf automake libtool build-essential curl unzip libasound2-dev libcurl4-openssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/* \
&& git clone https://github.com/googlesamples/assistant-sdk-cpp.git \
&& cd assistant-sdk-cpp && git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc \
&& cd grpc && git submodule update --init \
&& cd third_party/protobuf && ./autogen.sh && ./configure && make && sudo make install && sudo ldconfig \
&& cd ../../ && make clean && make && sudo make install && sudo ldconfig \
&& cd ../ && git clone https://github.com/googleapis/googleapis.git \
&& rm -rf googleapis/google/ads \
&& cd googleapis && make LANGUAGE=cpp \
&& cd ../ && make run_assistant \
&& rm -rf grpc && rm -rf googleapis
