{ config, pkgs, ... }:

let
  nur = import <nur> { inherit pkgs; };
in
{
  home.username = "idk24";
  home.homeDirectory = "/home/idk24";
  home.stateVersion = "24.11";

  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;
  programs.vscode.enable = true;

  programs.firefox = {
    enable = true;
    profiles.default = {
      isDefault = true;
      settings = {
        "privacy.trackingprotection.enabled" = true;
        "browser.newtabpage.enabled" = false;
        "browser.startup.homepage" = "https://search.localhost";
        "browser.startup.page" = 1;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "layout.css.prefers-color-scheme.content-override" = 0;
        "browser.toolbars.bookmarks.visibility" = "never";
        "identity.fxaccounts.enabled" = false;
        "browser.aboutwelcome.enabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "extensions.pocket.enabled" = false;
        "browser.urlbar.clickSelectsAll" = true;

        # Privacy hardening
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "network.prefetch-next" = true;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "network.http.speculative-parallel-limit" = 6;
        "network.captive-portal-service.enabled" = false;
        "network.connectivity-service.enabled" = false;
        "dom.security.https_only_mode" = true;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "breakpad.reportURL" = "";
        "browser.tabs.crashReporting.sendReport" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "geo.enabled" = false;
        "permissions.default.geo" = 2;
        "media.navigator.enabled" = false;
        "webgl.disabled" = true;
        "privacy.resistFingerprinting" = false;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "browser.send_pings" = false;
        "beacon.enabled" = false;
        "dom.battery.enabled" = false;
        "browser.urlbar.speculativeConnect.enabled" = false;
        "browser.formfill.enable" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "browser.contentblocking.category" = "strict";
        "network.cookie.cookieBehavior" = 5;
        "privacy.partition.network_state.ocsp_cache" = true;
      };
      userChrome = ''
        /* Hide tab bar */
        #TabsToolbar {
          visibility: collapse !important;
        }
        /* Hide titlebar spacers */
        .titlebar-spacer {
          display: none !important;
        }
        /* Hide sidebar header */
        #sidebar-header {
          display: none !important;
        }
        /* Tokyo Night dark theme */
        :root {
          --toolbar-bgcolor: #1a1b26 !important;
          --toolbar-color: #cdd6f4 !important;
          --toolbar-field-background-color: #24283b !important;
          --toolbar-field-color: #cdd6f4 !important;
          --toolbar-field-border-color: #45475a !important;
          --toolbar-field-focus-background-color: #24283b !important;
          --toolbar-field-focus-color: #cdd6f4 !important;
          --toolbar-field-focus-border-color: #89b4fa !important;
          --lwt-accent-color: #1a1b26 !important;
          --lwt-text-color: #cdd6f4 !important;
          --arrowpanel-background: #1a1b26 !important;
          --arrowpanel-color: #cdd6f4 !important;
          --arrowpanel-border-color: #45475a !important;
          --urlbar-box-bgcolor: #24283b !important;
          --urlbar-box-hover-bgcolor: #292e42 !important;
          --urlbar-box-active-bgcolor: #292e42 !important;
          --sidebar-background-color: #1a1b26 !important;
          --sidebar-text-color: #cdd6f4 !important;
          --sidebar-border-color: #45475a !important;
        }
        #navigator-toolbox {
          background: #1a1b26 !important;
          border-bottom: 1px solid #45475a !important;
        }
        #nav-bar {
          background: #1a1b26 !important;
        }
        #urlbar-background {
          background: #24283b !important;
          border: 1px solid #45475a !important;
        }
        #urlbar[focused] #urlbar-background {
          border-color: #89b4fa !important;
          box-shadow: 0 0 0 2px rgba(137, 180, 250, 0.15) !important;
        }
        #PersonalToolbar {
          background: #1a1b26 !important;
        }
        /* Menu popups */
        menupopup, panel, .panel-arrowcontent {
          background: #1a1b26 !important;
          color: #cdd6f4 !important;
          border-color: #45475a !important;
        }
        #appMenu-popup {
          background: #1a1b26 !important;
        }
        toolbarbutton, .toolbarbutton-icon {
          color: #cdd6f4 !important;
        }
      '';
      extensions.packages = with nur.repos.rycee.firefox-addons; [
        sidebery
        ublock-origin
        new-tab-override
        darkreader
      ];
      search = {
        default = "OmniSearch";
        engines = {
          "OmniSearch" = {
            urls = [{ template = "https://search.localhost/search?q={searchTerms}"; }];
            definedAliases = [ "@o" ];
          };
        };
        force = true;
      };
    };
  };

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
