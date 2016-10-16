#!/usr/bin/env bash

# sshd configuration data is supposed to be external to the container.
# This way config and key files may be reused if a container is destroyed and re-created.
# This scripts creates config files from defaults if tehy are missing.


if [ ! -e /opt/etc/ssh/sshd_config ]; then
    cp -p /etc/ssh/sshd_config /opt/etc/ssh/sshd_config
    echo 'GSSAPIAuthentication no' >> /opt/etc/ssh/sshd_config
    echo 'useDNS no' >> /opt/etc/ssh/sshd_config
    sed -i -e 's/#Port 22/Port 2022/' /opt/etc/ssh/sshd_config
    sed -i -e 's/^HostKey \/etc\/ssh\/ssh_host_/HostKey \/opt\/etc\/ssh\/ssh_host_/' /opt/etc/ssh/sshd_config
    #sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /opt/etc/ssh/sshd_config
fi
[ -e /opt/etc/ssh/ssh_host_rsa_key ] || ssh-keygen -q -N '' -t rsa -f /opt/etc/ssh/ssh_host_rsa_key
[ -e /opt/etc/ssh/ssh_host_ecdsa_key ] || ssh-keygen -q -N '' -t ecdsa -f /opt/etc/ssh/ssh_host_ecdsa_key
[ -e /opt/etc/ssh/ssh_host_ed25519_key ] || ssh-keygen -q -N '' -t ed25519 -f /opt/etc/ssh/ssh_host_ed25519_key

# you may set container-specific passwords in the environment: docker run -e SSHPW=xxx
if [ ! -z "${SSHPW+x}" ]; then
    echo $SSHPW | passwd -f --stdin $(id -un)
    echo 'password set to value of $SSHPW for authentication via ssh'
fi

if [ -s "/root/.ssh/authorized_keys" ]; then
    echo 'you may use ssh keys to authenticate'
else
    touch /root/.ssh/authorized_keys
    echo '/root/.ssh/authorized_keys is empty - no keys to authenticate'
fi

echo 'starting sshd in foreground'
/usr/sbin/sshd -D -f /opt/etc/ssh/sshd_config
