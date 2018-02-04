#!/usr/bin/env bash

services=("eureka-service" "config-service" "zuul-service" "info-service" "calculate-service")

./runDocker.sh ${services[@]}
