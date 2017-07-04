{ pkgs }:
{
  writeBash = fname: body: pkgs.writeScript fname ''
    #! ${pkgs.bash}/bin/bash
    ${body}
  '';
}
