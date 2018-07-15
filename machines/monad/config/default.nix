pkgs: rec {
  hostId = "d7ee0243"; # needed for zfs
  ztip = "172.24.172.226";
  nix-serve = {
    port = 10845;
    bindAddress = ztip;
  };
  sessionCommands = ''
  '';
}
