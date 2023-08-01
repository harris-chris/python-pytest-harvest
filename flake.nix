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

    getPytestHarvest = pkgs:
      pkgs.callPackage ./pytest-harvest.nix {
          inherit poetry2nix;
          setuptools-scm = pkgs.python310.pkgs.setuptools-scm;
        };
  in {
    packages.${system} =
      let pytest-harvest = getPytestHarvest pkgs;
      in { inherit pytest-harvest; };
    overlays.default = final: prev:
      let pytest-harvest = getPytestHarvest prev;
      in { inherit pytest-harvest; };
  };
}

