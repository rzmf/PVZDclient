FROM centos:centos7
MAINTAINER r2h2 <rhoerbe@hoerbe.at>

RUN yum -y install curl git gcc gcc-c++ ip lsof net-tools openssl wget which

#RUN yum -y groupinstall "Development Tools" --setopt=group_package_types=mandatory,default,optional

RUN yum -y groups install "GNOME Desktop" \
 && yum -y install java-1.8.0-openjdk-devel.x86_64

# Need dbus running for USB interface -> https://github.com/CentOS/sig-cloud-instance-images/issues/22
ENV container docker
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs

RUN yum -y install epel-release \
 && yum -y install python34-devel
# pip should be packaged with py34, but isn't:
COPY install/scripts/get-pip.py get-pip.py
RUN python3.4 get-pip.py

RUN yum -y install libffi-devel libxml2 libxml2-devel openssl-devel

# install MOCCA (requires GUI)
RUN curl -O http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp

COPY install/opt/PVZDpolman /opt/PVZDpolman
COPY install/opt/PVZDpolman/PolicyManager/bin/setEnv.sh.default /opt/PVZDpolman/PolicyManager/bin/setEnv.sh
COPY install/opt/PVZDpolman/PolicyManager/bin/setConfig.sh.default /opt/PVZDpolman/PolicyManager/bin/setConfig.sh
COPY install/opt/PVZDpolman/PolicyManager/src/localconfig.py.default /opt/PVZDpolman/PolicyManager/src/localconfig.py
ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JDK_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JRE_HOME=/etc/alternatives/java_sdk_1.8.0/jre

WORKDIR /opt/PVZDpolman/PolicyManager
# do stuff from PVZD/PolicyManager/requirements.txt step by step
#RUN python3.4 -m pip install cffi pyOpenSSL
#RUN python3.4 -m pip install cython future gitdb GitPython pytz requests
# numpy must be installed before javabridge; javabridge before the rest because it requires a tighter range of lxml versions
RUN python3.4 -m pip install numpy \
 && python3.4 -m pip install javabridge \
 && python3.4 -m pip install -r requirements.txt

WORKDIR /opt/PVZDpolman/PolicyManager/lib

WORKDIR /opt/PVZDpolman/dependent_pkg
#RUN source /opt/pyvenv/py34/bin/activate  \
#RUN cd pyjnius && python3.4 setup.py install && make && cd .. \
# && cd json2html && python3.4 setup.py install
#
#ARG USERNAME=user
#ARG UID=3000
#RUN groupadd --gid $UID $USERNAME \
# && useradd --gid $UID --uid $UID $USERNAME \
# && chown $USERNAME:$USERNAME /run
#
#RUN chmod +x /opt/PVZDpolman/PolicyManager/bin/*.sh \
#    /opt/PVZDpolman/PolicyManager/tests/*.sh
#WORKDIR /opt/PVZDpolman/PolicyManager
#COPY /install/scripts/start.sh /start.sh
#RUN chmod a+x /start.sh
#CMD ["/start.sh"]
