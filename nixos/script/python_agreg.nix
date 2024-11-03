let
  pkgs = import <nixpkgs> { };
in
pkgs.mkShell {
  packages = [
    (pkgs.python3.withPackages (python-pkgs: [
      python-pkgs.matplotlib
      pkgs.python312Packages.networkx
      pkgs.python311Packages.networkx
    ]))
  ];
}
