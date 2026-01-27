{ config, pkgs, ... }:

{
  home.username = "idk24";
  home.homeDirectory = "/home/idk24";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
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
}
