{ pkgs, ... }:
{
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 256;
        default.clock.min-quantum = 256;
        default.clock.max-quantum = 1024;
      };
    };
  };

  services.pipewire.wireplumber.configPackages = with pkgs; [
    (writeTextDir "wireplumber/wireplumber.conf.d/60-no-suspend.conf" ''
      monitor.alsa.rules = [
        {
          matches = [
            { node.name = "~alsa_input.*" }
            { node.name = "~alsa_output.*" }
            { node.name = "~bluez_*" }
          ]
          actions = {
            update-props = {
              session.suspend-timeout-seconds = 0
            }
          }
        }
      ]
    '')
  ];

  environment.etc."wireplumber/bluetooth.lua.d/99-force-a2dp.lua" = {
    text = ''
      rule = {
        matches = {
          {
            { "device.name", "matches", "bluez_card.*" },
          },
        },
        apply_properties = {
          ["bluez5.auto-connect"] = "[ a2dp_sink ]",
          ["bluez5.auto-switch-profile"] = false,
          ["bluez5.disable-headset-profile"] = true,
        }
      }
      table.insert(bluez_monitor.rules, rule)
    '';
  };
}