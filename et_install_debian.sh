#!/bin/bash -xv

echo "deb https://mistertea.github.io/debian-et/debian-source/ buster main" | sudo tee /etc/apt/sources.list.d/et.list
curl -sS https://mistertea.github.io/debian-et/et.gpg | sudo apt-key add -
sudo apt update
sudo apt install et
