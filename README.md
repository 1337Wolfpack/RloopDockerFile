# RloopDockerFile

Contains the first bits of a work environment to be evaluated by the rloop team.

Currently installs :
- openssh server
- xrdp
- ubuntu mate desktop environment
- numpy/scipy/panda
- pulls 1 git repository (podnumsim)

Instructions :

- Install docker : www.docker.com
- clone this repository
- cd into the folder containing "Dockerfile"
- run "docker build -t rloop ." wait. It takes while. there are some lines in red... dont worry.
- run "docker run -P -it rloop"
- once it's running open another terminal and type "docker ps". it will list the open ports XXXXX->22 and YYYYY->3389. use ssh to login to the HOST with SSH on port XXXXX (user rloop/pass rloop) and rdp protocol on YYYYY blank user/password.

All this will be done with an UI later on.

