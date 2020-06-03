#!/bin/bash

pkill -9 sshd && /usr/sbin/sshd -o PermitRootLogin=yes -o PrintMotd=no -o AllowTcpForwarding=yes
