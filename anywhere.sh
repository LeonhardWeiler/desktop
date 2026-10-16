#!/usr/bin/env bash
set -euo pipefail
read -rp "IP of the laptop: " ip
nix --experimental-features 'nix-command flakes' run github:nix-community/nixos-anywhere -- \
  --flake github:LeonhardWeiler/desktop#legion --phases kexec,disko,install --target-host "nixos@$ip"
ssh -t "nixos@$ip" "until sudo nixos-enter --root /mnt -c 'passwd leo'; do :; done; sudo reboot"
