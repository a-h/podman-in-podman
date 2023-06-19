# podman-in-podman

This repo demonstrates how it's possible to build an OIC container inside Podman using Podman, without root access at either point.

## Tasks

### build

Build a container that contains Podman. This is where the child container will be built.

```
podman build . -t parent:latest
```

### run

The run command uses the podman user that's configured in the Docker container.

If we want to use a different user, we'd have to rename the podman user mentioned in the Dockerfile.

The command builds and runs a child container as an unpriveleged user in the parent container.

```sh
podman run --user=podman -it --rm parent:latest '/bin/bash' '/build.sh'
```

### run-interactive

```sh
podman run --user=podman -it --rm parent:latest /bin/bash
```
