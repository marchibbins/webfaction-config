#! /bin/bash

PS=supervisord
SUPERVISORD=/path/to/supervisord
SUPERVISORCTL=/path/to/supervisorctl
PIDFILE=/path/to/supervisord.pid
OPTS="-c /path/to/supervisord.conf"

TRUE=1
FALSE=0

test -x $SUPERVISORD || exit 0

log() {
    echo $(date -R): ${1}
}

isRunning() {
    if [ "$(ps -p `cat ${PIDFILE}` | wc -l)" -gt 1 ]; then
        return 1
    else
        log "Supervisor not already running."
        return 0
    fi
}

start () {
    log "Checking Supervisor status."
    isRunning
    isAlive=$?

    if [ "${isAlive}" -eq $TRUE ]; then
        log "Supervisor is already running."
    else
        log "Starting Supervisor daemon."
        $SUPERVISORD $OPTS || log "Failed!"
    fi
}

stop () {
    log "Stopping Supervisor daemon."
    $SUPERVISORCTL $OPTS shutdown || log "Failed!"
}

case "$1" in
    start)
        start
        ;;

    stop)
        stop
        ;;

    restart)
        stop
        start
        ;;
esac

exit 0