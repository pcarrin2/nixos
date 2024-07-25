{ config, lib, pkgs, ... }:
{
  services.borgbackup = {
    jobs = {

      home_dir_backup = {
        paths = ["/home/theta"];
	repo = "de3570@de3570.rsync.net:home";
	encryption = {
          mode = "repokey-blake2";
	  passCommand = "cat /home/theta/.config/borg_passphrase";
        };
	user = "theta";
	compression = "auto,lzma";
	startAt = "daily";
	prune.keep = {
          daily = 7;
	  weekly = 4;
	  monthly = -1;
        };
	preHook = ''
	  # workaround for https://github.com/NixOS/nixpkgs/issues/323262
	  extraArgs="--remote-path=borg1"
	'';
	inhibitsSleep = true;
      };

    };

  };

}