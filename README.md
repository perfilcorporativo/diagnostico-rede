# 🔍 Diagnóstico de Rede – PowerShell

Este projeto é um script PowerShell criado para realizar um diagnóstico completo da rede do usuário, verificando conectividade, adaptadores, DNS, latência, testes de ping e muito mais.  
Ideal para uso pessoal, suporte técnico e portfólio profissional.

---

## 🚀 Funcionalidades

O script executa automaticamente os seguintes testes:

- 🌐 **Ping Geral (8.8.8.8)**
- 🖥 **Nome do PC e Nome do Usuário**
- 🔌 **Status dos Adaptadores de Rede**
- 📡 **Endereço IP da Máquina**
- 🌍 **DNS Preferencial**
- 📶 **Ping para o Gateway**
- 🛜 **Gateway da Rede**
- ⚡ **Tempo Estimado para Conclusão do Diagnóstico**
- 💾 **Geração de arquivo com resultado (opcional)**

---

## 📦 Como usar o script

### 1️⃣ Abra o PowerShell como Administrador  
Clique com o botão direito → **Executar como administrador**.

### 2️⃣ Navegue até a pasta onde está o arquivo  
Exemplo:

```powershell
cd "C:\Users\SeuUsuario\Desktop\diagnostico-rede"s

3️⃣ Execute o script:
.\diagnostico_rede.ps1

🔧 Tecnologias utilizadas

PowerShell s

Comandos de rede internos (Test-Connection, Get-NetAdapter, etc.)
