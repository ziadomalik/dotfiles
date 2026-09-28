{ config, pkgs, lib, ... }:

let
  companionKey = "eiph6oow5EiNgao5";
in
  {
    services.invidious = {
      enable = true;
      port = 3000;
      address = "127.0.0.1";
      database.createLocally = true; 
      settings = {
        invidious_companion = [
          { private_url = "http://127.0.0.1:8282/companion"; }
        ];
        invidious_companion_key = companionKey;

        default_user_preferences = {
          autoplay = false;
          continue = false;
          related_videos = false;   
          comments = [ "" "" ];     
          feed_menu = [ ];
        };
        popular_enabled = false;    
      };
    };

    virtualisation.oci-containers = {
      backend = "podman";
      containers.invidious-companion = {
        image = "quay.io/invidious/invidious-companion:latest";
        ports = [ "127.0.0.1:8282:8282" ];
        environment.SERVER_SECRET_KEY = companionKey;
        volumes = [ "invidious-companion-cache:/var/tmp/youtubei.js:rw" ];
      };
    };

  programs.firefox = {
    enable = true;
    policies = {
      ExtensionSettings = {
        "7esoorv3@alefvanoon.anonaddy.me" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/libredirect/latest.xpi";
        };
        "uBlock0@raymondhill.net" = {
          installation_mode = "force_installed";
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
        };
      };

      SearchEngines = {
        Default = "DuckDuckGo";
        Remove = [ "Google" "Bing" ];
      };

      WebsiteFilter.Block = [
        "*://*.twitter.com/*"
        "*://*.x.com/*"
        "*://*.instagram.com/*"
        "*://*.facebook.com/*"
        "*://*.tiktok.com/*"
        "*://*.twitch.tv/*"
      ];

      DisableFirefoxStudies = true;
      DisableTelemetry = true;
      DisablePocket = true;
    };
  };
}
