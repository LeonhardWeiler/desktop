{
  flake.modules.nixos.ssh.programs.ssh.knownHosts = {
    nas = {
      hostNames = [ "100.65.0.90" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII2UYM1qDrRKft+G6VBhxMeyrmw3vskRFUj5F+l88c1O";
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
}
