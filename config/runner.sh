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
  [ -n "$@" ] || {
    echo "** $@";
  }
}

runner_service() {
  annonce "Adding the runner service to supervisord"
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

# step: grab the command line arguments pass to the docker
COMMAND_ARGS="$@"
annonce "Runner arguments: ${COMMAND_ARGS}"

if ! [[ "${COMMAND_ARGS}" =~ ^/(usr/|)bin/(bash|sh|zsh).*$ ]]; then
  # step: inject the command line into a supervisor service
  runner_service "${COMMAND_ARGS}"
  # step: run the supervisord process in foreground
  annonce "Starting the supervisord daemon service"
  $SUPERVISORD -c ${SUPERVISORD_CONF} -n
else
  exec "$@"
fi
