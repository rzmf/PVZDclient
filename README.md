PVZD/Admin docker image
=======================

A docker image for running an instance of PVZD for PMP and PAtool. Use this for
following deplyoment options:
1. Install a minimal and hardened Linux + Docker, and deploy the container;
2. Use the Dockerfile to install the targetsystem natively, i.e. without docker;
3. Same as 2., but with a VM, so you can run it on Windows or Mac.

To keep the docker image immutable, mutable files are located in /host, which is 
mounted to the docker host.

    Steps to build your container:
    1. docker_build_prepare.sh 
       (Downloads the PVZDjava, PVZDpolman and its dependent_pkg)   
    3. execute docker_build.sh: create docker image
    4. configure files in ./opt:
        - replace the default key material in opt/etc/pki!
    5. run docker_run.sh (run the container using the image created in step 1)