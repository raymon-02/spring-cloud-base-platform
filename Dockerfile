FROM openjdk:8-jre-alpine

ARG service_name
ARG version

RUN mkdir -p /usr/local/spring-cloud-base-platform

WORKDIR /usr/local/spring-cloud-base-platform

COPY ./$service_name/build/libs/$service_name-$version.jar ./

CMD java -jar ${SERVICE_NAME_ENV}-${VERSION_ENV}.jar --spring.profiles.active=docker
