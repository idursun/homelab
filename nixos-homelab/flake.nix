{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.nixos-generators.url = "github:reinthal/nixos-generators";
  inputs.nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { nixpkgs, disko, nixos-generators, ... }: {

    packages.x86_64-linux = {
      proxmox = nixos-generators.nixosGenerate {
        system = "x86_64-linux";
        specialArgs = { diskSize = 30480; };
        modules =
          [ ({ ... }: { nix.registry.nixpkgs.flake = nixpkgs; }) ./server.nix ];
        format = "proxmox";
      };
    };

    nixosConfigurations.k3s-server = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        ./hardware-configuration.nix
        ({ ... }: {
          networking.hostName = "k3s-server";
          services.k3s = {
            enable = true;
            role = "server";
            token = builtins.readFile ./k3s-token;
            clusterInit = true;
          };
        })
      ];
    };

    nixosConfigurations.k3s-agent = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./configuration.nix
        ./hardware-configuration.nix
        ({ ... }: {
          networking.hostName = "k3s-agent-1";
          services.k3s = {
            enable = true;
            role = "agent";
            token = builtins.readFile ./k3s-token;
            serverAddr = "https://192.168.0.105:6443";
          };
        })
      ];
    };
  };
}
