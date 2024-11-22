{ modulesPath, lib, pkgs, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = false;
  };

  networking.firewall.allowedTCPPorts = [ 6443 2379 2380 5001 10250 ];
  networking.firewall.allowedUDPPorts = [ 8472 51820 51821 ];

  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  environment.systemPackages = map lib.lowPrio [ pkgs.curl pkgs.gitMinimal ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBc0shyBJNxba3uD0zZHG0aLIUR0CIx/Tef5dmHcefsE"
  ];

  system.stateVersion = "24.05";
}
