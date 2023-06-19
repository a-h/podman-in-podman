FROM rockylinux:9

# https://www.redhat.com/sysadmin/podman-inside-container
# https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
# https://insujang.github.io/2020-11-09/building-container-image-inside-container-using-buildah/

# Remove directories used by dnf that are just taking up space.
RUN dnf -y install podman buildah fuse-overlayfs #; rm -rf /var/cache /var/log/dnf* /var/log/yum.*

# Create the magic config.
# https://github.com/containers/podman/issues/8705#issuecomment-744076609
# https://www.redhat.com/sysadmin/image-stores-podman
RUN mkdir -p /etc/containers
COPY storage.conf /etc/containers/storage.conf

# Run buildah for no reason.
RUN buildah info

# Adjust storage.conf to enable Fuse storage.
#RUN sed -i -e 's|^#mount_program|mount_program|g' -e '/additionalimage.*/a "/var/lib/shared",' $HOME/.config/containers/storage.conf

COPY child/Dockerfile /Dockerfile
COPY build.sh /build.sh
