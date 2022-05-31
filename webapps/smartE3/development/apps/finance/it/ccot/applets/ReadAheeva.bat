del *.cer
del *.com
del ReadAheeva.jar
del *.class
javac -classpath "java40.jar" ReadAheeva.java
keytool -delete -alias ReadAheeva -storepass soporte -keypass soporte
keytool -genkey -dname "CN=SISTEMAS MEXICO, OU=SISTEMAS, O=PREMIUM, L=MEXICO, ST=DF, C=CUAJIMALPA" -alias ReadAheeva -validity 3600 -keypass soporte -storepass soporte
jar cvf ReadAheeva.jar *.class
jar ufm ReadAheeva.jar addToManifest.txt
jarsigner -storepass soporte -keypass soporte ReadAheeva.jar ReadAheeva
del *.class


