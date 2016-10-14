FROM centos:centos7
MAINTAINER r2h2 <rhoerbe@hoerbe.at>

RUN yum -y install curl git gcc gcc-c++ ip lsof net-tools openssl sudo wget which

RUN yum -y groupinstall "X Window System" --setopt=group_package_types=mandatory \
 && yum -y install xclock gnome-terminal \
 && yum -y install java-1.8.0-openjdk-devel.x86_64

# Need dbus running for USB interface -> https://github.com/CentOS/sig-cloud-instance-images/issues/22
# ENV container docker unused
RUN yum -y swap -- remove systemd-container systemd-container-libs -- install systemd systemd-libs

RUN yum -y install centos-release-scl \
 && yum -y install rh-python34 rh-python34-python-tkinter rh-python34-python-pip
ENV PY3='scl enable rh-python34 -- python'


RUN yum -y install libffi-devel libxslt-devel libxml2 libxml2-devel openssl-devel \
 && yum clean all

# install MOCCA (+Jaba Webstart, pcsc)
RUN yum -y install icedtea-web pcsc-lite usbutils \
 && curl -O http://webstart.buergerkarte.at/mocca/webstart/mocca.jnlp

ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JDK_HOME=/etc/alternatives/java_sdk_1.8.0 \
    JRE_HOME=/etc/alternatives/java_sdk_1.8.0/jre

COPY install/opt/PVZDpolman/dependent_pkg /opt/PVZDpolman/dependent_pkg
WORKDIR /opt/PVZDpolman/dependent_pkg
RUN scl enable rh-python34 'pip install Cython' \
 && cd pyjnius && scl enable rh-python34 'python setup.py install' && cd .. \
 && cd json2html && scl enable rh-python34 'python setup.py install' && cd ..

# numpy must be installed before javabridge; javabridge before the rest because it requires a tighter range of lxml versions
RUN scl enable rh-python34 'pip install numpy' \
 && scl enable rh-python34 'pip install javabridge'

COPY install/opt/PVZDpolman/PolicyManager/requirements.txt /opt/PVZDpolman/PolicyManager/requirements.txt
RUN scl enable rh-python34 'pip install -r /opt/PVZDpolman/PolicyManager/requirements.txt' \
 && yum clean all

# install PVZD app (dependencies have been installed so far to minimize the nmber of changed layers on app updates
COPY install/opt/PVZDpolman /opt/PVZDpolman
COPY install/opt/PVZDpolman/PolicyManager/bin/setEnv.sh.default /opt/PVZDpolman/PolicyManager/bin/setEnv.sh
COPY install/opt/PVZDpolman/PolicyManager/bin/setConfig.sh.default /opt/PVZDpolman/PolicyManager/bin/setConfig.sh
COPY install/opt/PVZDpolman/PolicyManager/src/localconfig.py.default /opt/PVZDpolman/PolicyManager/src/localconfig.py
# no need to copy PolicyManager/src/patool_gui/patool_gui_settings.py: created automatically by patool_gui.py if missing

ARG USERNAME=liveuser
ARG UID=1000
RUN groupadd --gid $UID $USERNAME \
 && useradd --gid $UID --uid $UID $USERNAME \
 && mkdir -p /opt/setup/mocca_settings \
 && chown -R $USERNAME:$USERNAME /opt/PVZDpolman/PolicyManager /opt/setup/mocca_settings
COPY install/sudoers.d/liveuser /etc/sudoers.d/liveuser

# Allow sudo with nopasswords to work without tty
RUN sed -i -e 's/^Defaults\s\+requiretty/#Defaults requiretty/' /etc/sudoers \
 && chmod +x /opt/PVZDpolman/PolicyManager/bin/*.sh  /opt/PVZDpolman/PolicyManager/tests/*.sh
COPY /install/scripts/*.sh /
RUN chmod a+x /*.sh

USER $USERNAME
WORKDIR /opt/setup/mocca_settings
COPY install/mocca_settings /opt/setup/mocca_settings
RUN tar -xzf mocca.tgz \
 && tar -xzf java.tgz \
 && tar -xzf icedteaweb.tgz

WORKDIR /opt/PVZDpolman/PolicyManager/bin
CMD ["/start.sh"]
