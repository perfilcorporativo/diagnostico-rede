🔍 Diagnóstico de Rede – PowerShell

Este projeto contém um script PowerShell desenvolvido para realizar um diagnóstico completo da conexão de rede do usuário, verificando conectividade, adaptadores, DNS, latência, gateway, portas e muito mais.
Ideal para uso pessoal, suporte técnico ou portfólio profissional.

🚀 Funcionalidades

O script executa automaticamente os seguintes testes:

🌐 Ping Geral (Google – 8.8.8.8)

🖥 Nome do computador e do usuário

🔌 Status dos adaptadores de rede

📡 Endereço IP da máquina

🌍 DNS configurado

🛜 Gateway e teste de ping

🔍 Teste de portas comuns (80, 443, 53, 3389 etc.)

⚡ Tempo estimado para conclusão do diagnóstico

💾 Geração automática de relatório no arquivo diagnostico_rede.txt

📦 Como executar o script
1️⃣ Abra o PowerShell como Administrador

Clique com o botão direito → Executar como Administrador.

2️⃣ Vá até a pasta onde está o projeto:
cd "C:\Users\SeuUsuario\Desktop\diagnostico-rede"

3️⃣ Execute o script:
.\diagnostico_rede.ps1

❗ Se o Windows bloquear a execução:

Execute:

Set-ExecutionPolicy -Scope CurrentUser RemoteSigned

🛠 Tecnologias utilizadas

PowerShell 5+

Test-Connection

Get-NetAdapter

Get-NetIPAddress

Get-DnsClientServerAddress

Get-NetRoute

System.Net.Sockets.TcpClient

Measure-Command

Todas as funcionalidades são nativas do Windows (nenhum software externo é necessário).

📁 Estrutura do Projeto
diagnostico-rede/
│── diagnostico_rede.ps1
└── README.md

📄 Licença

Este projeto é livre para uso pessoal, estudo ou portfólio.