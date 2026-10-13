# Gemensam arbetssammanfattning - 2026-09-14

## Syfte

Team 2 har följt upp tidigare Blue Team-ändringar och slutfört migreringen från
långlivade Google service account-nycklar till Workload Identity Federation
(WIF). Arbetet har även verifierat brandvägg, IAM och åtkomst till Terraform
state samt förbättrat gruppens gemensamma anslutningsdokumentation.

## Närvaro

Följande gruppmedlemmar var närvarande under arbetet den 2026-09-14:

- Jonny Nguyen (`itzmejonny92`)
- Fajk Zhupa (`fajkzhupa-chas`)
- Lars Törngren (`larstorngrenchas`)
- Willi Broad Ngebi (`willibroadngebi-lab`)

## Spårbara bidrag

GitHub-historiken visar följande spårbara bidrag den 2026-09-14:

- Jonny Nguyen (`itzmejonny92`): IAM-korrigering, bootstrap-apply,
  WIF-verifiering, nyckelrensning, issues och dokumentation.
- Lars Törngren (`larstorngrenchas`): mergad uppdatering av backlogg och
  riskdokumentation via PR #35.
- Fajk Zhupa (`fajkzhupa-chas`): OS Login och dedikerat service account för
  jumphosten via PR #39.
- Willi Broad Ngebi (`willibroadngebi-lab`): individuella sammanfattningar,
  proxy- och instansanteckningar samt dokumentation av Headscale via PR #40.
- Lars och Willi granskade PR #39. Jonny och Lars granskade PR #40.

Pull request-granskningar och muntliga bidrag kan finnas utan att framgå av
commit-historiken.

## Genomfört arbete

### WIF och nyckelrensning

- WIF verifierades först från `member/itzmejonny92` och därefter från `main`.
- GitHub-hemligheten `GCP_SA_KEY` verifierades som borttagen.
- Två kvarvarande användarhanterade nycklar inaktiverades.
- En deploy från `main` lyckades medan nycklarna var inaktiverade.
- Nycklarna raderades permanent.
- En avslutande deploy från `main` lyckades efter raderingen.
- Issue #9 stängdes med verifieringsbevis.

### IAM

- CI/CD-kontot saknade rätt att skapa och ta bort brandväggsregler.
- En egen roll med tre brandväggsbehörigheter kunde inte skapas eftersom
  kurskontot saknar `iam.roles.create` i det delade projektet.
- Efter uttrycklig säkerhetsbedömning användes den inbyggda rollen
  `roles/compute.securityAdmin` via PR #36.
- Rollen är bredare än önskat och ska omprövas om utbildaren kan skapa en
  smalare projektspecifik roll.

### Brandvägg

- Den gamla regeln `team2-allow-traffic`, som tillät all trafik från
  `0.0.0.0/0`, togs bort.
- `team2-allow-ssh` tillåter TCP 22 till jumphosten.
- `team2-allow-internal` tillåter intern trafik från `10.0.2.0/24` till
  resurser med Team 2:s mål-taggar.
- Issue #8 stängdes efter kontroll av de aktiva reglerna i GCP.

### Terraform state

- Bootstrap-apply tog bort den tidigare publika
  `allAuthenticatedUsers`-bindningen.
- Live IAM-policy verifierades utan någon publik medlem.
- `team2-cicd` har explicit `roles/storage.objectAdmin` för state-bucketen.
- `public_access_prevention` återstår som separat uppföljning i issue #16.

### Dokumentation

- En gemensam anslutningsguide skapades för Git, personlig GCP-inloggning,
  Terraform, SSH, SOCKS5 och labbsidan.
- Guiden förbjuder lokala service account-nycklar och förklarar att CI/CD
  använder WIF.
- README, produktbacklogg och Jonnys personliga README uppdaterades.

### OS Login och jumphost

- PR #39 ersatte metadatahanterade SSH-nycklar med GCP OS Login.
- Jumphosten blockerar projektets metadata-nycklar och använder
  `enable-oslogin=TRUE`.
- Dennis, Fajk, Jonny, Lars och Willi har `roles/compute.osAdminLogin` på
  instansen. Tim och Amin saknas och följs upp i återöppnade issue #15.
- Ett dedikerat `team2-jumphost` service account är kopplat till VM:n med
  `cloud-platform`-scope. Kontot hade inga projektroller vid livekontrollen.
- Teamet behöver bedöma vilka användare som verkligen behöver administrativ
  OS Login i stället för vanlig OS Login.

### Willis dokumentation och Headscale

- PR #40 lade till Willis individuella sammanfattningar för den 8 och 14
  september.
- Willi dokumenterade felsökning av VM-start, SSH-tunnel, proxy och åtkomst till
  Spectre-plattformen.
- Willi dokumenterade en manuell installation av Headscale v0.29.3 på
  jumphosten. Installationen kunde inte verifieras oberoende vid denna
  uppföljning eftersom SSH-nyckeln inte var upplåst.
- Issue #41 skapades för att verifiera version och tjänstestatus samt göra
  installation, återställning och säker konfiguration reproducerbar.

## Pull requests och verifieringar

| Underlag | Resultat |
| --- | --- |
| [PR #34](https://github.com/itsx25-team2/kurs6-team2-infra/pull/34) | Första försöket med minimal brandväggsroll |
| [PR #35](https://github.com/itsx25-team2/kurs6-team2-infra/pull/35) | Backlogg och riskdokumentation |
| [PR #36](https://github.com/itsx25-team2/kurs6-team2-infra/pull/36) | Tillgänglig inbyggd IAM-roll efter projektbegränsning |
| [PR #37](https://github.com/itsx25-team2/kurs6-team2-infra/pull/37) | Gemensam anslutningsguide och säkerhetsdokumentation |
| [PR #38](https://github.com/itsx25-team2/kurs6-team2-infra/pull/38) | Synkroniserad backlogg efter slutkontroll |
| [PR #39](https://github.com/itsx25-team2/kurs6-team2-infra/pull/39) | OS Login och jumphost-service account |
| [PR #40](https://github.com/itsx25-team2/kurs6-team2-infra/pull/40) | Willis arbets- och instansdokumentation |
| [Branch-deploy](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34824365603) | WIF och brandväggsändring lyckades |
| [Deploy efter merge](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34825510839) | `main` lyckades |
| [Test med inaktiverade nycklar](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34825821057) | WIF fungerade utan användbara nycklar |
| [Sluttest efter radering](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34826524653) | WIF fungerade utan användarhanterade nycklar |
| [Deploy efter OS Login](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34831901973) | PR #39 applicerades framgångsrikt från `main` |
| [Deploy efter PR #40](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34861398773) | Senaste `main` verifierades framgångsrikt |

## Aktuell säkerhetsstatus

| Område | Status | Uppföljning |
| --- | --- | --- |
| WIF | Done | Fortsätt använda kortlivad autentisering i Actions. |
| Service account-nycklar | Done | Skapa inte nya långlivade nycklar. |
| Brandvägg | Done för aktuell issue | Ompröva SSH-källan när en stabil tillåten CIDR finns. |
| State-bucket | Delvis klar | Följ upp public access prevention i issue #16. |
| CI/CD-IAM | Fungerande med känd avvägning | Be utbildaren om möjlighet till smalare custom role. |
| OS Login | In progress | Lägg till avsedda medlemmar och minimera administrativ åtkomst i issue #15. |
| Anslutningsrutin | Uppdaterad för OS Login | Låt medlemmarna testa guiden och rapportera oklarheter. |
| Headscale | Dokumenterad men inte oberoende verifierad | Följ upp reproducerbarhet och säker konfiguration i issue #41. |

## Nästa steg

1. Komplettera och minimera OS Login-behörigheterna i issue #15.
2. Slutför granskningen av bucket-issues #6 och #16.
3. Slutför rutinen för GitHub Actions secrets och variables i issue #10.
4. Verifiera och dokumentera Headscale enligt issue #41.
5. Låt gruppmedlemmarna testa den uppdaterade anslutningsguiden.

## Säkerhetsprincip

Inga privata SSH-nycklar, service account-nycklar, credentials, Terraform
state, planfiler eller flaggvärden har lagts till i dokumentationen.
