FROM rockylinux:9

# a-h
# This file is based on the example at:
# https://github.com/containers/podman/blob/main/contrib/podmanimage/stable/Containerfile

# I was referencing the following documents:

# https://www.redhat.com/sysadmin/podman-inside-container
# https://github.com/containers/podman/blob/main/docs/tutorials/rootless_tutorial.md
# https://insujang.github.io/2020-11-09/building-container-image-inside-container-using-buildah/

# a-h: Esentially the file is not modified.

# Don't include container-selinux and remove
# directories used by dnf that are just taking
# up space.
# TODO: rpm --setcaps... needed due to Fedora (base) image builds
#       being (maybe still?) affected by
#       https://bugzilla.redhat.com/show_bug.cgi?id=1995337#c3
RUN dnf -y update && \
    rpm --setcaps shadow-utils 2>/dev/null && \
    dnf -y install podman fuse-overlayfs openssh-clients \
        --exclude container-selinux && \
    dnf clean all && \
    rm -rf /var/cache /var/log/dnf* /var/log/yum.*

RUN useradd podman; \
echo -e "podman:1:999\npodman:1001:64535" > /etc/subuid; \
echo -e "podman:1:999\npodman:1001:64535" > /etc/subgid;

ARG _REPO_URL="https://raw.githubusercontent.com/containers/podman/main/contrib/podmanimage/stable"
ADD $_REPO_URL/containers.conf /etc/containers/containers.conf
ADD $_REPO_URL/podman-containers.conf /home/podman/.config/containers/containers.conf

RUN mkdir -p /home/podman/.local/share/containers && \
    chown podman:podman -R /home/podman && \
    chmod 644 /etc/containers/containers.conf

# Copy & modify the defaults to provide reference if runtime changes needed.
# Changes here are required for running with fuse-overlay storage inside container.

# a-h: This line doesn't work in Rocky Linux, presumably there's some messing about required?
#RUN sed -e 's|^#mount_program|mount_program|g' \
#           -e '/additionalimage.*/a "/var/lib/shared",' \
#           -e 's|^mountopt[[:space:]]*=.*$|mountopt = "nodev,fsync=0"|g' \
#           /usr/share/containers/storage.conf \
#           > /etc/containers/storage.conf

# Note VOLUME options must always happen after the chown call above
# RUN commands can not modify existing volumes
VOLUME /var/lib/containers
VOLUME /home/podman/.local/share/containers

RUN mkdir -p /var/lib/shared/overlay-images \
             /var/lib/shared/overlay-layers \
             /var/lib/shared/vfs-images \
             /var/lib/shared/vfs-layers && \
    touch /var/lib/shared/overlay-images/images.lock && \
    touch /var/lib/shared/overlay-layers/layers.lock && \
    touch /var/lib/shared/vfs-images/images.lock && \
    touch /var/lib/shared/vfs-layers/layers.lock

ENV _CONTAINERS_USERNS_CONFIGURED=""

# a-h: Add the Dockerfile and scripts in.
COPY child/Dockerfile /Dockerfile
COPY build.sh /build.sh
RUN chmod 777 /Dockerfile
RUN chmod 777 /build.sh
