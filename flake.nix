{
  description = "NixOS + Hyprland + tema Solitude (Surface Pro 7, home-manager standalone)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }:
    let
      # Cambia questi due valori prima del primo build.
      username = "utente";
      hostname = "surface";

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      palette = import ./theme/palette.nix;
    in {
      # Sistema:  sudo nixos-rebuild switch --flake .#surface
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit username hostname; };
        modules = [ ./hosts/surface/configuration.nix ];
      };

      # Utente:   home-manager switch --flake .#utente
      homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit username palette; };
        modules = [ ./home.nix ];
      };
    };
}
