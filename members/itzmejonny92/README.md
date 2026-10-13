# Jonny Nguyen - individuell arbetsyta

Den här mappen är Jonnys personliga dokumentationsyta för Kurs 6 och gruppens
Blue Team-arbete med GCP, Terraform, Headscale, Tailscale och defensiv
flagganalys.

## Arbetsbranch

`member/itzmejonny92`

## Viktiga filer

| Fil | Syfte |
| --- | --- |
| [Anslutning till labbsidan via proxy](anslutning_via_proxy.md) | Steg för steg-instruktion för SSH-tunnel, SOCKS5 och Opera GX. |
| [Arbetssammanfattning 2026-09-08](work_summary_2026-09-08.md) | Individuell sammanfattning av dagens backlogg-, WIF-, verifierings- och dokumentationsarbete. |
| [Arbetssammanfattning 2026-09-14](work_summary_2026-09-14.md) | Individuell sammanfattning av slutförd WIF-migrering, IAM, brandvägg och dokumentation. |
| [Arbetssammanfattning 2026-09-15](work_summary_2026-09-15.md) | Individuell sammanfattning av Metadata Service, Headscale, Tailscale och steg 6. |
| [Arbetssammanfattning 2026-09-17](work_summary_2026-09-17.md) | Individuell sammanfattning av `primary`, subnet routing, direkt routing och Split DNS. |
| [Arbetssammanfattning 2026-09-22](work_summary_2026-09-22.md) | Pedagogisk analys av LookingGlass, Metadata Service och Cloud Storage-versionering. |
| [Samlad flagganalys 2026-09-24](flaggar_individuell_sammanfattning_2026-09-24.md) | Samlad status, lösningsmetod och defensiva lärdomar för kursens åtta flaggområden. |
| [Gemensam arbetssammanfattning 2026-09-24](../../docs/team_work_summary_2026-09-24.md) | MagicDNS för `company-website`, Headscale-verifiering och återställningsinformation. |
| [Gemensam arbetssammanfattning 2026-09-08](../../docs/team_work_summary_2026-09-08.md) | Gruppens gemensamma resultat, bidrag, säkerhetsstatus och nästa steg. |
| [Gemensam arbetssammanfattning 2026-09-14](../../docs/team_work_summary_2026-09-14.md) | Teamets verifierade säkerhetsarbete och aktuella status. |
| [Gemensam arbetssammanfattning 2026-09-15](../../docs/team_work_summary_2026-09-15.md) | Teamets gemensamma Workshop 2-resultat, PR:er och nästa steg. |
| [Gemensam arbetssammanfattning 2026-09-17](../../docs/team_work_summary_2026-09-17.md) | Teamets verifierade resultat för workshopens steg 7. |

## Användning

- Egna anteckningar och arbetssammanfattningar
- Beslut, observationer och frågor från säkerhetsgranskningar
- Underlag och källor kopplade till gruppens issues
- Resultat från tester som inte innehåller känsliga värden

## Aktuell personlig status

Senast verifierad: 2026-09-24.

- OS Login fungerar med Jonnys personliga Google-identitet och SSH-nyckel.
- Metadata Service och jumphostens service account har verifierats utan att
  exponera token eller innehåll från Secret Manager.
- Headscale-användaren `jonny` är skapad på teamets gemensamma server.
- WSL-klienten `jonny-workstation` är registrerad och online i Tailnet med
  Tailscale-adressen `100.64.0.3`.
- Anslutningen till `team2-jumphost` på `100.64.0.2` har verifierats med
  `tailscale ping`. Trafiken gick vid testet via `DERP(hel)`.
- Subnet routing till `team2-primary` på `10.0.2.3` är verifierad med ping,
  SSH och HTTP.
- Direkt routing utan SNAT är verifierad; `primary` såg Jonnys Tailnet-IP
  `100.64.0.3`.
- Spectre är verifierad via både `10.0.0.2` och Split DNS-namnet
  `spectre.itsx25.chas-lab.dev`.
- `company-website.team2.arpa` är verifierat mot `10.0.2.3` med
  namnuppslagning, ping och HTTP.
- Infra-repots återkommande deployfel har felsökts till projekt-IAM i
  root-konfigurationen. IAM flyttades till bootstrap utan resursborttagning,
  och deployen verifierades framgångsrikt via WIF från den egna branchen.
- Sju av åtta flaggor har identifierats genom defensiv analys utan att
  flaggvärden har dokumenterats i repot.
- De två metadata- och Storage-flaggorna har inte skickats in till Spectre.
- SQL injection är verifierad i kursmiljön, men den tillhörande flaggan
  återstår att identifiera.

## Arbetslogg

| Datum | Vad gjordes? | Nästa steg |
| --- | --- | --- |
| 2026-09-08 | Backlogg och agenda skapades, WIF infördes och verifierades, issues synkades och medlemsytor skapades. | Granska PR #22 och genomför kontrollerad nyckelrensning. |
| 2026-09-14 | WIF-migreringen slutfördes, medlems-PR #39 och #40 följdes upp, OS Login verifierades och gemensam dokumentation synkades. | Komplettera OS Login i issue #15, granska bucketfrågor och följ upp Headscale i issue #41. |
| 2026-09-15 | Metadata och instansidentitet verifierades, Headscales serveradress rättades och den personliga WSL-klienten anslöts till teamets Tailnet. | Granska och mergea säkerhetsrättningen, verifiera brandväggen och fortsätt med workshopens steg 6. |
| 2026-09-15, avslut | PR #49 och #50 mergades, steg 6 verifierades live och backloggen kompletterades med steg 7 och 8. | Synka och granska PB-13 innan `primary` driftsätts. |
| 2026-09-17 | `primary` aktiverades säkert, subnet- och direkt routing verifierades samt Spectre-NAT och Split DNS färdigställdes. | Fortsätt med PB-14 och en begränsad Headscale ACL-policy. |
| 2026-09-22 | LookingGlass-patchen analyserades, Metadata Service nåddes kontrollerat och två Storage-generationer verifierades. | Gå igenom resultaten med gruppen före eventuell inlämning. |
| 2026-09-24 | Allt flaggarbete sammanställdes med separat status för identifiering och Spectre-inlämning. | Granska dokumentet med gruppen och fortsätt därefter med SQLi-flaggan. |
| 2026-09-24, Workshop 3.5-4 | Headscales MagicDNS-post för `company-website` lades till, tjänstens reload-beteende analyserades och åtkomsten verifierades. | PR #72 är mergad; låt fler medlemmar verifiera DNS-posten. |
| 2026-09-24, CI/IAM | Återkommande Terraform-fel analyserades, projekt-IAM flyttades säkert från root till bootstrap och en fullständig GitHub Actions-deploy verifierades via WIF. PR #75 mergades, deployen från `main` lyckades och efterkontrollen gav `No changes`. | Följ upp den lokala OS Login-nyckeln inför framtida interaktiva K3s-kontroller. |

## Viktigt

Privata SSH-nycklar, service account keys, credentials, Terraform state och
planfiler får aldrig sparas eller commitas här.

## Gemensamma dokument

- [Projektets README](../../README.md)
- [Product Backlog](../../docs/product_backlog.md)
- [Gemensam anslutningsguide](../../docs/gemensam_anslutningsguide.md)
- [Blue Team-agenda 2026-09-08](../../docs/blue_team_agenda_2026-09-08.md)
- [Gemensam arbetssammanfattning 2026-09-08](../../docs/team_work_summary_2026-09-08.md)
- [Gemensam arbetssammanfattning 2026-09-14](../../docs/team_work_summary_2026-09-14.md)
- [Gemensam arbetssammanfattning 2026-09-15](../../docs/team_work_summary_2026-09-15.md)
- [Gemensam arbetssammanfattning 2026-09-17](../../docs/team_work_summary_2026-09-17.md)
- [Gemensam arbetssammanfattning 2026-09-24](../../docs/team_work_summary_2026-09-24.md)
- [Setup Summary 2026-09-07](../../docs/setup_summary_2026-09-07.md)
