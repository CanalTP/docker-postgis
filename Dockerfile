FROM ubuntu:16.04
MAINTAINER Helmi Ibrahim <helmi@tuxuri.com>

# RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update
RUN apt-get -y install postgresql-9.5 postgresql-contrib-9.5 postgresql-9.5-postgis-2.2 postgis
RUN echo "host    all             all             0.0.0.0/0               md5" >> /etc/postgresql/9.5/main/pg_hba.conf
RUN service postgresql start && /bin/su postgres -c "createuser -d -s -r -l docker" && /bin/su postgres -c "psql postgres -c \"ALTER USER docker WITH ENCRYPTED PASSWORD 'docker'\"" && service postgresql stop
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.5/main/postgresql.conf
RUN echo "port = 5432" >> /etc/postgresql/9.5/main/postgresql.conf

EXPOSE 5432

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

CMD ["/start.sh"]
