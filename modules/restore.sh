[ -e "$REPO" ] && exit 0
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
mkdir -p "$(dirname "$SOPS_AGE_KEY_FILE")"
bw get password sops-age >"$SOPS_AGE_KEY_FILE"
bw logout >/dev/null
until [ -r "$RESTIC_PASSWORD_FILE" ]; do
	sleep 1
done

SECONDS=0
read -r bus obj < <(kdialog --title Restore --progressbar "Restoring files from the NAS" 100)
restic restore latest --target / --include "$HOME" --json |
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
