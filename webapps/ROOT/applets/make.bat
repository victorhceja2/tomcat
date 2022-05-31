del *.class
javac -classpath ..\WEB-INF\lib\java40.jar -target 1.1 YumOptions.java
jar cfv YumOptions.jar *.class
del *.class
