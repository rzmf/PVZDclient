PVZD/Admin docker image
=======================

A docker image for running an instance of PVZD for PMP and PAtool. Use this for
following deplyoment options:
1. Install a minimal and hardened Linux + Docker, and deploy the container;
2. Use the Dockerfile to install the target system natively, i.e. without docker;
3. Same as 2., but with a VM, so you can run it on Windows or Mac.

To keep the docker image immutable, mutable files are mounted to the docker 
host, as configured in conf.sh.

    # build process with manual testing: 
    git clone https://github.com/identinetics/PVZDclient.git
    git submodule init && git submodule update
    cd dscripts && git checkout master && cd .. 
    ./dscripts/build.sh # build docker image
    run requires Docker/Linux with an X-Server for the GUI client
    ./dscripts/run.sh # 
    # run unit tests in the terminal window
    
    # run manual tests in GUI and CLI
    
    
    # release process:
    docker push $IMAGENAME
    # boot PVZDliveCD (will fetch latest docker image if online)
    # test manually
      
    
Problem when pushing this container to docker hub:
"unauthorized: authentication required" - upon push with successful login

see solution for .docker/config.json in http://stackoverflow.com/questions/36663742/docker-unauthorized-authentication-required-upon-push-with-successful-login
