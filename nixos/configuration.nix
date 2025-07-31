{ pkgs, ... }:

let unstable = import <nixos-unstable> { config.allowUnfree = true; }; in
{
  # imports = [ ./hardware-configuration.nix ];
  # imports = [ /home/pauladam/.config/nixos/configuration.nix ];

  # nix.settings.experimental-features = [ "nix-command" "flakes" ];

  ## Bootloader
  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  
  boot = {
    ## Does not do anything on boot
    # loader.grub.theme = "${pkgs.libsForQt5.breeze-grub}/grub/themes/breeze";
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    ## Silent boot option
    # initrd.verbose = false;
    # consoleLogLevel = 0;
    # kernelParams = [ "quiet" "udev.log_level=3" ];
  };
  services.power-profiles-daemon.enable = true;

  ## sheel aliases TODO
  # mkShell = {
  #   shellHook =
  #     ''
  #       zsh
  #     '';
  # };

  ## Define your hostname.
  networking.hostName = "nixos"; # Enables wireless support via wpa_supplicant.
  # networking.wireless.enable = true; # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.userControlled.enable = true;
  ## Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  time.timeZone = "Europe/Paris";
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

  ## Garbage Collection Generations
  # nix.settings.auto-optimise-store = true;
  # nix.gc.automatic = true;
  # nix.gc.dates = "weekly";
  # nix.gc.options = "--delete-older-than +5";

  ## Enable the X11 windowing system
  services.xserver.enable = true;

  ## GNOME Desktop Environment
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  ## Cosmic Desktop Manager
  # services.desktopManager.cosmic.enable = true;

  # services.tlp.enable = true; // already have powerdaemon error

  ## Documentation // does not work right now
  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

  ## Docker
  virtualisation.docker.enable = true;

  ## AppImage
  programs.appimage = {
    enable = true;
    binfmt = true;
  };

  ## Flatpak
  ## TODO: should automatically add flathub repo (and other repo ?)
  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
      flatpak remote-add --if-not-exists fedora oci+https://registry.fedoraproject.org
      flatpak remote-add --if-not-exists elementaryos https://flatpak.elementary.io/repo.flatpakrepo
    '';
  };
  # flatpak remote-add --if-not-exists --no-gpg-verify resolve-repo .repo

  ## Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
    options = "caps:swapescape";
  };

  ## Configure console keymap
  console.keyMap = "fr";

  ## Enable CUPS to print documents.
  services.printing.drivers = [ pkgs.cups-brother-dcpl3550cdw ];
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  ## Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

  ## Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.pauladam = {
    isNormalUser = true;
    description = "pauladam";
    extraGroups = [ "networkmanager" "wheel" ];
    # packages = with pkgs; [ ];
  };

  ## Automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "pauladam";

  ## Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = true;
  systemd.services."autovt@tty1".enable = true;

  ## Fix error during nixos-rebuild
  systemd.services.NetworkManager-wait-online.enable = false;

  ## Unfree packages
  nixpkgs.config.allowUnfree = true;

  ## Virtual Box
  virtualisation.virtualbox.host.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true;
  users.extraGroups.vboxusers.members = [ "pauladam" ];

  ## Zsh
  # users.defaultUserShell = pkgs.zsh;
  # programs.zsh = {
  # enable = true;
  # enableCompletion = false; # test
  # autosuggestions.enable = true; # before true
  # zsh-autoenv.enable = true;
  # syntaxHighlighting.enable = true;
  # ohMyZsh = {
  #   enable = true;
  #   theme = "robbyrussell";
  #   plugins = [
  #     "git"
  #     "npm"
  #     "history"
  #     "node"
  #     "rust"
  #     # "deno"
  #   ];
  # };
  # };

  ## Delete Gnome Apps
  ## Delete All Apps
  # services.gnome.core-utilities.enable = false;
  environment.gnome.excludePackages = [
    pkgs.cheese # photo booth
    pkgs.epiphany # web browser
    pkgs.yelp # help viewer
    pkgs.file-roller # archive manager
    pkgs.geary # email client
    pkgs.seahorse # password manager 
    pkgs.gnome-calculator
    pkgs.gnome-calendar
    pkgs.gnome-characters
    pkgs.gnome-clocks
    pkgs.gnome-contacts
    pkgs.gnome-logs
    pkgs.gnome-maps
    pkgs.gnome-music
    pkgs.gnome-weather
    pkgs.gnome-system-monitor
    # pkgs.gnome-disk-utility

    pkgs.gnome-text-editor
    pkgs.gnome-console
    pkgs.gnome-connections
    pkgs.gnome-tour
    # pkgs.gedit # text editor not in gnome right now
    # baobab # disk usage analyzer
    # eog # image viewer
    # simple-scan # document scanner
    # totem # video player
    # gnome-photos
    # evince # document viewer
    # gnome-screenshot gnome-font-viewer
  ];

  programs.firefox.enable = true;
  environment.variables.EDITOR = "nvim";
  # programs.neovim = {
  #  enable = true;
  #  defaultEditor = true;
  # };

  ## Steam
  programs.steam = {
    enable = true;
    ## Open ports in the firewall for Steam Remote Play
    remotePlay.openFirewall = true;
    ## Open ports in the firewall for Source Dedicated Server
    dedicatedServer.openFirewall = true;
    ## Open ports in the firewall for Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;
  };

  ## Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    # (nerdfonts.override { fonts = [ "FiraCode" ]; })
    newcomputermodern
  ];

  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix

    stremio

    ## Web Browser
    # chromium

    ## Utilities
    # libreoffice -> pas dingue le packaging : test de flathub
    # yazi # file explorer
    # sioyek # pdf viewer
    btop
    # xpdf # pdf tools (such as pdftotext) unstable ??
    # gnome-multi-writer
    ## Other
    # toybox busybox
    tldr # better man page
    syncthing # sync file between devices
    gnome-tweaks
    kitty # terminal emulator
    # lutris # game utility on linux

    ## Helix try
    helix

    ## Neovim Setup
    unstable.neovim
    vim
    ripgrep
    fd
    unzip
    tree-sitter
    wget
    wl-clipboard

    ## Hyprland : not using hyprland anymore
    brightnessctl # utilitary to change screen brightness

    wayland-scanner

    ## Truc Agreg
    # virtualbox
    mypy
    graphviz
    vscodium
    # jetbrains.pycharm-community-src

    ## Programming
    git
    lazygit

    ## C
    ## TODO : I have to remove some of those : very SLOW
    # gnumake # not useful
    valgrind
    clang
    clang-tools
    gcc
    lldb
    libgcc
    # raylib # not system wise

    ## Hare
    hare

    ## Typst
    unstable.typst
    unstable.tinymist
    typstyle
    typst-live
    # typst-preview

    ## Rust
    rustup
    rust-analyzer
    # cargo

    ## Nix
    nixd
    nixpkgs-fmt

    ## Coq - Ocaml
    # pkgs.mkShell {
    #   packages = [
    #     pkgs.ocamlPackages.graphics
    #     pkgs.ocamlPackages.utop
    #     pkgs.ocamlPackages.findlib
    #   ]
    # };
    # opam
    ocaml
    # ocamlPackages.ocaml-lsp
    # ocamlPackages.ocamlformat
    # ocamlPackages.graphics
    # ocamlPackages.utop
    # ocamlPackages.findlib
    coq
    # TODO : this should use unstable
    # unstable.coqPackages.coq-lsp

    ## go # create a go directory in ~

    ## Python
    # python312
    python312Packages.python-lsp-server
    pypy3
    # python312Packages.pygame

    ## Lua
    # luajit lua
    luarocks
    lua51Packages.lua # for neovim
    luajitPackages.lua-lsp #lsp for neovim
    stylua

    # UXN
    uxn

    ## JS - TS
    # nodejs
    typescript
    nodePackages.typescript-language-server # deprecate change ?
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
  system.stateVersion = "25.05";
}
