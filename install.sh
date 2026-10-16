#!/usr/bin/env bash
set -euo pipefail
flake=github:LeonhardWeiler/desktop#legion
sudo nix --experimental-features 'nix-command flakes' run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake "$flake"
sudo nixos-install --no-root-passwd --flake "$flake"
until sudo nixos-enter --root /mnt -c 'passwd leo'; do :; done
sudo reboot
