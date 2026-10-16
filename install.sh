#!/usr/bin/env bash
set -euo pipefail
repo=github:LeonhardWeiler/desktop
sudo nix --experimental-features 'nix-command flakes' run --inputs-from "$repo" disko -- \
  --mode destroy,format,mount --flake "$repo#legion"
sudo nixos-install --no-root-passwd --flake "$repo#legion"
until sudo nixos-enter --root /mnt -c 'passwd leo'; do :; done
sudo reboot
