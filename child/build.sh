set -ex
echo "Building child..."
podman build --isolation=chroot -t localhost/child:latest .
