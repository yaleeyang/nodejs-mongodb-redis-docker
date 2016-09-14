FROM node:5.11.0-slim

# Fix upstart under a virtual host https://github.com/dotcloud/docker/issues/1024
#RUN dpkg-divert --local --rename --add /sbin/initctl \
# && ln -s /bin/true /sbin/initctl

# Configure Package Management System (APT) & install MongoDB
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 \
 && echo "deb http://repo.mongodb.org/apt/debian wheezy/mongodb-org/3.2 main" | tee /etc/apt/sources.list.d/mongodb-org-3.2.list \
 && apt-get update \
 && apt-get install -y mongodb-org

# Redis server
RUN apt-get install -y redis-server

# Start redis-server
RUN redis-server /etc/redis/redis.conf

# Create the MongoDB data directory
RUN mkdir -p /data/db

# Expose port 27017 from the container to the host
EXPOSE 27017

# Set usr/bin/mongod as the dockerized entry-point application
ENTRYPOINT ["/usr/bin/mongod"]

# Start MongoDB
#RUN service mongod start \
# && redis-server /etc/redis/redis.conf

#CMD service mongod start \
# && redis-server /etc/redis/redis.conf \
# && bash