#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    build-essential \
    ddd \
    valgrind \
    python3-pexpect \
    && rm -rf /var/lib/apt/lists/*

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

cat >/etc/profile.d/cs232-path.sh << EOL
#!/bin/bash

export PATH=$PATH:/usr/local/scripts

EOL
chmod 0755 /etc/profile.d/cs232-path.sh