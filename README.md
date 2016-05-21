PVZD/Admin docker image
=======================

A docker image for running an instance of PVZD for PMP and PAtool. Use this for
following deplyoment options:
1. Install a minimal and hardened Linux + Docker, and deploy the container;
2. Use the Dockerfile to install the targetsystem natively, i.e. without docker;
3. Same as 2., but with a VM, so you can run it on Windows or Mac.

To keep the docker image immutable, mutable files are mounted to the docker host, as configured in conf.sh.

    Steps to build your container:
    1. build_prepare.sh 
    3. execute build.sh: create docker image
    4. configure files in ./opt:
        - replace the default key material in opt/etc/pki!
    5. run docker_run.sh (run the container using the image created in step 1)
    
    
Problem when pushing this container to docker hub:
"unauthorized: authentication required" - upon push with successful login

see solution for .docker/config.json in http://stackoverflow.com/questions/36663742/docker-unauthorized-authentication-required-upon-push-with-successful-login
