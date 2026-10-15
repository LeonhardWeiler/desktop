{ pkgs, ... }:
let
  repo = "/home/leo/files/repos/desktop";
  helium = pkgs.callPackage ./pkgs/helium.nix { };
  restore = pkgs.writeShellApplication {
    name = "restore";
    runtimeInputs = with pkgs; [
      helium
      tailscale
      bitwarden-cli
      restic
      jq
      kdePackages.kdialog
      kdePackages.qttools
    ];
    text = builtins.readFile ./restore.sh;
  };
  links = [
    ".bashrc"
    ".bash_profile"
    ".config/nvim"
    ".config/mpv"
    ".config/git"
    ".config/pip"
    ".config/btop/btop.conf"
    ".config/voxtype/config.toml"
    ".config/voxtype/osd/handy"
    ".config/mimeapps.list"
    ".config/environment.d/10-desktop.conf"
    ".config/autostart/clipboard_sanitize.desktop"
    ".config/autostart/voxtype.desktop"
    ".config/powerdevilrc"
    ".config/kscreenlockerrc"
    ".config/kxkbrc"
    ".config/baloofilerc"
    ".config/dolphinrc"
    ".config/kdeglobals"
    ".config/kdedefaults"
    ".config/kwinrc"
    ".config/kglobalshortcutsrc"
    ".config/kactivitymanagerdrc"
    ".config/plasmashellrc"
    ".config/plasma-org.kde.plasma.desktop-appletsrc"
    ".config/gtk-3.0/settings.ini"
    ".config/gtk-4.0/settings.ini"
    ".config/pipewire/pipewire.conf.d/99-custom.conf"
    ".config/pipewire/pipewire.conf.d/10-eq.conf"
    ".config/pipewire/jack.conf.d/20-dj-jack.conf"
    ".local/bin/sanitize"
    ".local/bin/clipboard_sanitize"
    ".local/share/applications/voxtype-toggle.desktop"
    ".local/share/applications/org.mixxx.Mixxx.desktop"
    ".mixxx/Custom.kbd.cfg"
    ".mixxx/soundconfig.xml"
    ".claude/CLAUDE.md"
    ".claude/settings.json"
    ".claude/skills/implement-todo"
    ".claude/skills/review-and-update-report"
  ];
  shares = [
    "leonhard-files"
    "shared-files"
    "old-drive"
  ];
in
{
  system.stateVersion = "26.11";
  networking.hostName = "arch";
  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "mod-dh-iso-uk";
  services.xserver.xkb = {
    layout = "gb";
    variant = "colemak_dh";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (_: prev: {
      linux-firmware = prev.linux-firmware.overrideAttrs rec {
        version = "20260810";
        src = prev.fetchFromGitLab {
          owner = "kernel-firmware";
          repo = "linux-firmware";
          tag = version;
          hash = "sha256-P/fPpqaatp8Z2GV+I/OChiWGn6AhV+8w1RMFuX/LqHc=";
        };
      };
    })
  ];
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    auto-optimise-store = true;
    trusted-users = [ "leo" ];
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.networkmanager.enable = true;
  services.tailscale.enable = true;
  services.tailscale.extraSetFlags = [ "--operator=leo" ];
  hardware.bluetooth.enable = true;
  services.fstrim.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    konsole
    krdp
    kwin-x11
    plasma-browser-integration
    plasma-keyboard
    plasma-workspace-wallpapers
    qrca
    qtvirtualkeyboard
  ];
  programs.kde-pim.enable = false;
  services.orca.enable = false;
  services.speechd.enable = false;
  services.geoclue2.enable = false;
  services.fwupd.enable = false;
  networking.modemmanager.enable = false;
  documentation.nixos.enable = false;
  programs.nano.enable = false;
  environment.defaultPackages = [ ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    extraLv2Packages = [ pkgs.lsp-plugins ];
  };
  security.rtkit.enable = true;
  security.pam.loginLimits = [
    {
      domain = "@audio";
      item = "rtprio";
      type = "-";
      value = "95";
    }
    {
      domain = "@audio";
      item = "memlock";
      type = "-";
      value = "unlimited";
    }
  ];
  environment.sessionVariables.LV2_PATH = "/run/current-system/sw/lib/lv2";

  hardware.nvidia.prime.offload.enableOffloadCmd = true;
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = false;
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "edibdbjcniadpccecjdfdjjppcpchdlm" # I still don't care about cookies
    ];
    extraOpts.RestoreOnStartup = 1;
  };

  users.users.leo = {
    isNormalUser = true;
    description = "Leonhard Weiler";
    extraGroups = [
      "wheel"
      "networkmanager"
      "docker"
      "audio"
      "input"
      "dialout"
    ];
  };

  environment.etc."xdg/autostart/restore.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Restore
    Exec=${restore}/bin/restore
  '';

  systemd.user.tmpfiles.users.leo.rules = map (p: "L+ %h/${p} - - - - ${repo}/home/${p}") links;

  fileSystems = builtins.listToAttrs (
    map (s: {
      name = "/mnt/nas/${s}";
      value = {
        device = "//100.65.0.90/${s}";
        fsType = "cifs";
        options = [
          "noauto"
          "x-systemd.automount"
          "x-systemd.mount-timeout=15"
          "x-systemd.device-timeout=15"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "nofail"
          "soft"
          "credentials=/home/leo/.config/nas/${s}"
          "uid=1000"
          "gid=100"
          "file_mode=0664"
          "dir_mode=0775"
          "iocharset=utf8"
          "nobrl"
        ];
      };
    }) shares
  );

  services.btrbk.instances.home = {
    onCalendar = "hourly";
    settings = {
      timestamp_format = "long";
      snapshot_preserve_min = "2h";
      snapshot_preserve = "48h 14d 8w";
      volume."/mnt/btrfs" = {
        snapshot_dir = "snapshots";
        subvolume.home = { };
      };
    };
  };

  services.restic.backups.nas = {
    repository = "/mnt/nas/leonhard-files/restic/arch";
    passwordFile = "/home/leo/.config/restic/password";
    initialize = true;
    paths = [
      "/home/leo"
      "/var/lib"
      "/etc/NetworkManager/system-connections"
    ];
    exclude = [
      "/home/leo/.cache"
      "/var/lib/docker"
      "/home/leo/.local/share/Steam"
      "/home/leo/go"
      "/home/leo/.local/share/go"
      "/home/leo/.local/share/voxtype/models"
      "/home/leo/.npm"
      "**/node_modules"
      "**/target"
      "**/result"
    ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
    pruneOpts = [
      "--keep-daily 7"
      "--keep-weekly 8"
      "--keep-monthly 12"
    ];
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages =
    (with pkgs; [
      helium
      restore
      (callPackage ./pkgs/eitype.nix { })
      (voxtype.override { vulkanSupport = true; })
      t3code
      claude-code
      bitwarden-desktop
      signal-desktop
      teams-for-linux
      zed-editor
      scribus
      ktailctl
      ktimetracker
      figma-agent
      ghostty
      quickshell
      obs-studio
      audacity
      mixxx
      lsp-plugins
      neovim
      gcc
      gnumake
      git
      gh
      glab
      typst
      uv
      nodejs
      jq
      btop
      restic
      rsync
      wget
      zip
      unzip
      file
      ffmpeg
      exiftool
      mat2
      qpdf
      ps_mem
      internetarchive
      wl-clipboard
      wtype
      android-tools
      dnsutils
      acpi
      exfatprogs
      ntfs3g
      dosfstools
      cifs-utils
      qt6Packages.qt6ct
    ])
    ++ (with pkgs.kdePackages; [
      kdenlive
      kcalc
      filelight
      kolourpaint
      isoimagewriter
      keepsecret
      kio-admin
      kdegraphics-thumbnailers
    ]);
}
