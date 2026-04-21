from --platform=i386 docker.io/i386/debian:trixie-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update && apt -y upgrade && apt -y install xorg wine libgl1-mesa-dri

WORKDIR /app

COPY ["./Plants Vs Zombies - WORKING", "/app/"]

RUN mkdir -p /etc/X11/xorg.conf.d && cat > /etc/X11/xorg.conf.d/10-cheerpx.conf <<EOF
Section "Device"
    Identifier "CheerpX KMS"
    Driver "modesetting"
EndSection
EOF

RUN cat <<EOF > /root/.xinitrc
wine /app/steamclient_experimental/steamclient_loader_x32.exe
EOF

RUN useradd -m -s /bin/bash appuser && \
    echo 'appuser:password' | chpasswd && \
    chown -R appuser /home/appuser

CMD ["xinit"]
