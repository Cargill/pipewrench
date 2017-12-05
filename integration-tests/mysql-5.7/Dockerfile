FROM mysql:5.7

ADD data /data
ADD wait-for-it /usr/bin
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
