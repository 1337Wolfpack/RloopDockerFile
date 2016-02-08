#!/bin/bash

/etc/init.d/xrdp start
/etc/init.d/ssh start

tail -f /var/log/xrdp-sesman.log
