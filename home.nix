{ config, pkgs, ... }:

{
  home.username = "yabai";
  home.homeDirectory = "/home/yabai";
  home.stateVersion = "24.11";

  home.sessionVariables = {
    TZ = "Asia/Kolkata";
  };

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  systemd.user.services.portless-alias-search = {
    Unit = {
      Description = "Register omnisearch alias with portless";
    };
    Service = {
      Type = "oneshot";
      ExecStartPre = "/bin/sh -c 'sleep 5'";
      ExecStart = "${config.home.homeDirectory}/.bun/bin/portless alias search 8087";
      RemainAfterExit = true;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  xdg.configFile."omnisearch" = {
    source = ./configs/omnisearch;
    recursive = true;
  };

  home.file.".config/systemd-system/portless-proxy.service".text = let
    home = config.home.homeDirectory;
    portless = "${home}/.bun/bin/portless";
  in ''
    [Unit]
    Description=Portless proxy (port 443)
    After=network.target

    [Service]
    ExecStart=${portless} proxy start --foreground --https -p 443
    ExecStartPost=/bin/sh -c 'sleep 3 && HOME=${home} PORTLESS_STATE_DIR=${home}/.portless ${portless} alias search 8087'
    Restart=on-failure
    RestartSec=3
    Environment=HOME=${home}
    Environment=PATH=${home}/.bun/bin:/usr/bin:/bin
    Environment=PORTLESS_STATE_DIR=${home}/.portless

    [Install]
    WantedBy=multi-user.target
  '';

  home.file.".config/systemd-system/install.sh" = {
    executable = true;
    text = ''
      #!/bin/sh
      set -e
      OMNISEARCH_SRC="$HOME/.config/omnisearch"
      OMNISEARCH_DST="/etc/omnisearch"

      # Copy omnisearch config, templates, and static files
      # (copy instead of symlink — omnisearch user can't traverse $HOME)
      echo "Syncing omnisearch configuration..."
      sudo mkdir -p "$OMNISEARCH_DST/templates" "$OMNISEARCH_DST/static"
      # Remove old symlinks first to avoid "same file" errors
      sudo find "$OMNISEARCH_DST" -maxdepth 2 -type l -delete
      sudo cp -L "$OMNISEARCH_SRC/config.ini" "$OMNISEARCH_DST/config.ini"
      sudo cp -L "$OMNISEARCH_SRC"/templates/* "$OMNISEARCH_DST/templates/"
      sudo cp -L "$OMNISEARCH_SRC"/static/* "$OMNISEARCH_DST/static/"
      sudo chown -R omnisearch:omnisearch "$OMNISEARCH_DST"
      sudo systemctl restart omnisearch
      echo "Omnisearch configuration synced."

      # Install portless-proxy system service
      SERVICE_SRC="$HOME/.config/systemd-system/portless-proxy.service"
      SERVICE_DST="/etc/systemd/system/portless-proxy.service"

      if [ ! -L "$SERVICE_DST" ] || [ "$(readlink -f "$SERVICE_DST")" != "$SERVICE_SRC" ]; then
        echo "Installing portless-proxy system service..."
        sudo ln -sf "$SERVICE_SRC" "$SERVICE_DST"
        sudo systemctl daemon-reload
        sudo systemctl enable --now portless-proxy
        echo "Done."
      else
        echo "portless-proxy service already installed."
      fi
    '';
  };

  home.activation.portlessReminder = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if [ ! -L /etc/systemd/system/portless-proxy.service ] || [ ! -L /etc/omnisearch/config.ini ]; then
      echo ""
      echo "┌───────────────────────────────────────────────────────┐"
      echo "│  Run: ~/.config/systemd-system/install.sh             │"
      echo "│  to sync omnisearch config & enable portless proxy    │"
      echo "└───────────────────────────────────────────────────────┘"
      echo ""
    fi
  '';

  home.packages = with pkgs; [
    niri
    fd
    bat
    eza
    helix
    zellij
    nushell
    btop
    hyprlock
    less
    rofi-wayland
    libsForQt5.qtstyleplugin-kvantum
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  fonts.fontconfig.enable = true;

  xdg.configFile."hypr".source = ./configs/hypr;
  xdg.configFile."zellij".source = ./configs/zellij;
  xdg.configFile."helix".source = ./configs/helix;
  xdg.configFile."ghostty".source = ./configs/ghostty;
  xdg.configFile."waybar".source = ./configs/waybar;
  xdg.configFile."nushell" = {
    source = ./configs/nushell;
    recursive = true;
  };
  xdg.configFile."rofi" = {
    source = ./configs/rofi;
    recursive = true;
  };

  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=KvArcDark
  '';

  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    style=kvantum
    color_scheme=default
    icon_theme=Adwaita
  '';

  dconf.settings = {
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "";
    };
    "org/gnome/nautilus/window-state" = {
      start-with-sidebar = true;
      initial-size = "(890, 550)";
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = false;
      sidebar-width = 200;
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Dracula";
    };
    gtk3.extraCss = ''
      window, .background {
        background: transparent;
      }
      headerbar {
        background: transparent;
        box-shadow: none;
        border: none;
      }
    '';
    gtk4.extraCss = ''
      /* Main background colors */
      @define-color bg_color rgba(30, 30, 46, 0.5);
      @define-color base_color rgba(30, 30, 46, 0.5);
      @define-color backdrop_bg_color rgba(30, 30, 46, 0.75);
      @define-color backdrop_base_color rgba(30, 30, 46, 0.75);
      @define-color view_bg_color rgba(30, 30, 46, 0.5);
      @define-color window_bg_color transparent;
      @define-color headerbar_bg_color transparent;
      @define-color content_view_bg rgba(30, 30, 46, 0.5);

      /* Sidebar colors */
      @define-color sidebar_bg_color rgba(30, 30, 46, 0.9);
      @define-color sidebar_backdrop_color rgba(30, 30, 46, 0.85);

      /* Base styles */
      window,
      .background,
      .background:backdrop {
        background-color: transparent;
      }

      headerbar {
        background-color: transparent;
        box-shadow: none;
        border: none;
      }

      .view,
      .view:backdrop,
      iconview,
      gridview,
      .content-view,
      .content-view:backdrop {
        background-color: rgba(30, 30, 46, 0.5);
      }

      scrolledwindow,
      scrolledwindow > viewport,
      viewport {
        background-color: transparent;
      }

      /* Empty folder status page */
      statuspage,
      statuspage > scrolledwindow,
      statuspage > scrolledwindow > viewport,
      statuspage > scrolledwindow > viewport > box {
        background-color: rgba(30, 30, 46, 0.5);
      }

      /* Nautilus specific */
      .nautilus-window notebook,
      .nautilus-window notebook > stack,
      .nautilus-window notebook > stack:backdrop {
        background-color: transparent;
      }

      .nautilus-window .sidebar {
        background-color: @sidebar_bg_color;
        background-image: none;
      }
      .nautilus-window .sidebar:backdrop {
        background-color: @sidebar_backdrop_color;
        background-image: none;
      }
    '';
  };
}
