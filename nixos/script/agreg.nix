let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  packages = with pkgs; [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.numpy
      python-pkgs.matplotlib
      python-pkgs.networkx
      python-pkgs.mypy
    ]))

    zeal

    gnuplot
    gdb
    sqlite
    vscodium

    pkgs.ocamlPackages.graphics
    pkgs.ocamlPackages.utop
    pkgs.ocamlPackages.ocamlbuild
    pkgs.ocamlPackages.findlib
  ];
}
