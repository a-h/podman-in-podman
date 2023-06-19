## Tasks

### build

Build a container that contains Podman.

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
