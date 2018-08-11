FROM ubuntu:14.04

MAINTAINER Teruyuki Kobayashi version: 0.1

ENV PROJECT_PATH assistant-sdk-cpp
ENV GRPC_PATH ${PROJECT_PATH}/grpc
ENV LDFLAGS "$LDFLAGS -lm"
ENV GOOGLEAPIS_GENS_PATH googleapis/gens

RUN apt update && apt-get install -y git autoconf automake libtool build-essential curl unzip libasound2-dev libcurl4-openssl-dev && apt-get clean && rm -rf /var/lib/apt/lists/* \
&& git clone https://github.com/googlesamples/assistant-sdk-cpp.git \
&& cd ${PROJECT_PATH} && git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc \
&& cd ${GRPC_PATH} && git submodule update --init \
&& cd ${GRPC_PATH}/third_party/protobuf && ./autogen.sh && ./configure && make && sudo make install && sudo ldconfig \
&& cd ${GRPC_PATH} && make clean && make && sudo make install && sudo ldconfig \
&& cd ${PROJECT_PATH} && git clone https://github.com/googleapis/googleapis.git \
&& rm -rf ${PROJECT_PATH}/googleapis/google/ads \
&& cd ${PROJECT_PATH}/googleapis && make LANGUAGE=cpp \
&& cd ${PROJECT_PATH} && make run_assistant
