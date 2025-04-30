{
  description = "Flake for X-Plane 12 on NixOS";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable"; };

  outputs = { self, nixpkgs, }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      x-plane-12 = pkgs.stdenv.mkDerivation {
        pname = "X-Plane-12";
        version = "1";

        src = pkgs.fetchzip {
          url =
            "https://lookup.x-plane.com/_lookup_12_/download/X-Plane12InstallerLinux.zip";
          sha256 = "sha256-ltP/sbXNEiKJzHF6OA1oyK7OqhtL2epH8CikOOJt/bs=";
        };

        installPhase = ''
                    mkdir -p $out/bin
                    install -m755 -D "X-Plane 12 Installer Linux" $out/bin/x-plane-12-installer
          					echo "export GIO_MODULE_DIR=${pkgs.glib-networking}/lib/gio/modules/" > $out/bin/start.sh
          					echo "~/X-Plane\\ 12/X-Plane-x86_64" >> $out/bin/start.sh
          					chmod +x $out/bin/start.sh
        '';
      };
      fhs = pkgs.buildFHSEnv {
        name = "X-Plane-12";
        targetPkgs = pkgs:
          with pkgs; [
            x-plane-12
            libGL
            libGLU
            xorg.libX11
            xorg.libXcursor
            xorg.libXrandr
            xorg.libXext
            xorg.libXinerama
            xorg.libXcomposite
            xorg.libXdamage
            xorg.libXfixes
            xorg.libSM
            xorg.libICE
            xorg.libxcb
            xorg.xcbutil
            xorg.xcbutilwm
            xorg.xcbutilimage
            xorg.xcbutilkeysyms
            xorg.xcbutilrenderutil
            xorg.fontutil
            xorg.fontalias
            libxkbcommon
            libgbm
            expat
            alsa-lib
            libz
            curl
            vulkan-tools
            vulkan-loader
            vulkan-helper
            vulkan-headers
            vulkan-utility-libraries
            nss
            libdrm
            cups
            nspr
            glib
            at-spi2-atk
            gdk-pixbuf
            aileron
            liberation_ttf
            cairo
            xdg-user-dirs
            pango
            gtk3
            harfbuzz
            dbus
            webkitgtk_4_1
            libressl
            openssl
            glib-networking
            fuse
            pulseaudio
            freetype
            fontconfig
            xcb-util-cursor
          ];
      };
    in {
      devShells.${system}.default = fhs.env;
      packages.${system} = { default = fhs; };
    };
}
