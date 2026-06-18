{
  description = "mirante — Rust-native terminal UI for observing and navigating Kubernetes clusters";

  inputs = {
    # Track main; flake.lock pins. Do NOT rev-pin internal pleme-io input
    # URLs (substrate/CLAUDE.md ★★ no-rev-pin rule) — that blocks fleet-wide
    # substrate fixes from propagating via `nix flake update`.
    nixpkgs.url     = "github:nixos/nixpkgs?ref=nixos-25.11";
    crate2nix.url   = "github:nix-community/crate2nix";
    flake-utils.url = "github:numtide/flake-utils";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    substrate = {
      url = "github:pleme-io/substrate";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.fenix.follows   = "fenix";
    };
  };

  outputs = { self, nixpkgs, crate2nix, flake-utils, substrate, fenix, ... }:
    (import "${substrate}/lib/rust-workspace-release-flake.nix" {
      inherit nixpkgs crate2nix flake-utils fenix;
    }) {
      toolName    = "mirante";          # installed binary name + packages.<sys>.<toolName>
      packageName = "mirante";          # root workspace package that owns the [[bin]]
      src         = self;
      repo        = "pleme-io/mirante";
      # HM/NixOS/Darwin module trio is auto-emitted by the substrate flake
      # (imports = [ mirante.homeManagerModules.default ]; programs.mirante.enable = true;).
      module = {
        description      = "mirante — Kubernetes cluster TUI";
        withMcp          = false;
        withHttp         = false;
        withSystemDaemon = false;
      };
    };
}
