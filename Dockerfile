ARG BASIS=ubuntu:bionic
FROM $BASIS

RUN apt-get update && apt-get install -y \
    cmake \
    curl \
    g++ \
    google-mock \
    make \
    libgtest-dev \
    libxerces-c-dev \
    libssl-dev \
    perl-base \
    perl-modules

WORKDIR /usr/src/gtest
RUN cmake CMakeLists.txt && make && cp ./*.a /usr/lib
WORKDIR /usr/src/gmock
RUN cmake CMakeLists.txt && make && cp ./*.a /usr/lib

ADD . /opt/OpenDDS

RUN cd /opt/OpenDDS && \
    ./configure --prefix=/usr/local --security --doc-group --std=c++11 && \
    make && \
    make install && \
    cp -a /opt/OpenDDS/ACE_wrappers/MPC /usr/local/share/ace/MPC

ENV ACE_ROOT=/usr/local/share/ace \
    TAO_ROOT=/usr/local/share/tao \
    DDS_ROOT=/usr/local/share/dds \
    PATH=".:/usr/local/share/ace/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

WORKDIR /opt/OpenDDS/tests/DCPS/Messenger
RUN mwc.pl -type gnuace && make

WORKDIR /opt/workspace
