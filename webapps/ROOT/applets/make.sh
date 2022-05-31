rm *.class
javac -classpath ../WEB-INF/lib/java40.jar YumOptions.java
jar cfv YumOptions.jar *.class
rm *.class
