#!/bin/sh
CLASSPATH=/usr/local/tomcat/common/lib/log4j.jar:/usr/local/tomcat/common/lib/pg74.jdbc3.jar:/usr/local/tomcat/webapps/ROOT/WEB-INF/classes
PATH=/usr/local/j2sdk1.4.2_04/bin:$PATH
phzap java -Xdebug -Xnoagent -Xrunjdwp:transport=dt_socket,server=y,suspend=y -Djava.compiler=NONE -cp $CLASSPATH:. transferpremio.TransferPremio $@
