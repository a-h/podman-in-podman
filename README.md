## Tasks

### build

```
podman build --device /dev/fuse:rw --security-opt seccomp=unconfined --security-opt apparmor=unconfined . -t parent:latest
```

### run

```sh
podman run -it --rm --device /dev/fuse:rw --security-opt seccomp=unconfined --security-opt apparmor=unconfined parent:latest /bin/bash
```

### run-interactive

```sh
podman run -it --rm parent:latest /bin/bash
```
