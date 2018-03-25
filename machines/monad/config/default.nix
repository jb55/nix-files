pkgs: rec {
  ztip = "172.24.172.226";
  nix-serve = {
    port = 10845;
    bindAddress = ztip;
  };
  sessionCommands = ''
  '';
}
