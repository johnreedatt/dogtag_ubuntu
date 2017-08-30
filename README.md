# dogtag_ubuntu
Attempting to containerize dogtag with Ubuntu base OS.

Attempted the following docker run to get the systemd to work.

docker run -it \
  --security-opt seccomp=unconfined \
  --cap-add=SYS_ADMIN \
  -e "container=docker" \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  dogtag


