FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
ARG OMBI_RELEASE
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="aptalca"

# environment settings
ENV HOME="/config"

RUN \
 apt-get update && \
 apt-get install -y \
 python3 \
 python3-pip \
 git 

RUN \
 ln -s /usr/bin/python3 /usr/bin/python && \
 ln -s /usr/bin/pip3 /usr/bin/pip

RUN \
 apt-get update && \
 apt-get install -y \
	libicu60 \
	libssl1.0 && \
 echo "**** install ombi ****" && \
 mkdir -p \
	/opt/ombi && \
 if [ -z ${OMBI_RELEASE+x} ]; then \
	OMBI_RELEASE=$(curl -sX GET "https://api.github.com/repos/Ombi-app/Ombi/releases/latest" \
	| awk '/tag_name/{print $4;exit}' FS='[""]'); \
 fi && \
 curl -o \
 /tmp/ombi-src.tar.gz -L \
	"https://github.com/Ombi-app/Ombi/releases/download/${OMBI_RELEASE}/linux-x64.tar.gz" && \
 tar xzf /tmp/ombi-src.tar.gz -C \
	/opt/ombi/ && \
 chmod +x /opt/ombi/Ombi && \
 echo "**** clean up ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY /root /

# ports and volumes
EXPOSE 3579
