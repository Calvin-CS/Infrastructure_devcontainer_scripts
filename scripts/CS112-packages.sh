#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    ddd \
    valgrind \
    tsgl \
    bridges-cxx \
    mpich \
    libmpich-dev \
    libmpich12 \
    openmpi-bin \
    openmpi-common \
    libopenmpi-dev \
    rsh-redone-client \
    libgomp1 \
    libomp5 \
    libomp-dev \
    mpe2 \
    python3-pexpect \
    && rm -rf /var/lib/apt/lists/*

# mpich alternatives
cat >/tmp/mpi-set-selections.txt <<EOL
mpi                            manual   /usr/bin/mpicc.mpich
mpirun                         manual   /usr/bin/mpirun.mpich
mpi-x86_64-linux-gnu           manual   /usr/include/x86_64-linux-gnu/mpich
EOL

/usr/bin/update-alternatives --set-selections < /tmp/mpi-set-selections.txt && \
    /usr/bin/update-alternatives --get-selections | grep mpi | grep -v mono && \
    rm -f /tmp/mpi-set-selections.txt

# openmpi configuration
cat >/etc/openmpi/openmpi-mca-params.conf << EOL
btl_base_warn_component_unused=0
mtl = ^ofi
btl = ^uct,openib,ofi
pml = ^ucx
osc = ^ucx,pt2pt
plm_rsh_agent = rsh : ssh
btl_tcp_if_exclude = 172.17.0.0/16 192.168.122.0/24
EOL

# add SSH keygen scripts for Github
mkdir -p /usr/local/scripts
chmod 0755 /usr/local/scripts
cat >/usr/local/scripts/gen-sshkey-github.sh << EOL
#!/bin/bash

# Author: Chris Wieringa <cwieri39@calvin.edu>
# Date: 2024-08-18
# Purpose: generates an SSH key for github specifically for the user

cd ~
mkdir -p .ssh
chmod 0700 .ssh
datetime=$(date +%Y%m%d%H%M%S)
echo "Generating new SSH key for Github"
echo "-------------------------------------------------------"
ssh-keygen -b 2048 -t rsa -f ~/.ssh/github-$datetime -q -N ""
chmod 0600 ~/.ssh/github-$datetime

if test -f ~/.ssh/config; then
	rm -f ~/.ssh/config
fi
echo "Host github.com" > ~/.ssh/config
echo -e "\tIdentityFile=~/.ssh/github-$datetime" >> ~/.ssh/config
chmod 0600 ~/.ssh/config

echo "Filename: ~/.ssh/github-$datetime"
echo "-------------------------------------------------------"
echo "Copy and paste this to Github to setup your key:"
echo ""
cat ~/.ssh/github-$datetime.pub

EOL
chmod 0755 /usr/local/scripts/gen-sshkey-github.sh
ln -s /usr/local/scripts/gen-sshkey-github.sh /usr/local/scripts/gen-sshkey-cs112.sh

cat >/etc/profile.d/cs112-path.sh << 'EOL'
#!/bin/bash

export PATH=$PATH:/usr/local/scripts

EOL
chmod 0755 /etc/profile.d/cs112-path.sh