{
  description = "A very basic flake, really";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = inputs@{ self, nixpkgs }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      ashPC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/ashPC/ashPC.nix
          ./hosts/ashPC/hardware-configuration.nix
        ];
      };

      sash = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/sash/sash.nix
          ./hosts/sash/hardware-configuration.nix
        ];
      };
    };

    apps.${system} = {
      mount-ashShare = {
        type = "app";
        program = "${pkgs.writeShellScript "mount-ashShare" ''
          set -euo pipefail

          MOUNT_POINT="/mnt/ashShare"
          SERVER="192.168.0.181:/srv/nfs/ashShare"

          if mountpoint -q "$MOUNT_POINT"; then
            echo "ashShare already mounted"
            exit 0
          fi

          sudo mount -t nfs -o \
            nfsvers=4,rw,noatime,hard,intr \
            "$SERVER" "$MOUNT_POINT"

          echo "ashShare mounted"
        ''}";
      };

      umount-ashShare = {
        type = "app";
        program = "${pkgs.writeShellScript "umount-ashShare" ''
          set -euo pipefail

          MOUNT_POINT="/mnt/ashShare"

          if ! mountpoint -q "$MOUNT_POINT"; then
            echo "ashShare not mounted"
            exit 0
          fi

          sudo umount "$MOUNT_POINT"
          echo "ashShare unmounted"
        ''}";
      };
    };
  };
}

