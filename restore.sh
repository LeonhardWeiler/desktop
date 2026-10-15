[ -e ~/files/repos/desktop ] && exit 0
trap 'kdialog --error "Restore failed. Run restore in a terminal to see why."' ERR

tmp=$(mktemp -d)
tailscale up >"$tmp/tailscale" 2>&1 &
tailscale=$!
until url=$(grep -o 'https://login.tailscale.com/[^ ]*' "$tmp/tailscale") || ! kill -0 $tailscale 2>/dev/null; do
	sleep 1
done
[ -n "$url" ] && helium --user-data-dir="$tmp/browser" "$url" &

bwpass=$(kdialog --title Bitwarden --password "Bitwarden master password")
wait $tailscale

export BITWARDENCLI_APPDATA_DIR=$tmp/bw
bw config server https://nas.taild9564d.ts.net:8443 >/dev/null
BW_SESSION=$(BW_PASSWORD=$bwpass bw login leonhard-weiler@hotmail.com --passwordenv BW_PASSWORD --raw)
export BW_SESSION
umask 077
mkdir -p ~/.config/restic ~/.config/nas
bw get password restic >~/.config/restic/password
bw logout >/dev/null

naspass=$(kdialog --title NAS --password "NAS password for leonhard")
printf 'username=leonhard\npassword=%s\n' "$naspass" >~/.config/nas/leonhard-files

SECONDS=0
read -r bus obj < <(kdialog --title Restore --progressbar "Restoring files from the NAS" 100)
restic -r /mnt/nas/leonhard-files/restic/arch --password-file ~/.config/restic/password \
	restore latest --target / --json |
	jq --unbuffered -r 'select(.message_type == "status") | .percent_done * 100 | floor' |
	while read -r p; do
		qdbus "$bus" "$obj" Set "" value "$p"
		if [ "$p" -gt 0 ]; then
			qdbus "$bus" "$obj" setLabelText "Restoring files from the NAS, $((SECONDS * (100 - p) / p / 60)) min left"
		fi
	done
qdbus "$bus" "$obj" close

kdialog --msgbox "All files are back. The laptop restarts now."
systemctl reboot
