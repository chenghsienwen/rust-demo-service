FROM centos:7
MAINTAINER Chenghsien_wen <chenghsienwen@gmail.com>
EXPOSE 8080
ENV SOURCES=/sources
RUN yum update -y
RUN yum install -y file gcc openssl-devel
RUN yum install epel-release
RUN curl -sSf https://static.rust-lang.org/rustup.sh | sh -s -- --channel=nightly --disable-sudo
RUN mkdir -p $SOURCES
ADD ./ $SOURCES
WORKDIR $SOURCES
RUN bash bootstrap.sh
RUN diesel migration run --database-url="db/db.sql"
RUN cargo build --release
CMD ROCKET_ENV=production ./target/release/rust-demo-service
