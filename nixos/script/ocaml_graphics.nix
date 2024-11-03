let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  packages = [
    pkgs.ocamlPackages.graphics
    pkgs.ocamlPackages.utop
    pkgs.ocamlPackages.findlib
  ];
}
