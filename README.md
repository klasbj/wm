This is my personal WM start scripts, which deals with starting dwm,
statusbars, and scripts to populate the status bars with data. Some things are
probably not that useful to anyone else, but most of it might be!

```
pkgbuilds/
  Contains PKGBUILD files for the dependencies which use my own forks.

dmenu/
dwm/
  My forks of the projects, with various fixes that depend on each other.

pysb/
  My pysb project (https://github.com/klasbj/pysb)

statusbars/
  My statusbar management scripts. statusbars/conf.d/ contains the scripts
  which generate data for the statusbars. The files are source in a bash
  function, and can thus use regular bash syntax. The file should set some
  variables which are used to start the data generation.
    Exec      - Bash array containing the command to run
    Type      - Continuous (process runs continuously) or
                Periodical (should be started periodically)
    Period    - The period of the Periodical command. Any format which bash's
                sleep accepts will work.
    Area      - The name of the commands area.
    Screen    - Which screen to display it on.
    Bar       - BOTTOM or TOP.
    Weight    - Weight for floating position.
    Float     - Float direction: LEFT, LEFT_HL, RIGHT, RIGHT_HL, CENTER_L
                or CENTER_R.
  The scripts which are in the conf.d and scripts directory are likely using
  bits which are specific to my machine, so some things will likely have to be
  modified to work properly on another machine. E.g. network interface name.
```

Build and Use
-------------

Build and install the dependencies in pkgbuilds/ with makepkg.

Run `make` to build dwm.

Then call `exec [path-to-here]/init.sh` in your `.xinitrc` file to start everything.


Dependencies
------------

* dmenu via the included PKGBUILDs.
* ttf-dejavu
* terminus-font
* python-pyqt5 for pysb

The statusbar scripts use:
* conky with a .conkyrc which sets:
      out_to_console yes
      out_to_stderr no
      out_to_x no
* acpi
* netctl
* wireless\_tools
* wpa\_supplicant
* alsa-utils
* pulseaudio
* pulseaudio-alsa
* inotify-tools
* nmap
* python-requests

Optional:
* compton - for compositing, expects a compton.conf in
            $XDG_CONFIG_HOME/compton/compton.conf (defaults to ~/.config/...
            in case $XDG_CONFIG_HOME is not set.)
            I recommend using compton-git from the AUR:
            https://aur.archlinux.org/packages/compton-git/

* ...and likely more stuff I have forgotten!
