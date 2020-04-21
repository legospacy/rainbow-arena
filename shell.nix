{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    love_11
    luajitPackages.moonscript
    gnumake
  ];
}
