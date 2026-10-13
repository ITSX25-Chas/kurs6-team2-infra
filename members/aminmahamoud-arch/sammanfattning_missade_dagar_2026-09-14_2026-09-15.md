# Sammanfattning för Amin - uppföljning till 2026-09-21

Detta dokument sammanfattar Blue Team-arbetet den 14, 15, 17 och 21 september
som Amin behöver följa upp.
Syftet är att göra det möjligt att förstå gruppens beslut och ansluta den egna
arbetsstationen utan att behöva göra om teamets gemensamma serverarbete.

## Status före perioden

Teamets Terraform-infrastruktur och CI/CD-pipeline fanns redan i GCP. GitHub
Actions använde Workload Identity Federation (WIF), vilket gjorde att
långlivade service account-nycklar inte längre behövdes i GitHub Secrets.

## Arbete den 2026-09-14

- WIF-migreringen kontrollerades efter att de gamla användarhanterade nycklarna
  hade tagits bort.
- Jumphosten migrerades från SSH-nycklar i instansmetadata till OS Login.
- `enable-oslogin` aktiverades och projektets metadatahanterade SSH-nycklar
  blockerades.
- Ett dedikerat service account kopplades till jumphosten.
- En gemensam anslutningsguide för GCP, OS Login, SSH och SOCKS5 skapades.
- Headscale `0.29.3` installerades manuellt på jumphosten. Den manuella
  installationen följs fortsatt upp i issue #41 för att göras reproducerbar.

## Arbete den 2026-09-15

### Metadata och instansidentitet

- GCP Metadata Service inspekterades från jumphosten.
- Kontrollen visade att OS Login var aktivt och att något `ssh-keys`-attribut
  inte längre fanns i instansmetadata.
- Skillnaden mellan en persons lokala GCP-identitet och VM-instansens service
  account verifierades med Secret Manager utan att hemlighetens innehåll
  dokumenterades.

### Headscale och Tailscale

- Headscale konfigurerades med serveradressen
  `https://team2.itsx25.chas-lab.dev`.
- Headscale är aktivt på jumphosten och använder `team2.arpa` som intern
  basdomän.
- Tailscale installerades och jumphosten registrerades i teamets Tailnet.
- Personliga Headscale-användare och enheter skapades för Jonny, Lasse, Fajk,
  Tim och Willibroad.
- Samtliga fem närvarande medlemmars enheter var online vid slutkontrollen.
- SSH från Jonnys arbetsstation till jumphosten via Tailnet verifierades.

### Brandvägg och steg 6

PR #49 införde följande begränsningar enligt workshopens steg 6:

- Headscale på TCP 8080 tillåts endast från utbildarens reverse proxy
  `10.0.0.2/32`.
- SSH på TCP 22 tillåts endast från instruktörsnätet `10.0.0.0/24`.
- Medlemmarnas fortsatta åtkomst sker via det krypterade Tailnet.

Ändringarna är mergade, driftsatta och verifierade.

## Arbete den 2026-09-17

### Steg 7: primary och routing

- `team2-primary` aktiverades som `e2-micro` på `10.0.2.3` utan extern IP och
  med OS Login.
- Jumphosten annonserar `10.0.2.0/24` och Spectre-adressen `10.0.0.2/32`.
- Subnet routing, direkt routing utan SNAT och returroute verifierades.
- Spectre-NAT gjordes persistent i Terraform.
- `dnsmasq` och Headscale Split DNS konfigurerades så att
  `spectre.itsx25.chas-lab.dev` löses till `10.0.0.2`.

### Steg 8: Headscale ACL

- PR #58 införde en första `policy.hujson`.
- Teamet beslutade att alla registrerade medlemmar tills vidare ska ingå i
  `group:admin` för att förenkla kursarbetet. Detta är ett medvetet undantag
  från least privilege.
- Den första policyversionen hade fel användarsyntax och fick Headscale att
  krascha. Policyn korrigerades med avslutande `@`, validerades och tjänstens
  health kontrollerades med HTTP 200.
- Amins användare finns ännu inte. När registreringen är klar ska `amin@`
  läggas till i policyn via en granskad PR.
- PB-14 är fortfarande pågående eftersom nekad trafik och rollback behöver
  verifieras.

## Arbete den 2026-09-21

### Primary, IAP och K3s

- `team2-primary` uppgraderades till `e2-small` för att klara K3s och
  applikationslasten bättre.
- IAP Tunnel Access lades till för teamets verifierade OS Login-identiteter.
- En brandväggsregel för IAP SSH lades till från Googles IAP-intervall
  `35.235.240.0/20` till jumphost och primary.
- K3s API på TCP 6443 tilläts från teamets privata subnet `10.0.2.0/24` till
  `primary`.
- Nätverkskoppling och target tags för K3s-brandväggen korrigerades och
  verifierades genom PR #66-#70.
- Headscale-policyn kompletterades så att den tillfälliga GitHub-runnern kan nå
  K3s API genom den avsedda privata routen.

### GitHub-organisation och repositorytransfer

- Teamets gemensamma GitHub-organisation är `itsx25-team2`.
- Infra-repot flyttades från Jonnys personliga konto till
  `itsx25-team2/kurs6-team2-infra`.
- Branches, Issues, pull requests, medlemmar, Actions-variabler och branch
  protection följde med transfern.
- Den lokala huvudklonen pekar nu på organisationens repositoryadress.
- WIF uppdaterades och verifierades mot den nya repositoryidentiteten. Den
  gamla personliga WIF-identiteten är borttagen.
- En efterföljande bootstrap-plan visade `No changes`.
- [PR #71](https://github.com/itsx25-team2/kurs6-team2-infra/pull/71)
  innehåller den spårbara Terraform- och dokumentationsändringen och väntar på
  två godkännanden.

### Separat CI-observation

Ett manuellt Actions-test från organisationsrepot bekräftade att WIF fungerade
och att Terraform kunde läsa state och GCP-resurser. Körningen stoppades senare
av att CI-kontot saknar rättighet att läsa projektets IAM-policy för
`google_project_iam_member`. Det är ett separat behörighetsproblem och inte ett
fel i repositorytransfern eller WIF.

## Det här behöver Amin göra

### Viktigast först: godkänn organisationsinbjudan

Amins medlemskap i `itsx25-team2` har status `pending`. Godkänn inbjudan på
GitHub innan arbetet fortsätter. Kontrollera därefter att följande repository
går att öppna:

- [Infra-repot](https://github.com/itsx25-team2/kurs6-team2-infra)
- [Applikationsrepot](https://github.com/itsx25-team2/company-website)

### 1. Läs gemensam dokumentation

- [Projektets README](../../README.md)
- [Gemensam anslutningsguide](../../docs/gemensam_anslutningsguide.md)
- [Product Backlog](../../docs/product_backlog.md)
- [PR #49](https://github.com/itsx25-team2/kurs6-team2-infra/pull/49)

### 2. Synka din branch

Kör från repots rot:

```bash
git remote set-url origin https://github.com/itsx25-team2/kurs6-team2-infra.git
git fetch origin
git switch member/aminmahamoud-arch
git pull --ff-only origin main
```

Kontrollera alltid `git status` före egna ändringar.

### 3. Kontrollera personlig GCP- och OS Login-åtkomst

Logga in med ditt eget Chas Academy-konto:

```bash
gcloud auth login
gcloud auth application-default login
gcloud config set project itsx25-lab
```

Amin saknas fortfarande i `os_admin_users`. Hans Chas Academy-adress och behov
av administrativ OS Login ska verifieras innan den läggs till via en granskad
pull request. Dela endast den publika SSH-nyckeln och aldrig den privata
nyckeln.

### 4. Installera Tailscale lokalt

Följ steg 8 i den gemensamma anslutningsguiden. På Ubuntu eller WSL:

```bash
curl -fsSL https://tailscale.com/install.sh -o /tmp/tailscale-install.sh
sudo sh /tmp/tailscale-install.sh
```

### 5. Skapa användaren `amin`

En administratör på jumphosten kontrollerar först att användaren saknas och
skapar den sedan en gång:

```bash
sudo headscale users list
sudo headscale users create amin
```

### 6. Anslut Amins arbetsstation

Kör lokalt:

```bash
sudo tailscale up \
  --login-server https://team2.itsx25.chas-lab.dev \
  --hostname amin-workstation
```

Registreringssidan visar ett tillfälligt auth-id. Registrera enheten på
jumphosten under användaren `amin` enligt den gemensamma guiden. Auth-id:t får
inte sparas i repot eller skickas i en öppen chatt.

### 7. Verifiera resultatet

Kör lokalt:

```bash
tailscale status
tailscale ping team2-jumphost
```

En administratör kontrollerar därefter att `amin-workstation` ligger under
användaren `amin` och är online.

### 8. Acceptera och testa privata rutter

```bash
sudo tailscale set --accept-routes=true
ping 10.0.2.3
ping spectre.itsx25.chas-lab.dev
```

Meddela teamet när registreringen fungerar så att `amin@` kan läggas till i
ACL-policyn och åtkomsten kan verifieras.

## Säkerhet att komma ihåg

- Skapa inte någon lokal service account-nyckel.
- Dela aldrig privata SSH-nycklar, auth-id:n, tokens eller hemlighetsvärden.
- Läs Terraform-planen och använd teamets PR-flöde före driftsättning.
- Kör Headscale-administrationskommandon på jumphosten med `sudo`.
- Använd `team2.itsx25.chas-lab.dev` för Headscale och
  `spectre.itsx25.chas-lab.dev` endast för Spectre-portalen.
