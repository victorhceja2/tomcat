del *.cer
del *.com
del SignedEmailApplet.jar
del *.class
rem javac -source 1.4 -target 1.4 SignedEmailApplet.java
javac SignedEmailApplet.java
keytool -delete -alias SignedEmailApplet -storepass soporte -keypass soporte
keytool -genkey -dname "CN=SISTEMAS MEXICO, OU=SISTEMAS, O=PREMIUM, L=MEXICO, ST=DF, C=CUAJIMALPA" -alias SignedEmailApplet -validity 3600 -keypass soporte -storepass soporte
jar cvf SignedEmailApplet.jar *.class
jar ufm SignedEmailApplet.jar addToManifest.txt
jarsigner -storepass soporte -keypass soporte SignedEmailApplet.jar SignedEmailApplet
del *.class


