{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    poetry_2_nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self
    , nixpkgs
    , poetry_2_nix
  }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };

    poetry2nix = poetry_2_nix.legacyPackages.${system};

    pytest-harvest =
      let
        pkg = pkgs.callPackage ./pytest-harvest.nix {
          inherit poetry2nix;
          setuptools-scm = pkgs.python310.pkgs.setuptools-scm;
        };
      in pkg;
  in {
    packages.${system} = { inherit pytest-harvest; };
  };
}

