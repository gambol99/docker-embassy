#!/bin/bash
#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-01-16 17:19:42 +0000 (Fri, 16 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
SUPERVISORD=/usr/bin/supervisord
SUPERVISORD_CONF=/etc/supervisord.conf
SUPERVISORD_CONFD=/etc/supervisord.d/

annonce() {
  [ -n "$@" ] || { echo "** $@"; }
}

create_service() {
  annonce "Creating supervisor service from: ${COMMAND_ARGS}"
  cat <<EOF > ${SUPERVISORD_CONFD}/runner.conf
[program:runner]
user=root
group=root
directory=/
command=${COMMAND_ARGS}
stdout_logfile=/var/log/supervisor/%(program_name)s.log
stderr_logfile=/var/log/supervisor/%(program_name)s_error.log
EOF
  annonce "Runner Configuration"
  cat ${SUPERVISORD_CONFD}/runner.conf
}

run_services() {
  annonce "Starting the supervisord daemon service in foreground"
  $SUPERVISORD -c ${SUPERVISORD_CONF} -n
}

# step: grab the command line arguments pass to the docker
COMMAND_ARGS="$@"
annonce "Service parameters: ${COMMAND_ARGS}"

case "$1" in
  shell)
    # step; create a shell
    exec /bin/bash
    ;;
  service)
    # step: we generate a service from the command line
    create_service
    # step: we jump into supervisor
    run_services
    ;;
  *)
    # step: default action is to run supervisord
    run_services
    ;;
esac
