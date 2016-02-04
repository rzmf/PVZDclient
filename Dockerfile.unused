FROM centos:centos7
MAINTAINER r2h2 <rhoerbe@hoerbe.at>

RUN yum -y update
#RUN yum -y groupinstall "Development Tools" --setopt=group_package_types=mandatory,default,optional
RUN yum -y install epel-release curl usbutils unzip
RUN yum -y install redhat-lsb-core opensc pcsc-lite


#RUN pip install -r PVZD/PolicyManager/requirements.txt
RUN pip install cffi gitdb GitPython pyOpenSSL pytz requests simplejson

COPY opt /opt

# === install PMP
yum -y install java-1.8.0-openjdk-devel.x86_64
ENV JAVA_HOME /etc/alternatives/java_sdk_1.8.0

# CentOS 7: preferring EPEL over redhat-scl and ius:
RUN yum -y install python34

# install required packages from pypi
RUN yum -y install libffi-devel openssl-devel
RUN pip3.4 install -r opt/PVZDpolman/PolicyManager/requirements.txt

# install dependent packages from other sources
WORKDIR /opt/PVZDpolman/dependent_pkg
RUN cd json2html && python3.4 setup.py install && cd ..  # only required for PMP
RUN cd ordereddict* && python3.4 setup.py install && cd ../../.. # only for jason2html
WORKDIR /opt/PVZDpolman/dependent_pkg/pyjnius
RUN JAVA_HOME=$JAVA_HOME; \
    JDK_HOME=JAVA_HOME; \
    JRE_HOME=JAVA_HOME/jre \
    python3.4 setup.py install && cd ..


ADD start.sh /start.sh
RUN chmod a+x /start.sh
CMD ["/start.sh"]
# Clean up yum when done.
#RUN yum -y clean all
