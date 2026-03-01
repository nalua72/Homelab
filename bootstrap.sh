#!/usr/bin/env bash

set -e

USER_NAME="media"
BASE_DIR="/srv/homelab"

echo "🚀 Iniciando bootstrap del homelab..."

# ----------------------------
# 1️⃣ Crear usuario si no existe
# ----------------------------
if id "$USER_NAME" &>/dev/null; then
    echo "👤 Usuario $USER_NAME ya existe."
else
    echo "👤 Creando usuario $USER_NAME..."
    sudo adduser --disabled-password --gecos "" $USER_NAME
fi

# ----------------------------
# 2️⃣ Crear grupo docker si no existe
# ----------------------------
if ! getent group docker > /dev/null; then
    echo "📦 Creando grupo docker..."
    sudo groupadd docker
fi

echo "🔗 Añadiendo $USER_NAME al grupo docker..."
sudo usermod -aG docker $USER_NAME

# ----------------------------
# 3️⃣ Crear estructura de carpetas
# ----------------------------
echo "📁 Creando estructura en $BASE_DIR..."

sudo mkdir -p $BASE_DIR/{gluetun,qbittorrent/config,prowlarr/config,sonarr/config,radarr/config,jellyfin/{config,cache}}
sudo mkdir -p $BASE_DIR/downloads
sudo mkdir -p $BASE_DIR/media/{movies,series}

# ----------------------------
# 4️⃣ Asignar permisos
# ----------------------------
echo "🔐 Asignando permisos a $USER_NAME..."
sudo chown -R $USER_NAME:$USER_NAME $BASE_DIR
sudo chmod -R 775 $BASE_DIR

# ----------------------------
# 5️⃣ Crear .env.example
# ----------------------------
ENV_FILE="$BASE_DIR/.env.example"

if [ ! -f "$ENV_FILE" ]; then
    echo "📝 Creando .env.example..."
    cat <<EOF | sudo tee $ENV_FILE > /dev/null
# ProtonVPN OpenVPN credentials
OPENVPN_USER=protonvpnXXXX
OPENVPN_PASSWORD=XXXXXXXX

# VPN
VPN_COUNTRY=Netherlands

# System
TZ=Europe/Madrid
PUID=$(id -u $USER_NAME)
PGID=$(id -g $USER_NAME)
EOF
fi

# ----------------------------
# 6️⃣ Información final
# ----------------------------
echo ""
echo "✅ Bootstrap completado."
echo ""
echo "📌 Usuario: $USER_NAME"
echo "📌 UID: $(id -u $USER_NAME)"
echo "📌 GID: $(id -g $USER_NAME)"
echo ""
echo "⚠️  IMPORTANTE:"
echo "Cierra sesión y vuelve a entrar como '$USER_NAME'"
echo "Luego podrás usar Docker sin sudo."
echo ""
echo "👉 Para cambiar a ese usuario:"
echo "    su - $USER_NAME"
echo ""
echo "📂 Directorio base:"
echo "    $BASE_DIR"
echo ""