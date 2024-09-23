{ username }:
{ nixosSystem, ... }:
nixosSystem.extendModules {
  modules = [
    (
      { config, pkgs, ... }:
      {
        virtualisation.libvirtd.enable = true;
        virtualisation.vmVariant = {
          virtualisation = {
            memorySize = 8192;
            cores = 4;
            diskSize = 20480;
            qemu = {
              options = [
                "-device virtio-vga-gl"
                "-display gtk,gl=on"
              ];
            };
          };
          services.xserver = {
            displayManager.autoLogin = {
              enable = true;
              user = username;
            };
            videoDrivers = [ "virtio" ];
          };
        };
        environment.systemPackages = with pkgs; [
          open-vm-tools
          spice-vdagent
        ];
        services.qemuGuest.enable = true;
        services.spice-vdagentd = {
          enable = true;
        };
      }
    )
  ];
}
