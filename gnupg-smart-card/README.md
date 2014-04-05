#GnuPG Smart Card Instructions

If you have a gemalto card, install `libccid` library beforehand.

Run `udev.sh` to get the `gnupg-ccid.rules` into `etc/udev`.  There will be additional tweaks required.

Or do it all manually. See this page for more instructions: http://www.gnupg.org/howtos/card-howto/en/ch02s03.html
