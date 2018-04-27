#!/bin/bash

sudo apt-get install ifupdown

[ -f /etc/issue-standard ] || sudo cp -f /etc/issue /etc/issue-standard

TMPFILE=$(mktemp)
cat << EOF > $TMPFILE
#!/bin/sh
if [ "\$METHOD" = loopback ]; then
    exit 0
fi

# Only run from ifup.
if [ "\$MODE" != start ]; then
    exit 0
fi

rm -f /etc/issue
ip address | grep "scope global" | awk '{ print \$7 " : " \$2 }' >> /etc/issue
cat /etc/issue-standard >> /etc/issue
EOF
chmod +x $TMPFILE
sudo mv -f $TMPFILE /etc/network/if-up.d/show-ip-address

cat << EOF > $TMPFILE
$USER ALL=NOPASSWD: ALL
EOF
sudo cp -f $TMPFILE /etc/sudoers.d/dev

