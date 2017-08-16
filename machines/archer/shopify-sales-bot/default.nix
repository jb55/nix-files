extra:
{ config, lib, pkgs, ... }:
let cfg = extra.private;
    util = extra.util;
    import-scripts = extra.import-scripts;
in
{
  systemd.user.services.shopify-sales-bot = {
    description = "shopify sales bot";

    environment = {
      SHOPIFY_USER = extra.private.shopify-user;
      SHOPIFY_PASS = extra.private.shopify-pass;
    };

    serviceConfig.ExecStart = "${import-scripts}/bin/shopify-sales-bot";
    unitConfig.OnFailure = "notify-failed-user@%n.service";

    # 20th is always before the earliest possible last wednesday (22nd)
    startAt = "*-*-20 8:30:00";
  };
}
