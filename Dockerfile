FROM openjdk:8-jre-alpine
#FROM java:alpine

RUN mkdir -p /opt/tomcat
WORKDIR /opt/tomcat

RUN set -x \
	&& mkdir /opt/tomcat/logs \
	&& apk add --update curl \	
	&& curl -fSL http://mirrors.standaloneinstaller.com/apache/tomcat/tomcat-8/v8.5.34/bin/apache-tomcat-8.5.34.tar.gz -o /opt/tomcat/tomcat.tar.gz \	
	&& addgroup -S tomcat \
 	&& adduser -S tomcat -G tomcat \
	&& chown -R tomcat:tomcat /opt/tomcat \
	&& chmod -R 775 /opt/tomcat \
	&& cd /opt/tomcat \
    	&& tar -zxf tomcat.tar.gz \
	&& mv /opt/tomcat/apache-tomcat-8.5.34/* /opt/tomcat \
	&& mv /opt/tomcat/conf/tomcat-users.xml /opt/tomcat/conf/tomcat-users.xml.bak \
	&& rm -rf /opt/tomcat/apache-tomcat-8.5.34 \
	&& rm -rf /opt/tomcat/bin/*.bat \
	&& curl -fSL https://raw.githubusercontent.com/switek/tomcat-openshift/master/tomcat-users.xml -o /opt/tomcat/conf/tomcat-users.xml \
	&& curl -fSL https://raw.githubusercontent.com/switek/tomcat-openshift/master/setenv.sh -o /opt/tomcat/bin/setenv.sh \
	&& dos2unix /opt/tomcat/bin/setenv.sh

USER tomcat

EXPOSE 8080

#CMD ["/opt/tomcat/bin/catalina.sh", "run"] 
CMD ["/opt/tomcat/bin/catalina.sh", "start"] 
