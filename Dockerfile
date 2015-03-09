FROM armbuild/ubuntu:14.04.1
MAINTAINER Kévin Poirot <hellslicer@minecorps.fr>

ENV VERSION v4.14-9529-beta-2015.02.02

RUN apt-get update &&\
        apt-get -y -q install gcc make wget && \
        apt-get clean && \
        rm -rf /var/cache/apt/* /var/lib/apt/lists/* && \
        wget http://www.softether-download.com/files/softether/${VERSION}-tree/Linux/SoftEther_VPN_Server/32bit_-_ARM_legacy_ABI/softether-vpnserver-${VERSION}-linux-arm-32bit.tar.gz -O /tmp/softether-vpnserver.tar.gz &&\
        tar -xzvf /tmp/softether-vpnserver.tar.gz -C /usr/local/ &&\
        rm /tmp/softether-vpnserver.tar.gz &&\
        cd /usr/local/vpnserver &&\
        chmod 600 * && chmod 700 vpnserver && chmod 700 vpncmd &&\
        make i_read_and_agree_the_license_agreement &&\
        apt-get purge -y -q --auto-remove gcc make wget

ADD runner.sh /usr/local/vpnserver/runner.sh
RUN chmod 755 /usr/local/vpnserver/runner.sh

WORKDIR /usr/local/vpnserver

EXPOSE 443/tcp 992/tcp 1194/tcp 1194/udp 5555/tcp 500/udp 4500/udp

ENTRYPOINT ["/usr/local/vpnserver/runner.sh"]