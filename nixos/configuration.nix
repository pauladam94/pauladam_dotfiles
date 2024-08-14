{ config, pkgs, ... }:

let unstable = import <nixos-unstable> { config = { allowUnfree = true; }; }; in {
  # imports = [ ./hardware-configuration.nix ];
  # imports = [ /home/pauladam/.config/nixos/configuration.nix ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  # Define your hostname.
  networking.hostName = "nixos";

  # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true; Enable networking
  networking.networkmanager.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC =
      "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;
  # services.displayManager.defaultSession = "hyprland";

  # Documentation // does not work right now documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

  # Delete some Gnome apps
  # services.gnome.core-utilities.enable = false; # delete all apps
  environment.gnome.excludePackages = with pkgs.gnome;
    [
      cheese # photo booth
      epiphany # web browser
      yelp # help viewer
      file-roller # archive manager
      geary # email client
      seahorse # password manager 
      gnome-calculator
      gnome-calendar
      gnome-characters
      gnome-clocks
      gnome-contacts
      gnome-logs
      gnome-maps
      gnome-music
      gnome-weather
      gnome-system-monitor
      pkgs.gnome-text-editor
      pkgs.gnome-console
      pkgs.gnome-connections
      pkgs.gnome-tour

      gnome-disk-utility

      # pkgs.gedit # text editor not in gnome right now
      # baobab # disk usage analyzer
      # eog # image viewer
      # simple-scan # document scanner
      # totem # video player
      # gnome-photos
      # evince # document viewer
      # gnome-screenshot gnome-font-viewer
    ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default, no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager). services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pauladam = {
    isNormalUser = true;
    description = "pauladam";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # program to install if I want
    ];
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "pauladam";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = true;
  systemd.services."autovt@tty1".enable = true;

  nixpkgs.config.allowUnfree = true;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh = {
    enable = true;

    enableCompletion = false; # test
    autosuggestions.enable = true; # before true
    zsh-autoenv.enable = true;
    syntaxHighlighting.enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [
        "git"
        "npm"
        "history"
        "node"
        "rust"
        "deno"
      ];
    };
  };
  programs.hyprland.enable = true;
  programs.firefox.enable = true;
  # programs.chromium.enable = true;
  environment.variables.EDITOR = "nvim";
  # programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  # };
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" ]; })
  ];

  environment.systemPackages = with pkgs; [
    ## Web Browser
    # chromium

    ## Utilities
    yazi # file explorer
    sioyek # pdf viewer
    # xpdf # pdf tools (such as pdftotext) unstable ??
    # gnome-multi-writer
    ## Other
    # toybox busybox

    ## Neovim Setup
    unstable.neovim
    ripgrep
    fd
    unzip
    tree-sitter
    wget
    wl-clipboard
    tldr # better man page 
    syncthing # sync file between devices 
    gnome.gnome-tweaks
    kitty # terminal emulator
    lutris # game utility on linux

    ## Hyprland
    brightnessctl # utilitary to change screen brightness

    ## Programming
    git
    lazygit

    ## C
    gnumake
    valgrind
    clang
    clang-tools
    gcc
    lldb
    # libgcc
    raylib

    ## Hare
    hare

    ## Typst
    # typst
    # typstfmt
    unstable.tinymist
    # tinymist

    ## Rust
    rustup
    rust-analyzer

    ## Nix
    nixpkgs-fmt

    ## Coq - Ocaml
    opam
    coq
    coqPackages.coq-lsp

    ## go # create a go directory in ~

    ## Python
    python312
    python312Packages.pygame

    ## Lua
    # luajit lua
    luarocks
    lua51Packages.lua # for neovim
    luajitPackages.lua-lsp #lsp for neovim
    stylua

    # UXN
    uxn

    ## JS - TS
    nodejs
    typescript
    nodePackages.typescript-language-server

    wayland-scanner
  ];

  # Some programs need SUID wrappers,
  # can be configured further or are started in user sessions.
  # programs.mtr.enable = true; programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon. services.openssh.enable = true;

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether. networking.firewall.enable = false;
  # skip_global_compinit = 1;
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
}
