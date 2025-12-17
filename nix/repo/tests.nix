{inputs, ...}: let
  inherit (inputs) pkgs ntlib doclib;
in {
  tests = ntlib.mkNixtest {
    modules = ntlib.autodiscover {dir = "${inputs.self}/tests";};
    args = {
      inherit pkgs ntlib doclib;
    };
  };
}
