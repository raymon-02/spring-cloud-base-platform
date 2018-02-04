#!/usr/bin/env bash

checkServiceStop() {
    if [[ "$#" -gt 1 ]]; then
        echo -e "[Stop] Error: Wrong number of parameters"
        exit 1
    fi

    SERVICE_NAME=${1}
    service=`${DOCKER_COMPOSE} ps | grep ${SERVICE_NAME}`

    if [[ -z ${service} ]]; then
        echo "[Stop][$SERVICE_NAME] Success: $SERVICE_NAME has been stopped"
    else
        echo "[Stop][$SERVICE_NAME] Error: $SERVICE_NAME has not been stopped"
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


services=("eureka-service" "config-service" "zuul-service" "info-service" "calculate-service")


# ====================================================================
# Stopping services
echo -e "\n[Stopping] Stopping services..."
${DOCKER_COMPOSE} down


# ====================================================================
# Checking stopped services
echo -e "\n[Stop] Checking services stop..."
for service in ${services[@]}; do
    checkServiceStop ${service}
done


