<#
diagnostico_rede.ps1
Descrição: Executa diagnósticos básicos de rede e salva um relatório em reports/ com timestamp.
Uso: Abra PowerShell como Administrador (se necessário) e execute:
.\diagnostico_rede.ps1
#>

# -------- Configurações iniciais --------
$reportsDir = Join-Path -Path $PSScriptRoot -ChildPath "reports"
if (-not (Test-Path -Path $reportsDir)) {
    New-Item -Path $reportsDir -ItemType Directory | Out-Null
}

$timestamp = (Get-Date).ToString("yyyyMMdd_HHmmss")
$reportFile = Join-Path -Path $reportsDir -ChildPath "diagnostico_rede_$timestamp.txt"

function Write-ReportTitle {
    param([string]$title)
    "`n==== $title ====`n" | Out-File -FilePath $reportFile -Append -Encoding UTF8
}

function Write-Report {
    param([string]$text)
    $text | Out-File -FilePath $reportFile -Append -Encoding UTF8
}

"Relatório de Diagnóstico de Rede - $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))" | Out-File -FilePath $reportFile -Encoding UTF8

# -------- 1) Informações dos Adaptadores --------
Write-ReportTitle "Informações dos Adaptadores de Rede"
Get-NetAdapter -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Report "Nome: $($_.Name)"
    Write-Report "Estado: $($_.Status)"
    Write-Report "MacAddress: $($_.MacAddress)"
    Write-Report "LinkSpeed: $($_.LinkSpeed)"
    Write-Report "-----------"
}

# -------- 2) IP / Gateway / DNS --------
Write-ReportTitle "Configurações IP, Gateway e DNS"
Get-NetIPConfiguration -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Report "Interface: $($_.InterfaceAlias)"
    Write-Report "IPv4: $($_.IPv4Address.IPAddress)  PrefixLength: $($_.IPv4Address.PrefixLength)"
    Write-Report "IPv6: $($_.IPv6Address | ForEach-Object { $_.IPAddress })"
    Write-Report "Gateway: $($_.IPv4DefaultGateway.NextHop)"
    Write-Report "DNS Servers: $($_.DNSServer.ServerAddresses -join ', ')"
    Write-Report "-----------"
}

# -------- 3) Ping --------
Write-ReportTitle "Teste de Latência (Ping)"
$targets = @("8.8.8.8", "1.1.1.1")
$gateway = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway } | Select-Object -First 1).IPv4DefaultGateway.NextHop
if ($gateway) { $targets += $gateway }

foreach ($t in $targets) {
    Write-Report "Ping -> ${t}"
    try {
        $ping = Test-Connection -ComputerName $t -Count 4 -ErrorAction Stop
        $avg = ($ping | Measure-Object -Property ResponseTime -Average).Average
        Write-Report "Status: Sucesso | RTT médio: $([math]::Round($avg,2)) ms"
    } catch {
        Write-Report "Status: Falha | Erro: $($_.Exception.Message)"
    }
    Write-Report "-----------"
}

# -------- 4) Resolução DNS --------
Write-ReportTitle "Teste de Resolução DNS"
$domains = @("www.google.com","www.facebook.com","www.microsoft.com")
foreach ($d in $domains) {
    Write-Report "Resolve -> ${d}"
    try {
        $ips = [System.Net.Dns]::GetHostAddresses($d) | ForEach-Object { $_.IPAddressToString }
        if ($ips) {
            Write-Report "IPs: $($ips -join ', ')"
        } else {
            Write-Report "Nenhum IP retornado"
        }
    } catch {
        Write-Report "Erro na resolução: $($_.Exception.Message)"
    }
    Write-Report "-----------"
}

# -------- 5) Teste de portas --------
Write-ReportTitle "Teste de Portas (TCP) - host: www.google.com"
$hostToTest = "www.google.com"
$ports = @(80,443,3389,22)

foreach ($p in $ports) {
    Write-Report "Porta ${p} -> Testando..."
    try {
        $sock = New-Object System.Net.Sockets.TcpClient
        $iar = $sock.BeginConnect($hostToTest, $p, $null, $null)
        $success = $iar.AsyncWaitHandle.WaitOne(2000)

        if ($success -and $sock.Connected) {
            Write-Report "Porta ${p}: ABERTA"
            $sock.Close()
        } else {
            Write-Report "Porta ${p}: FECHADA/SEM RESPOSTA (timeout)"
        }
    } catch {
        Write-Report "Porta ${p}: ERRO - $($_.Exception.Message)"
    }
}

# -------- 6) Traceroute --------
Write-ReportTitle "Traceroute para 8.8.8.8"
try {
    $tracert = tracert -d 8.8.8.8
    $tracert | Out-File -FilePath $reportFile -Append -Encoding UTF8
} catch {
    Write-Report "Erro no traceroute: $($_.Exception.Message)"
}

# -------- 7) Teste velocidade HTTP --------
Write-ReportTitle "Teste simples de velocidade (latência HTTP)"
try {
    $uri = "http://www.google.com"
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $req = [System.Net.WebRequest]::Create($uri)
    $req.Method = "HEAD"
    $resp = $req.GetResponse()
    $sw.Stop()
    Write-Report "Tempo HEAD para ${uri}: $($sw.ElapsedMilliseconds) ms"
    $resp.Close()
} catch {
    Write-Report "Erro no teste de velocidade HTTP: $($_.Exception.Message)"
}

# -------- 8) Resumo --------
Write-ReportTitle "Resumo / Recomendações"
Write-Report "Verifique: cabo/wi-fi, power do modem/roteador, reinicie adaptador de rede se necessário."
Write-Report "Se problemas persistirem, copie este relatório e envie ao responsável de infraestrutura."

# -------- FIM --------
Write-Report "`nRelatório salvo em: $reportFile"
Write-Host "Diagnóstico concluído. Relatório gerado em: $reportFile"
