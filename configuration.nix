# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
	imports =
	[ 	# Include the results of the hardware scan.
                ./hardware-configuration.nix
                ./distraction-free.nix
	];

	# Boot
	boot.loader.systemd-boot.enable = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# Networking
	networking.hostName = "tower";
	networking.networkmanager.enable = true;

	# Locale
	console.keyMap = "us";
	time.timeZone = "Europe/Zurich";
	i18n.defaultLocale = "en_US.UTF-8";

	# GTX 1070 Ti
	hardware.graphics.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];
	hardware.nvidia = {
		open = false;
		modesetting.enable = true;
		package = config.boot.kernelPackages.nvidiaPackages.legacy_580;
	};

	# X11
	services.xserver = {
		enable = true;
		xkb.layout = "us";	
		windowManager.xmonad = {
			enable = true;
			enableContribAndExtras = true;
		};
	};

	services.displayManager.defaultSession = "none+xmonad";


	# User
	users.users.ziad = {
		isNormalUser = true;
		extraGroups = [ "wheel" "networkmanager" ];	
	};

	environment.systemPackages = with pkgs; [
		alacritty dmenu feh alsa-utils xset xsetroot xrandr xprop
                maim xclip xdotool flameshot libnotify
		keepassxc ranger ueberzug zathura poppler-utils
		git vim-full
	];

	# VMWare
	virtualisation.vmware.host.enable = true;
	boot.kernelParams = [ "transparent_hugepage=never" ];

	# Audio
	services.pipewire.enable = true;
	services.pipewire.alsa.enable = true;

	# LibInput
	services.libinput.mouse.leftHanded = true;
	
	# Nix-Specific
	nixpkgs.config.allowUnfree = true;

	# This option defines the first version of NixOS you have installed on this particular machine,
	# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
	#
	# Most users should NEVER change this value after the initial install, for any reason,
	# even if you've upgraded your system to a new NixOS release.
	#
	# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
	# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
	# to actually do that.
	#
	# This value being lower than the current NixOS release does NOT mean your system is
	# out of date, out of support, or vulnerable.
	#
	# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
	# and migrated your data accordingly.
	#
	# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
	system.stateVersion = "26.05"; # Did you read the comment?
}

