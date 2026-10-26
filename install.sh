#!/usr/bin/env bash
set -euo pipefail
repo=github:LeonhardWeiler/desktop
host=${1:-legion}
sudo nix --experimental-features 'nix-command flakes' run --inputs-from "$repo" disko -- \
  --mode destroy,format,mount --flake "$repo#$host"
sudo nixos-install --no-root-passwd --flake "$repo#$host"
until sudo nixos-enter --root /mnt -c 'passwd leo'; do :; done
sudo reboot
