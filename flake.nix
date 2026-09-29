{
  description = "Thin Nix packaging repo for the toolflow-mcp server";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://rogernavelsaker.cachix.org"
      "https://nacosolutions.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "rogernavelsaker.cachix.org-1:n1DtzMNhA9Rz4Kg3xlXOi/KceULu8VrMbs9WXyMFQNQ="
      "nacosolutions.cachix.org-1:JzCiW2CLcuLXtwOVAg3SlSK/kpqWbfSFEVenyKVUlug="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    bun2nix.url = "github:nix-community/bun2nix?tag=2.0.8";
    bun2nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, bun2nix, ... }:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ bun2nix.overlays.default ];
        };
      });
    in {
      packages = forAllSystems ({ pkgs }: {
        default = (pkgs.callPackage ./nix/package.nix { }).out;
        tf = (pkgs.callPackage ./nix/package.nix { }).tf;
      });

      apps = forAllSystems ({ pkgs }: {
        default = {
          type = "app";
          program = "${(pkgs.callPackage ./nix/package.nix { }).out}/bin/toolflow";
        };
        tf = {
          type = "app";
          program = "${(pkgs.callPackage ./nix/package.nix { }).tf}/bin/tf";
        };
      });

      devShells = forAllSystems ({ pkgs }: {
        default = pkgs.mkShell {
          packages = with pkgs; [
            bun
            bun2nix
            jq
            nixfmt-rfc-style
          ];
        };
      });
    };
}
