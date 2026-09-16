{
  description = "Basic Hora Pico Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = {nixpkgs, ...}: let
    # System types to support.
    supportedSystems = ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];

    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    nixpkgsFor = forAllSystems (system:
      import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          android_sdk.accept_license = true;
        };
      });
  in {
    devShells = forAllSystems (system: let
      pkgs = nixpkgsFor.${system};
      # Android SDK
      androidSDK = pkgs.androidenv.composeAndroidPackages {
        platformVersions = ["35"];
        buildToolsVersions = ["35.0.1"];
        cmdLineToolsVersion = "latest";

        includeCmake = true;
        cmakeVersions = ["latest"];
        includeNDK = true;
        ndkVersions = ["latest"];

        # Don't download any images or ABI versions
        includeEmulator = false;
        includeSystemImages = false;
        abiVersions = [];
      };
    in {
      default = pkgs.mkShell {
        packages = [
          pkgs.godot
        ];

        # Android setup
        buildInputs = [androidSDK.androidsdk pkgs.jdk17];
        JAVA_HOME = "${pkgs.jdk17.home}";
        ANDROID_HOME = "${pkgs.androidsdk}/libexec/android-sdk";
        ANDROID_SDK_ROOT = "${pkgs.androidsdk}/libexec/android-sdk";
      };
    });
  };
}
