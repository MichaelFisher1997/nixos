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

  services.pipewire.wireplumber.extraConfig."99-bluetooth" = {
    # Keep playback in A2DP when applications request a microphone.
    "wireplumber.settings"."bluetooth.autoswitch-to-headset-profile" = false;
    "monitor.bluez.rules" = [
      {
        matches = [ { "device.name" = "~bluez_card.*"; } ];
        actions.update-props."bluez5.auto-connect" = [ "a2dp_sink" ];
      }
      {
        matches = [
          { "node.name" = "~bluez_input.*"; }
          { "node.name" = "~bluez_output.*"; }
        ];
        actions.update-props."session.suspend-timeout-seconds" = 0;
      }
    ];
  };
}
