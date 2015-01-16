#
#   Author: Rohith (gambol99@gmail.com)
#   Date: 2015-01-16 16:53:20 +0000 (Fri, 16 Jan 2015)
#
#  vim:ts=2:sw=2:et
#
NAME=embassy-service
AUTHOR=gambol99

.PHONY: build

build:
	docker build -t ${AUTHOR}/${NAME} .

