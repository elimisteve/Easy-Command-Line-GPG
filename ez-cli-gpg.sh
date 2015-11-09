#!/bin/bash

if [ -z $1 ]; then
    echo Usage: `basename $0` recipient
    exit 0
fi

# Recipient specified via command line
# Is often a (partial) name or (partial) email address
recip=$1

# Where to store encrypted and unencrypted email
# Use absolute path; ~ not interpreted as /home/username
# Directory must exist
maildir=$HOME/private

# Date format (used to name file)
# year, month, day, hour, minute
# E.g., 201003150607
date=`date +%Y%m%d%H%M`

# File to include email
# E.g., fraktil-to-201003150607.txt
filename=$recip-to-$date.txt

# Text editor used to compose email
editor=$EDITOR # use system default stored in $EDITOR
#editor='emacsclient -t'
#editor='emacs -nw'
#editor='vi'
#editor='nano'

# Drop into text editor to write the email
$editor $maildir/$filename

# Encrypt email (will be prompted for GPG passphrase)
# -a = armor ; -r = recipient ; -s = sign ; -e = encrypt
gpg -ar $recip -se $maildir/$filename # sign and encrypt
#gpg -ar $recip -s $maildir/$filename  # sign only
#gpg -ar $recip -e $maildir/$filename  # encrypt only

# Display GPG-encrypted email (e.g., to be pasted into mail client)
echo
cat $maildir/$filename.asc

# Optional - Delete unencrypted email
#rm $maildir/$filename

# Optional - Delete encrypted email
#rm $maildir/$filename.asc

# Note: to securely store email messages, consider creating a
# TrueCrypt volume and mounting it to $maildir
