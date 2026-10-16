{
  flake.modules.nixos.ssh.programs.ssh = {
    startAgent = true;
    extraConfig = "AddKeysToAgent yes";
    knownHosts = {
      nas = {
        hostNames = [ "nas" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2UYM1qDrRKft+G6VBhxMeyrmw3vskRFUj5F+l88c1O";
      };
      server = {
        hostNames = [
          "server"
          "100.125.41.118"
        ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICBHjLsTqAyKteTSPF+Ws5noHMTGfIdOdz4f4OI4jq+s";
      };
      github = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
  };
}
