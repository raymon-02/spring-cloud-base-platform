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


runService() {
    if [[ "$#" -lt 1 ]] || [[ ! -d "./$1" ]]; then
        echo -e "[Start] Error: service name was not specified or service folder doesn't exist"
        exit 1
    fi

    SERVICE_NAME=${1}

    if [[ "$#" -gt 1 ]]; then
        echo -e "[Start][$SERVICE_NAME] Error: Wrong number of parameters"
        exit 1
    fi

    echo "[Start][$SERVICE_NAME] Attempt to start $SERVICE_NAME"

    for f in ./${SERVICE_NAME}/build/libs/${SERVICE_NAME}*.jar; do
        if [[ -e "$f" ]]; then
            echo "[Start][$SERVICE_NAME] Found jar to execute: $f"
            EXEC_JAR=${f}
            break
        fi
        echo -e "[Start][$SERVICE_NAME] Error: no jar with base name: $SERVICE_NAME"
        exit 1
    done

    echo -e "[Start][$SERVICE_NAME] Starting $SERVICE_NAME..."
    DATE=`date '+%Y-%m-%d_%H_%M_%S'`
    nohup ${JAVA} -jar ${EXEC_JAR} >./log/${SERVICE_NAME}-${DATE}.log 2>&1 &
}


checkServiceRun() {
    if [[ "$#" -ne 1 ]]; then
        echo -e "[Run] Error: Wrong number of parameters"
        exit 1
    fi

    SERVICE_NAME=${1}
    service=`${JCMD} | grep ${SERVICE_NAME}`

    if [[ -z ${service} ]]; then
        echo "[Run][$SERVICE_NAME] Error: $SERVICE_NAME has not been started"
    else
        echo "[Run][$SERVICE_NAME] Success: $SERVICE_NAME has been started"
    fi
}


# ====================================================================
# Check Java exists
echo "[Java] Checking java exists on host..."
if type -p java >/dev/null 2>&1; then
    echo -e "[Java] Success: found java executable in PATH"
    JAVA=java
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    echo -e "[Java] Success: found java executable in JAVA_HOME"
    JAVA="$JAVA_HOME/bin/java"
else
    echo "[Java] Error: no java on the host"
    exit 1
fi

# Check Jcmd exists
echo "[Java] Checking jcmd exists on host..."
if type -p jcmd >/dev/null 2>&1; then
    echo -e "[Java] Success: found jcmd executable in PATH"
    JCMD=jcmd
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    echo -e "[Java] Success: found java executable in JAVA_HOME"
    JCMD="$JAVA_HOME/bin/jcmd"
else
    echo "[Java] Warning: no jcmd on the host. Cannot check and stop started services"
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
# Starting services
echo -e "\n[Start] Starting services..."
mkdir -p ./log

# Try to find eureka and run it first
for service in ${services[@]}; do
    if [[ ${service} == ${EUREKA_SERVICE} ]]; then
        echo "[Start][$EUREKA_SERVICE] Eureka-service was found. Start $EUREKA_SERVICE first"
        runService ${EUREKA_SERVICE}
        sleep 10
        break
    fi
done

# Try to find config-service and run it
for service in ${services[@]}; do
    if [[ ${service} == ${CONFIG_SERVICE} ]]; then
        echo "[Start][$CONFIG_SERVICE] Config-service was found. Start $CONFIG_SERVICE first"
        runService ${CONFIG_SERVICE}
        sleep 20
        break
    fi
done

for service in ${services[@]}; do
    if [[ ${service} == ${EUREKA_SERVICE} || ${service} == ${CONFIG_SERVICE} ]]; then
        continue
    fi
    runService ${service}
done


# ====================================================================
# Checking started services
if [[ ! -z "$JCMD" ]]; then
    echo -e "\n[Run] Checking started services..."
    for service in ${services[@]}; do
        checkServiceRun ${service}
    done
fi
