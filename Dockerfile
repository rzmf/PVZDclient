FROM centos:centos7
MAINTAINER r2h2 <rhoerbe@hoerbe.at>

RUN yum -y install curl git gcc gcc-c++ ip lsof net-tools openssl wget which

RUN yum -y groupinstall "X Window System" --setopt=group_package_types=mandatory \
 && yum -y install xclock \
 && yum -y install java-1.8.0-openjdk-devel.x86_64

# Need dbus running for USB interface -> https://github.com/CentOS/sig-cloud-instance-images/issues/22
ENV container docker
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs

RUN yum -y install centos-release-scl \
 && yum -y install rh-python34 rh-python34-python-tkinter rh-python34-python-pip
ENV PY3='scl enable rh-python34 -- python'


RUN yum -y install libffi-devel libxslt-devel libxml2 libxml2-devel openssl-devel \
 && yum clean all

# install MOCCA (+Jaba Webstart, pcsc)
RUN yum -y install icedtea-web pcsc-lite usbutils \
 && curl -O http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp

COPY install/opt/PVZDpolman /opt/PVZDpolman
COPY install/opt/PVZDpolman/PolicyManager/bin/setEnv.sh.default /opt/PVZDpolman/PolicyManager/bin/setEnv.sh
COPY install/opt/PVZDpolman/PolicyManager/bin/setConfig.sh.default /opt/PVZDpolman/PolicyManager/bin/setConfig.sh
COPY install/opt/PVZDpolman/PolicyManager/src/localconfig.py.default /opt/PVZDpolman/PolicyManager/src/localconfig.py
# no need to copy PolicyManager/src/patool_gui/patool_gui_settings.py: created automatically by patool_gui.py if missing

ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JDK_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JRE_HOME=/etc/alternatives/java_sdk_1.8.0/jre
# numpy must be installed before javabridge; javabridge before the rest because it requires a tighter range of lxml versions
WORKDIR /opt/PVZDpolman/PolicyManager
RUN scl enable rh-python34 'pip install numpy' \
 && scl enable rh-python34 'pip install javabridge' \
 && scl enable rh-python34 'pip install -r requirements.txt'



WORKDIR /opt/PVZDpolman/dependent_pkg
RUN cd pyjnius && scl enable rh-python34 'python setup.py install' && cd .. \
 && cd json2html && scl enable rh-python34 'python setup.py install' && cd ..

ARG USERNAME=liveuser
ARG UID=1000
RUN groupadd --gid $UID $USERNAME \
 && useradd --gid $UID --uid $UID $USERNAME \
 && chown -R $USERNAME:$USERNAME /opt

RUN yum -y install gnome-terminal sudo \
 && yum clean all

RUN chmod +x /opt/PVZDpolman/PolicyManager/bin/*.sh  /opt/PVZDpolman/PolicyManager/tests/*.sh
WORKDIR /opt/PVZDpolman/PolicyManager
COPY /install/scripts/start.sh /start.sh

RUN chmod a+x /start.sh
CMD ["/start.sh"]
