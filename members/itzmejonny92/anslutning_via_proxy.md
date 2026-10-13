# Anslutning till Spectre - aktuell metod och historisk proxy

> **Status 2026-09-24:** SOCKS5-metoden nedan är inaktuell som normal
> anslutningsväg. Team 2 använder nu Headscale/Tailscale, annonserade
> subnet-rutter och Split DNS. Ingen SSH-tunnel eller separat Opera-profil
> behövs för vanlig åtkomst till Spectre.

Filnamnet behålls för att äldre dokumentlänkar inte ska brytas. Den gamla
proxyvägen finns kvar längst ned som historisk referens.

## Nuvarande lösning

| Tidigare | Nu |
| --- | --- |
| SSH-tunnel till jumphostens publika IP | Krypterad Tailscale-anslutning till teamets Headscale |
| Lokal SOCKS5-port på `127.0.0.1:1080` | Direkt routing via jumphosten |
| Separat Opera GX-profil med proxyflaggor | Opera GX öppnas normalt |
| DNS genom SOCKS-proxyn | Split DNS för `itsx25.chas-lab.dev` |

Jumphosten annonserar Team 2:s privata nät `10.0.2.0/24` och
Spectre-adressen `10.0.0.2/32`. Split DNS skickar frågor för
`itsx25.chas-lab.dev` till DNS-proxyn på jumphostens Tailnet-adress
`100.64.0.2`.

## Windows och Opera GX

Windows-klienten ska vara registrerad under rätt personlig Headscale-användare
och ansluten till `https://team2.itsx25.chas-lab.dev`. WSL och Windows är
separata Tailscale-noder; en fungerande WSL-anslutning ger inte automatiskt
Opera GX nätåtkomst.

Kontrollera i PowerShell:

```powershell
tailscale status
tailscale ping team2-jumphost
Resolve-DnsName spectre.itsx25.chas-lab.dev
Test-NetConnection 10.0.0.2 -Port 443
```

Vid behov aktiveras annonserade rutter i PowerShell som administratör:

```powershell
tailscale set --accept-routes=true
```

DNS-namnet ska lösas till `10.0.0.2`. Starta därefter Opera GX normalt,
utan `--proxy-server`, `--host-resolver-rules` eller separat
proxyprofil, och öppna:

```text
https://spectre.itsx25.chas-lab.dev
```

## WSL och VS Code-terminalen

För terminalåtkomst används WSL:s egen registrerade Tailscale-nod:

```bash
sudo systemctl enable --now tailscaled
sudo tailscale set --accept-routes=true
tailscale status
tailscale ping team2-jumphost
getent ahostsv4 spectre.itsx25.chas-lab.dev
curl -I https://spectre.itsx25.chas-lab.dev
```

Namnet ska lösas till `10.0.0.2`. Ett HTTP-svar eller en normal
omdirigering visar att nätvägen fungerar.

## SSH till privata resurser

När Tailscale och subnet-rutterna fungerar behövs ingen SOCKS5-tunnel för SSH:

```bash
ssh DIN_OS_LOGIN_ANVANDARE.64.0.2
ssh DIN_OS_LOGIN_ANVANDARE.0.2.3
```

`100.64.0.2` är jumphostens Tailnet-adress och `10.0.2.3` är
`team2-primary`. Personlig OS Login-identitet ska användas.

## Felsökning av nuvarande lösning

- Om Spectre fungerar i WSL men inte i Opera GX, kontrollera att Windows-noden
  är registrerad och online.
- Om IP fungerar men DNS misslyckas, kontrollera Split DNS och DNS-proxyn på
  jumphosten.
- Om privata adresser timear ut, verifiera `--accept-routes=true`,
  route advertisement och Headscale-godkännande.
- Kontrollera att gamla proxyflaggor, externa VPN-anslutningar eller separata
  Opera-profiler inte fortfarande används.
- Auth-id:n, pre-auth keys, tokens och privata SSH-nycklar får aldrig delas.

Mer information finns i
[teamets gemensamma anslutningsguide](../../docs/gemensam_anslutningsguide.md).

## Historisk metod - SOCKS5 via SSH (inaktuell)

### 1. Starta SSH-tunneln

Gå till repots rot och hämta jumphostens aktuella IP-adress från Terraform:

```bash
cd /home/jonny-nguyen/team
JUMPHOST_IP=$(terraform output -raw jumphost_external_ip)
printf '%s\n' "$JUMPHOST_IP"
```

Starta sedan tunneln och låt terminalen vara öppen:

```bash
ssh -N -D 1080 jonny@"$JUMPHOST_IP"
```

Att terminalen inte visar någon ny text är normalt. SSH väntar då och håller
tunneln öppen. Vid dokumentationstillfället var adressen `34.51.183.245`, men
Terraform-outputen ska användas om adressen ändras.

### 2. Kontrollera proxyn i Windows

Kör i Windows PowerShell:

```powershell
Test-NetConnection 127.0.0.1 -Port 1080
```

`TcpTestSucceeded : True` betyder att Windows når SOCKS5-proxyn.

### 3. Starta Opera GX med proxyn

Kör följande i Windows CMD:

```cmd
"C:\Users\Jonny\AppData\Local\Programs\Opera GX\opera.exe" --user-data-dir="C:\Users\Jonny\AppData\Local\Temp\opera-gx-spectre" --proxy-server="socks5://127.0.0.1:1080" --host-resolver-rules="MAP * ~NOTFOUND, EXCLUDE 127.0.0.1"
```

Kommandot öppnar en separat Opera GX-profil. Endast den profilen använder
labbsidans proxy.

### 4. Öppna labbsidan

```text
https://spectre.itsx25.chas-lab.dev
```

Kontrollera att sidan identifierar anslutningen som Team 2.

### 5. Avsluta

1. Stäng det separata Opera GX-fönstret.
2. Gå tillbaka till SSH-terminalen.
3. Tryck `Ctrl+C` för att stänga tunneln.

### Historisk felsökning

- Kontrollera att SSH-terminalen fortfarande är öppen.
- Kör portkontrollen igen och verifiera att resultatet är `True`.
- Kontrollera att Opera GX startades med den separata profilen och proxyflaggorna.
- Dela aldrig privata SSH-nycklar, autentiseringsuppgifter eller innehåll från
  Terraform state.
