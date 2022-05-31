FROM tomcat:latest 

COPY ./webapps ./webapps/ROOT
COPY ./lib/pg74.jdbc3.jar ./lib
COPY ./lib/sqljdbc4.jar ./lib
COPY ./lib/log4j.jar ./lib