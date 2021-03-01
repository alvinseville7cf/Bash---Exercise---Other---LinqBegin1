#!/usr/bin/env bash

scversion="stable"
wget -qO- "https://github.com/koalaman/shellcheck/releases/download/${scversion?}/shellcheck-${scversion?}.linux.x86_64.tar.xz" | tar -xJv &> /dev/null
folder="shellcheck-${scversion?}/"
mv "$folder/shellcheck" "."
rm -fr "$folder"
