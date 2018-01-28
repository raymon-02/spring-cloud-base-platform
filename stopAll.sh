#!/usr/bin/env bash

services=("eureka-service" "config-service" "zuul-service" "info-service" "calculate-service")

./stop.sh ${services[@]}
