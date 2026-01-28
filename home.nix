{ config, pkgs, ... }:

{
  home.username = "idk24";
  home.homeDirectory = "/home/idk24";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

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
    waybar
    libsForQt5.qtstyleplugin-kvantum
    kdePackages.qtstyleplugin-kvantum
  ];

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

  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
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
