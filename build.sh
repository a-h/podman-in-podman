set -ex
cd /home/cicd
cat /etc/subuid
echo "Building child..."
podman --log-level debug build --isolation=chroot -t child:latest .
echo "Running child..."
podman run child:latest
