#!/usr/bin/env bash
set -euo pipefail
read -rp "Laptop as user@ip: " target
key=$(mktemp -d)/key
ssh-keygen -q -t ed25519 -N "" -f "$key"
nix --experimental-features 'nix-command flakes' run github:nix-community/nixos-anywhere -- \
  --flake github:LeonhardWeiler/desktop#legion --phases kexec,disko,install -i "$key" --target-host "$target"
ssh -t -i "$key" -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null "root@${target#*@}" \
  "until nixos-enter --root /mnt -c 'passwd leo'; do :; done; reboot"
