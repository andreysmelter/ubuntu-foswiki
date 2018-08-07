# To build this docker image run the following command from directory containing Dockerfile:
#     docker build -t ubuntu-foswiki .

FROM ubuntu:18.04

MAINTAINER	Andrey Smelter

# Install Foswiki dependencies
RUN apt-get update
RUN apt-get install wget -y
RUN apt-get install apache2 rcs -y
RUN apt-get install libalgorithm-diff-perl libarchive-tar-perl libauthen-sasl-perl libcgi-pm-perl libcgi-session-perl libcrypt-passwdmd5-perl libdigest-sha-perl libemail-mime-perl libencode-perl liberror-perl libfile-copy-recursive-perl libhtml-parser-perl libhtml-tree-perl libio-socket-ip-perl libio-socket-ssl-perl libjson-perl liblocale-maketext-perl liblocale-maketext-lexicon-perl liblocale-msgfmt-perl libwww-perl liblwp-protocol-https-perl liburi-perl libversion-perl -y

# Download and extract Foswiki
RUN wget -O /var/www/Foswiki-2.1.6.tgz https://github.com/foswiki/distro/releases/download/FoswikiRelease02x01x06/Foswiki-2.1.6.tgz
RUN tar -zxvf /var/www/Foswiki-2.1.6.tgz -C /var/www
RUN mv /var/www/Foswiki-2.1.6 /var/www/foswiki

# Configure Foswiki for apache server
RUN chown -R www-data:www-data /var/www/foswiki
RUN wget -O /etc/apache2/conf-available/foswiki.conf https://raw.githubusercontent.com/andreysmelter/ubuntu-foswiki/master/conf/foswiki.conf
RUN ln -s /etc/apache2/conf-available/foswiki.conf /etc/apache2/conf-enabled/foswiki.conf

# Configure apache server
RUN a2enmod rewrite
RUN a2enmod cgi

# Start apache server when you launch built image
CMD ["apachectl", "-D", "FOREGROUND"]

# Make port 80 available to the world outside this container
EXPOSE 80

# 1. Install `docker`:
#    * Follow instructions to install docker for your system: https://docs.docker.com/engine/installation
#
# 2. Install `ubuntu-foswiki`:
#    * `pull` built image from the docker hub:
#    # docker pull andreysmelter/ubuntu-foswiki
#    # docker tag andreysmelter/ubuntu-foswiki:latest ubuntu-foswiki:latest  # retag docker image
#    # docker rmi andreysmelter/ubuntu-foswiki                # remove after you have retagged it
#
#    * or `build` an image using `Dockerfile` at the root of this repo by running `docker build` from directory containing `Dockerfile`:
#    # docker build -t ubuntu-foswiki .
