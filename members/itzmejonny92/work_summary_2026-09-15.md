# Individuell arbetssammanfattning - Jonny Nguyen - 2026-09-15

## Syfte

Mitt fokus var att pedagogiskt genomföra och verifiera Workshop 2:s moment om
Metadata Service, instansidentitet, Headscale, Tailscale och säkrare
brandväggsregler samt att hålla gruppens GitHub-underlag spårbart.

## Mitt arbete

- Synkade `member/itzmejonny92` med dagens ändringar från `main`.
- Verifierade min GCP-inloggning, Application Default Credentials och personliga
  OS Login-nyckel.
- Tog bort en överflödig SSH-nyckel från min OS Login-profil.
- Inspekterade Metadata Service utan att hämta en access token.
- Verifierade att gamla `ssh-keys` saknades i instansmetadata och att
  jumphosten använde sitt dedikerade service account.
- Jämförde lokal Secret Manager-åtkomst med instansens åtkomst utan att visa
  hemlighetens innehåll.
- Identifierade att Headscales `server_url` felaktigt pekade på
  Spectre-portalen och rättade den till Team 2:s domän.
- Installerade Tailscale `1.102.4` i min WSL-miljö.
- Skapade Headscale-användaren `jonny` och registrerade
  `jonny-workstation`.
- Verifierade `tailscale status`, ping och SSH till jumphosten via Tailnet.
- Granskade och korrigerade Headscale-regeln från internetomfattande åtkomst
  till endast utbildarens reverse proxy.
- Begränsade SSH-regeln till instruktörsnätet efter att Tailnet-SSH fungerade.
- Utökade den gemensamma anslutningsguiden med dagens verifierade flöde och
  felsökning.
- Följde medlemsregistreringen tills alla fem närvarande medlemmar hade
  personliga användare och online-enheter.
- Skapade en tvådagarssammanfattning och återanslutningschecklista för Amin.
- Skapade och följde upp PR #49 och #50 samt verifierade deployerna från
  `main`.
- Skapade backlog-issues #51 och #52 för workshopens steg 7 och 8.

## Viktiga beslut

- Headscale ska endast nås via utbildarens reverse proxy, inte direkt från hela
  internet.
- Publik SSH ska vara begränsad till instruktörsnätet. Medlemmarnas normala
  SSH-väg är Tailnet efter registrering.
- Personliga Headscale-användare och tydliga enhetsnamn används för spårbarhet.
- Headscale-installationen betraktas inte som reproducerbar förrän den manuella
  serverkonfigurationen finns som granskad kod eller dokumenterad automation.
- Steg 7-arbete måste baseras på senaste `main` och får inte återinföra gamla
  metadata-nycklar eller breda brandväggsregler.

## Pull requests och verifiering

- [PR #49](https://github.com/itsx25-team2/kurs6-team2-infra/pull/49): steg 5,
  anslutningsguide och brandväggsregler för steg 6.
- [Deploy efter PR #49](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34983968830): lyckad.
- [PR #50](https://github.com/itsx25-team2/kurs6-team2-infra/pull/50): Amins
  sammanfattning och checklista.
- [Deploy efter PR #50](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34985255864): lyckad.
- Terraform formaterades och validerades före merge.
- Livekontrollen visade workshopens avsedda källnät för port 22 och 8080.
- Headscale health svarade HTTP 200 efter deploy.
- Alla fem närvarande medlemsenheter och jumphosten var online.
- SSH via Tailnet till jumphosten lyckades.

## Kvarvarande uppföljning

- Hjälp Amin att registrera sin personliga klient och komplettera OS Login.
- Bedöm om alla medlemmar behöver `osAdminLogin` eller om vanlig `osLogin`
  räcker.
- Följ PB-13 för `primary`, routing, route acceptance och NAT-test.
- Följ PB-14 för en säker Headscale ACL-policy med rollback.
- Gör Headscale-installation och serverkonfiguration reproducerbara i PB-12.
- Följ öppna frågor om Terraform state och GitHub Actions-variabler.

## Säker dokumentation

Jag har inte sparat eller publicerat auth-id:n, privata SSH-nycklar, access
tokens, Secret Manager-värden, Terraform state eller andra credentials.
