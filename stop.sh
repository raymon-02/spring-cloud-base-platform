#!/usr/bin/env bash

stopService() {
    if [[ "$#" -gt 1 ]]; then
        echo -e "[Stopping] Error: Wrong number of parameters"
        exit 1
    fi

    SERVICE_NAME=${1}

    echo -e "[Stopping][$SERVICE_NAME] Attempt to stop $SERVICE_NAME"
    service=`${JCMD} | grep ${SERVICE_NAME} | awk '{print $1}'`

    if [[ -z ${service} ]]; then
        echo "[Stopping][$SERVICE_NAME] $SERVICE_NAME seems to be already stopped or not started"
    else
        echo -e "[Stopping][$SERVICE_NAME] Stopping $SERVICE_NAME..."
        kill -9 ${service}
    fi

}

checkServiceStop() {
    if [[ "$#" -gt 1 ]]; then
        echo -e "[Stop] Error: Wrong number of parameters"
        exit 1
    fi

    SERVICE_NAME=${1}
    service=`${JCMD} | grep ${SERVICE_NAME}`

    if [[ -z ${service} ]]; then
        echo "[Stop][$SERVICE_NAME] Success: $SERVICE_NAME has been stopped"
    else
        echo "[Stop][$SERVICE_NAME] Error: $SERVICE_NAME has not been stopped"
    fi
}

# ====================================================================
# Check Jcmd exists
echo "[Java] Checking jcmd exists on host..."
if type -p jcmd >/dev/null 2>&1; then
    echo -e "[Java] Success: found jcmd executable in PATH"
    JCMD=jcmd
elif [[ -n "$JAVA_HOME" ]] && [[ -x "$JAVA_HOME/bin/java" ]]; then
    echo -e "[Java] Success: found java executable in JAVA_HOME"
    JCMD="$JAVA_HOME/bin/jcmd"
else
    echo "[Java] Error: no jcmd on the host. Cannot stop started services"
    exit 1
fi


services=( "$@" )


# ====================================================================
# Stopping services
echo -e "\n[Stopping] Stopping services..."
for service in ${services[@]}; do
    stopService ${service}
done


# ====================================================================
# Checking stopped services
echo -e "\n[Stop] Checking services stop..."
for service in ${services[@]}; do
    checkServiceStop ${service}
done
