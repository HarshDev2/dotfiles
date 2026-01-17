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
  ];

  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "nu";
    };
  };

  xdg.configFile."hypr".source = ./configs/hypr;
  xdg.configFile."helix".source = ./configs/helix;
  xdg.configFile."ghostty".source = ./configs/ghostty;
  xdg.configFile."nushell" = {
    source = ./configs/nushell;
    recursive = true;
  };
}
