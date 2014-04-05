#!/bin/sh

#    This file was created to perform the steps described in the 
#    "Setting up your card reader on GNU/Linux (udev)"-HOWTO at 
#    http://wiki.fsfe.org/Card_howtos/Card_reader_setup_(udev)
#
#    Script by Martin Gollowitzer, based on udev configuration
#    by Georg Greve. 
#    
#    File version 1.005
#
#    Copyright © 2010 Free Software Foundation Europe e.V.
#    e-mail: team@fsfeurope.org
#
#    Permission is hereby granted, free of charge, to any person obtaining a copy
#    of this software and associated documentation files (the "Software"), to deal
#    in the Software without restriction, including without limitation the rights
#    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#    copies of the Software, and to permit persons to whom the Software is
#    furnished to do so, subject to the following conditions:
#    
#    The above copyright notice and this permission notice shall be included in
#    all copies or substantial portions of the Software.
#    
#    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#    THE SOFTWARE.


# We need root privileges
ME=$(whoami)
if [ x$ME != "xroot" ]; then

	echo "You are not root. This script will only work if you run it as root.\n"
	exit 1
fi

# If that directory doesn't exist, chances are bad that udev is used
if [ ! -d /etc/udev ]; then
	echo "Couldn't find /etc/udev/!"
	exit 1
fi

# What do we actually want to do?
echo "This script will create a group named 'scard' for users who should"
echo "be able to use a smartcard reader on this computer."
echo "Please enter one user name to be added to this group below."
echo "To add more users to this group, type"
echo "# addgroup <yourusername> scard "
echo "after this script has finished. Note: You have to be root to do so.\n"
read -p "User name: " CARDUSER
echo " "

# Create the udev rules directory if it doesn't exist yet
mkdir -p /etc/udev/rules.d

# Create the rule for the card readers
cat > /etc/udev/rules.d/z80_gnupg-ccid.rules <<EOR
ACTION!="add", GOTO="gnupg-ccid_rules_end"

# USB SmartCard Readers
## SCM readers (SCR335, SPR532, & Co)
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="e001", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="e003", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="5115", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="5116", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="511f", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="04e6", ATTRS{idProduct}=="5410", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
## Cherry readers
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="0005", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="0010", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="002d", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="003e", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="046a", ATTRS{idProduct}=="005b", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
## OmniKey USB readers
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="076b", ATTRS{idProduct}=="4321", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="076b", ATTRS{idProduct}=="3021", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
## REINER SCT card readers
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0c4b", ATTRS{idProduct}=="0100", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0c4b", ATTRS{idProduct}=="0300", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0c4b", ATTRS{idProduct}=="0400", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
## Gemplus/Gemalto readers
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="08e6", ATTRS{idProduct}=="3437", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"
## Kobil Kaan Advanced ##
ACTION=="add", SUBSYSTEM=="usb", ATTRS{idVendor}=="0d46", ATTRS{idProduct}=="3002", GROUP="scard", MODE="0660", RUN+="/etc/udev/scripts/gnupg-ccid"



# PCMCIA SmartCard Readers
## Omnikey CardMan 4040
SUBSYSTEM=="cardman_4040", GROUP="scard", MODE="0660", "/etc/udev/scripts/gnupg-ccid"

LABEL="gnupg-ccid_rules_end"
EOR

# Change ownership and privileges of the rule file
chown root:root /etc/udev/rules.d/z80_gnupg-ccid.rules
chmod 644 /etc/udev/rules.d/z80_gnupg-ccid.rules

# Create the udev scripts directory if it doesn't exist yet
mkdir -p /etc/udev/scripts

# Create the scripts to set the device privileges
cat > /etc/udev/scripts/gnupg-ccid <<EOS
#!/bin/bash

GROUP=scard

if [ "\${ACTION}" = "add" ] && [ -f "\${DEVICE}" ]
then
    chmod o-rwx "\${DEVICE}"
    chgrp "\${GROUP}" "\${DEVICE}"
    chmod g+rw "\${DEVICE}"
fi 
EOS

# Change ownership and privileges of the script file
chown root:root /etc/udev/scripts/gnupg-ccid
chmod 755 /etc/udev/scripts/gnupg-ccid

# Add the group to be allowed to access the card reader
addgroup scard

# Add the user entered before to the group
addgroup $CARDUSER scard

# We are done :)
echo "Card reader configuration completed."
echo "Now please reboot and then, "
echo "as $CARDUSER, type"
echo "$ gpg --card-status"
echo "to see if it works."
