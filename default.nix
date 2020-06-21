# Derivations for the tooling used in CS 2110 at Georgia Tech.
# Most of the tooling was made by Brandon, so dependencies are mainly fetched
# from his GitHub or from his PPA at
# http://ppa.launchpad.net/tricksterguy87/ppa-gt-cs2110/ubuntu/

{ pkgs ? let nixpkgs = import ./nixpkgs.nix; in import nixpkgs {}
}:

rec {
  # The cs2110 docker image itself
  docker-image = pkgs.callPackage ./docker-image.nix {};

  # Wrapper script to manage the cs2110 docker image
  # Override enableDockerMachine to true if you're using docker-machine with a
  # non-localhost default IP
  cs2110docker = pkgs.callPackage ./cs2110docker.nix {
    inherit docker-image;
  };

  # CS2110-compliant version of CircuitSim
  CircuitSim = pkgs.callPackage ./circuitsim.nix {};

  # Complx, for LC-3
  complx-tools = pkgs.callPackage ./complx-tools.nix {};

  # Tools used for building GBA games
  cs2110-gba-linker-script = pkgs.callPackage ./cs2110-gba-linker-script.nix {};
  # vba-m, the old emulator
  cs2110-vbam-sdl = pkgs.callPackage ./cs2110-vbam-sdl.nix {};
  # nin10kit, utilities for making GBA games
  nin10kit = pkgs.callPackage ./nin10kit.nix {};

  # Function to make building GBA games with nix easier when using the CS2110
  # setup
  makeGBA = pkgs.callPackage ./makeGBA.nix {
    inherit cs2110-vbam-sdl cs2110-gba-linker-script nin10kit;
  };
}

