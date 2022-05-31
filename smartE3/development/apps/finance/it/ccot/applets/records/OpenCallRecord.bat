del *.cer
del *.com
del OpenCallRecord.jar
del *.class
javac -classpath "java40.jar" OpenCallRecord.java
keytool -delete -alias OpenCallRecord -storepass soporte -keypass soporte
keytool -genkey -dname "CN=SISTEMAS MEXICO CS, OU=SISTEMAS CS, O=PREMIUM CS, L=MEXICO, ST=DF, C=CUAJIMALPA" -alias OpenCallRecord -validity 3600 -keypass soporte -storepass soporte
jar cvf OpenCallRecord.jar *.class
jarsigner -storepass soporte -keypass soporte OpenCallRecord.jar OpenCallRecord
del *.class


