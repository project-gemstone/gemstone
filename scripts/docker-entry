#!/bin/bash
set -e
echo "Starting.."

# execute rest as root
exec sudo -E -u root /bin/sh - <<EOF
#  change ownership
chown -R root:root /work/tools
# prevent "bad interpreter: Text file busy"
sync
# Run the build...
sh /sbin/docker-build-with-tools /work
EOF
