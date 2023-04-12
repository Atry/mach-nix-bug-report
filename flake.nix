{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
    flake-utils.url = "github:numtide/flake-utils";
    pypi-deps-db = {
      url = "github:DavHau/pypi-deps-db";
      inputs.mach-nix.follows = "mach-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mach-nix = {
      url = "github:DavHau/mach-nix";
      inputs.pypi-deps-db.follows = "pypi-deps-db";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    { self, nixpkgs, flake-utils, mach-nix, ... }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
    ]
      (
        system:
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        rec {

          # No error
          packages.pythonEnvWithGradio = mach-nix.lib.${system}.mkPython {
            requirements = ''
              gradio
            '';
          };

          # No error
          packages.pythonEnvWithRich = mach-nix.lib.${system}.mkPython {
            requirements = ''
              rich
            '';
          };

          # ERROR: Could not find a version that satisfies the requirement linkify-it-py<3,>=1; extra == "linkify" (from markdown-it-py[linkify]) (from versions: none)
          # ERROR: No matching distribution found for linkify-it-py<3,>=1; extra == "linkify"
          packages.pythonEnvWithGradioAndRich = mach-nix.lib.${system}.mkPython {
            requirements = ''
              gradio
              rich
            '';
          };

          # No error
          packages.pythonEnvWithGradioAndRichWorkaround = mach-nix.lib.${system}.mkPython {
            requirements = ''
              gradio
              rich
            '';
            providers.markdown-it-py = "sdist";
          };
        }
      );
}
