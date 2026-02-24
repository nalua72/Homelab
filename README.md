# 🏠 Homelab Media Stack

Este repositorio contiene un stack completo de aplicaciones de medios, gestionadas por Docker Compose y conectadas a ProtonVPN mediante Gluetun.  

Stack incluye:

- Gluetun (VPN)
- qBittorrent (cliente torrent)
- Sonarr (gestión de series)
- Radarr (gestión de películas)
- Prowlarr (indexadores de torrents)
- Jellyfin (media server)

---

## 📁 Estructura de carpetas en `$HOME/homelab`

$HOME/homelab/
├── gluetun/
├── qbittorrent/config/
├── prowlarr/config/
├── sonarr/config/
├── radarr/config/
├── jellyfin/config/
├── jellyfin/cache/
├── downloads/
└── media/
    ├── movies/
    └── series/

- **downloads/** → Carpeta donde los torrents se descargan.  
- **media/** → Carpeta donde Sonarr y Radarr organizan series y películas para Jellyfin.  
- **config/** → Configuración persistente de cada servicio.  
- **jellyfin/cache/** → Caché de Jellyfin.  

---

## 🔹 Variables de entorno

Se deben definir en un fichero `.env` (NO subir a GitHub). Un ejemplo `.env.example`:

OPENVPN_USER=protonvpnXXXX
OPENVPN_PASSWORD=XXXXXXXX
VPN_COUNTRY=Netherlands
TZ=Europe/Madrid
PUID=1000
PGID=1000

---

## 🚀 Levantar el stack

cd $HOME/projects/homelab-compose
docker compose up -d

Reinicia Docker si es la primera vez:

sudo systemctl restart docker

---

## 🌐 Servicios y URLs

| Servicio       | URL / Puerto       | Descripción / Configuración básica                          |
|----------------|-----------------|------------------------------------------------------------|
| **Jellyfin**   | http://localhost:8096 | Media server. Usuario por defecto: admin / admin. Cambiar en Settings → Users. |
| **qBittorrent**| http://localhost:8080 | Cliente torrent. Usuario: admin, contraseña: adminadmin. |
| **Sonarr**     | http://localhost:8989 | Gestión de series, destino: /series. |
| **Radarr**     | http://localhost:7878 | Gestión de películas, destino: /movies. |
| **Prowlarr**   | http://localhost:9696 | Gestión de indexadores para Sonarr y Radarr. |
| **Gluetun VPN**| http://localhost:8080 | Contenedor VPN. Enruta tráfico de qBittorrent, Sonarr, Radarr y Prowlarr. |

---

## 🔹 Notas importantes

1. Jellyfin está fuera de la VPN → accesible en LAN.  
2. Todos los demás servicios pasan por VPN.  
3. Nunca subir `.env` a GitHub.  
4. Asegúrate de que las carpetas de media y descargas existen y están correctamente mapeadas en `$HOME/homelab`.  

---

## ⚡ Configuraciones básicas

- qBittorrent: WebUI habilitada, carpeta /downloads.  
- Sonarr / Radarr: Carpeta de destino /series y /movies.  
- Prowlarr: Añadir indexadores según disponibilidad.  
- Jellyfin: Escanear bibliotecas, cambiar usuario/contraseña.  
- Gluetun: Configurar país del servidor VPN y credenciales en .env.  

---

## 🔹 Integración Sonarr/Radarr con Prowlarr

1. Abre Prowlarr: [http://localhost:9696](http://localhost:9696)  
2. Añade indexadores (por ejemplo: Jackett, TorrentRSS o indexadores públicos).  
   - Ve a **Indexers → Add Indexer → Search**  
   - Introduce tu API key o URL según el indexador elegido.  
3. Configura Sonarr:  
   - Ve a **Settings → Indexers → Add → Torznab**  
   - Introduce la URL y API Key de Prowlarr (`http://prowlarr:9696/prowlarr/api/v1`)  
   - Guarda cambios y testea conexión.  
4. Configura Radarr de manera similar:  
   - **Settings → Indexers → Add → Torznab**  
   - URL y API Key de Prowlarr  
5. Ahora cualquier serie/película añadida en Sonarr o Radarr usará automáticamente los indexadores configurados en Prowlarr para buscar torrents.  

> 🔹 Nota: Si usas Docker Compose, dentro de la red, la URL de Prowlarr para Sonarr/Radarr puede ser `http://prowlarr:9696` en lugar de `localhost`.

---

## 🔧 Comandos útiles

- Levantar stack:  

docker compose up -d

- Apagar stack:  

docker compose down

- Ver logs:  

docker compose logs -f

- Reiniciar contenedores:  

docker compose restart

---

Con esto, tu stack está listo para usar y versionar en GitHub, con flujo de torrents automático desde Prowlarr a Sonarr/Radarr → qBittorrent → Jellyfin.
