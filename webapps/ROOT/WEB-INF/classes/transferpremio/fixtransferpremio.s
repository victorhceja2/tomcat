#!/bin/sh
CLASSPATH=/usr/local/tomcat/common/lib/log4j.jar:/usr/local/tomcat/common/lib/pg74.jdbc3.jar:/usr/local/tomcat/webapps/ROOT/WEB-INF/classes
PATH=/usr/local/j2sdk1.4.2_04/bin:$PATH
phzap java -cp $CLASSPATH:. transferpremio.FixTransferPremio $@
#phzap java -jar TransferPremio.jar $@
