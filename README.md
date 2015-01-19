
### **Docker Embassy Service**

The container which acts as a base image for containers which require embedded [embassy](https://github.com/gambol99/embassy) proxying. It assumes additional services are dropped in as supervisord.d/*.ini files, though obviously you can get creative and do something else. 

#### **Runner Service**

The default entrypoint for the container is [/bin/runner.sh](https://github.com/gambol99/docker-embassy/blob/master/config/runner.sh) unless changed, the runners performs the following;

 * **Shell**: drops you into a bash shell for debugging / testing purposed
 * **Service**: creates a supervisord service from the command line arguments and drops into supervisord in the foreground.
 * **Default**: assuming no command line arguments the default behavior is to drop into supervisord as above.

#### **Embassy**

Below is collection of environment variables passed to  [embassy](https://github.com/gambol99/embassy)
  
    NAME="Embassy Service Proxy"
    EMBASSY_VERBOSE=${EMBASSY_VERBOSE:-"-logtostderr=true -v=3"}
    EMBASSY_DISCOVERY=${EMBASSY_DISCOVERY:-"consul://localhost:8500"}
    EMBASSY_INERFACE=${EMBASSY_INERFACE:-eth0}
    EMBASSY_PORT=${EMBASSY_PORT:-9999}
    EMBASSY_PROXY=${EMBASSY_PROXY:-172.17.42.1}
    EMBASSY_OPTIONS="${EMBASSY_VERBOSE} \
    -interface=${EMBASSY_INERFACE} \
    -port=${EMBASSY_PORT} \
    -discovery=${EMBASSY_DISCOVERY} \
    -provider=static \
    -services=\"${BACKENDS}\""

Essentially the two which *need* to passed are the discovery and services 

    $ docker -d -P \
     --cap-add NET_ADMIN \
     -e EMBASSY_DISCOVERY=consul://IP:PORT \
     -e BACKENDS='frontend_http;80,mysql;3306,redis;6563' \
     ...

##### **Examples**
  
    # just drop into a sheel
    $ docker run -ti --rm -e <ENV..> gambol99/embassy-service shell
    
    # create a service from command line
    $ docker run -ti --rm -e <ENV..> gambol99/embassy-service service httpd -D FOREGROUND

##### **Apache Example**

A very simple example

    ::Dockerfile
    FROM gambol99/embassy-service
    ADD httpd.ini /etc/supervisord.d/httpd.ini
    ENV BACKENDS frontend_http;80,mysql;3306,redis;6563
    RUN yum install -y httpd
    EXPOSE 80
  
    $ docker run -d -P --cap-add NET_ADMIN \
      -e EMBASSY_DISCOVERY=consul://10.0.0.1:8500 <image>
    ...

##### Contributing
------------

 - Fork it
 - Create your feature branch (git checkout -b my-new-feature)
 - Commit your changes (git commit -am 'Add some feature')
 - Push to the branch (git push origin my-new-feature)
 - Create new Pull Request
 - If applicable, update the README.md
