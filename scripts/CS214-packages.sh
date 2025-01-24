#!/bin/bash

apt update -y && \
    DEBIAN_FRONTEND=noninteractive apt install -y \
    gnat-14 \
    clojure \
    rlwrap \
    openjfx \
    libcore-async-clojure \
    emacs-el \
    emacs \
    emacs-goodies-el \
    default-jdk-headless \
    ruby-full \
    maven \
    pccts \
    antlr4 \
    && rm -rf /var/lib/apt/lists/*

# clojure misc configuration
cat >/etc/profile.d/clojure-classpath.sh << EOL
# clojure-classpath.sh
# Date: 2022-01-14
# Author: Chris Wieringa
# Purpose: Set appropriate ./src classpath
export CLASSPATH=./src:$CLASSPATH
EOL
chmod 0755 /etc/profile.d/clojure-classpath.sh
ln -s /etc/alternatives/clojure /usr/bin/clj 

# swi-prolog
apt-add-repository -y ppa:swi-prolog/stable && \
    apt-get update -y && \
    apt-get install -y swi-prolog && \
    rm -rf /var/lib/apt/lists/*

# gnat-14 gnatmake-14 to gnatmake alias
echo "#gnat-14 gnatmake alias" >> /etc/bash.bashrc
echo "alias gnatmake=\"gnatmake-14\"" >> /etc/bash.bashrc