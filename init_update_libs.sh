#!/bin/bash

echo "============================================"
echo "Updating submodules"
git submodule update --init
echo "============================================"
echo "Updating libpng, expat and fribidi"
rm -rf libpng-*
rm -rf expat-*
rm -rf fribidi-*
rm -rf lame-*

# needed for fontconfig
pip install lxml

# wget -O- http://downloads.sourceforge.net/project/expat/expat/2.1.0/expat-2.1.0.tar.gz | tar xz 

wget -O- https://ftp.osuosl.org/pub/blfs/conglomeration/libpng/libpng-1.6.21.tar.xz | tar xJ
wget -O- https://github.com/fribidi/fribidi/releases/download/0.19.7/fribidi-0.19.7.tar.bz2 | tar xj 
wget -O- http://sourceforge.net/projects/lame/files/lame/3.100/lame-3.100.tar.gz | tar xz 
echo "============================================"

