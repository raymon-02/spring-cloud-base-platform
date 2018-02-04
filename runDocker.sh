#!/usr/bin/env bash

buildService() {
    if [[ "$#" -lt 1 ]] || [[ ! -d "./$1" ]]; then
        echo -e "[Build] Error: service name was not specified or service folder doesn't exist"
        exit 1
    fi

    SERVICE_NAME=${1}

    if [[ "$#" -gt 1 ]]; then
        echo -e "[Build][$SERVICE_NAME] Error: Wrong number of parameters"
        exit 1
    fi

    echo -e "[Build][$SERVICE_NAME] Attempt to build $SERVICE_NAME"

    if [[ ! -d "./$SERVICE_NAME/build/libs" ]]; then
        echo -e "[Build][$SERVICE_NAME] Building $SERVICE_NAME..."
        ./gradlew :${SERVICE_NAME}:build
    else
        echo -e "[Build][$SERVICE_NAME] $SERVICE_NAME was already built"
    fi;
}


checkServiceRun() {
    if [[ "$#" -ne 1 ]]; then
        echo -e "[Run] Error: Wrong number of parameters"
        exit 1
    fi

    SERVICE_NAME=${1}
    service=`${DOCKER} ps | grep ${SERVICE_NAME}`

    if [[ -z ${service} ]]; then
        echo "[Run][$SERVICE_NAME] Error: $SERVICE_NAME has not been started"
    else
        echo "[Run][$SERVICE_NAME] Success: $SERVICE_NAME has been started"
    fi
}


# ====================================================================
# Check Docker daemon exists
echo "[Docker] Checking docker daemon running on the host..."
if type -p docker >/dev/null 2>&1; then
    echo -e "[Docker] Success: found docker daemon"
    DOCKER=docker
else
    echo "[Docker] Error: no docker daemon running on the host"
    exit 1
fi


# ====================================================================
# Check docker-compose exists
echo "[Docker-compose] Checking docker-compose exists on the host..."
if type -p docker-compose >/dev/null 2>&1; then
    echo -e "[Docker-compose] Success: found docker-compose on the host"
    DOCKER_COMPOSE=docker-compose
else
    echo "[Docker] Error: no docker-compose on the host"
    exit 1
fi


EUREKA_SERVICE="eureka-service"
CONFIG_SERVICE="config-service"
services=( "$@" )


# ====================================================================
# Building services
echo -e "\n[Build] Building services..."
for service in ${services[@]}; do
    buildService ${service}
done


# ====================================================================
# Cleaning previous docker containers
echo -e "\n[Docker clean] Cleaning previous docker containers..."
for service in ${services[@]}; do
    ${DOCKER_COMPOSE} stop ${service} 2>/dev/null
    ${DOCKER_COMPOSE} rm scbp-${service} 2>/dev/null
done


# ====================================================================
# Building docker-images
echo -e "\n[Docker build] Building docker images..."
${DOCKER_COMPOSE} build ${services[@]}


# ====================================================================
# Starting services
echo -e "\n[Start] Starting services..."

# Try to find eureka and run it first
for service in ${services[@]}; do
    if [[ ${service} == ${EUREKA_SERVICE} ]]; then
        echo "[Start][$EUREKA_SERVICE] Eureka-service was found. Start $EUREKA_SERVICE first"
        ${DOCKER_COMPOSE} up -d ${EUREKA_SERVICE}
        sleep 10
        break
    fi
done

# Try to find config-service and run it
for service in ${services[@]}; do
    if [[ ${service} == ${CONFIG_SERVICE} ]]; then
        echo "[Start][$CONFIG_SERVICE] Config-service was found. Start $CONFIG_SERVICE first"
        ${DOCKER_COMPOSE} up -d ${CONFIG_SERVICE}
        sleep 20
        break
    fi
done

for service in ${services[@]}; do
    if [[ ${service} == ${EUREKA_SERVICE} || ${service} == ${CONFIG_SERVICE} ]]; then
        continue
    fi
    ${DOCKER_COMPOSE} up -d ${service}
done


# ====================================================================
# Checking started services
echo -e "\n[Run] Checking started services..."
for service in ${services[@]}; do
    checkServiceRun ${service}
done
