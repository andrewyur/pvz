podman rm pvzcontainer
buildah rmi pvzimage
buildah build -f Dockerfile --dns=none --platform linux/i386 -t pvzimage
podman create --name pvzcontainer pvzimage
mkdir -p pvzFS
podman unshare podman cp pvzcontainer:/ pvzFS/
podman unshare mkfs.ext2 -b 4096 -d pvzFS/ ./pvz-online/static/pvzImage.ext2 1700M
