{ pkgs, ... }:
let
  repo = "/home/leo/files/repos/desktop";
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
    "karoline-files"
    "florian-files"
    "eva-files"
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
  hardware.bluetooth.enable = true;
  services.fstrim.enable = true;

  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  environment.plasma6.excludePackages = with pkgs.kdePackages; [
    elisa
    khelpcenter
    krdp
    kwin-x11
    plasma-browser-integration
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
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
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;
  programs.nix-ld.enable = true;

  programs.chromium = {
    enable = true;
    extensions = [
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
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
    ];
  };

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
          "x-systemd.idle-timeout=300"
          "x-systemd.mount-timeout=15"
          "x-systemd.device-timeout=15"
          "_netdev"
          "x-systemd.after=tailscaled.service"
          "nofail"
          "soft"
          "credentials=/etc/samba/credentials/share-${s}"
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
    passwordFile = "/etc/restic/password";
    initialize = true;
    paths = [ "/home/leo" ];
    exclude = [
      "/home/leo/.cache"
      "/home/leo/.local/share/Steam"
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
      (callPackage ./pkgs/helium.nix { })
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
      yakuake
      keepsecret
      kio-admin
      kdegraphics-thumbnailers
    ]);
}
