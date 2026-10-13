# Gemensam arbetssammanfattning - 2026-09-08

## Syfte

Grupp 2 har fortsatt etablera och säkra sin Terraform-baserade infrastruktur i
GCP. Dagens fokus har varit agilt Blue Team-arbete, WIF, SSH-åtkomst,
säkerhetsanalys och spårbar dokumentation.

## Närvaro

Följande gruppmedlemmar var närvarande under arbetet den 2026-09-08:

- Jonny Nguyen (`itzmejonny92`)
- Fajk Zhupa (`fajkzhupa-chas`)
- Lars Törngren (`larstorngrenchas`)
- Tim Rundquist (`timrundquist`)
- Willi Broad Ngebi (`willibroadngebi-lab`)

Amin Mahamoud (`aminmahamoud-arch`) var inte närvarande.

## Gemensamma resultat

### Backlogg och dokumentation

- Produktbackloggen har kopplats till konkreta GitHub Issues.
- Statusmodellen `Open`, `In progress`, `Review` och `Done` används för att
  skilja på påbörjat, granskat och verifierat arbete.
- README beskriver hur Issues och backloggfilen hålls synkroniserade.
- Dagens Blue Team-agenda och säkerhetsbedömning har granskats och mergats.
- Issue #14 har stängts efter verifierad merge.
- Personliga dokumentationsytor har skapats för samtliga sex gruppmedlemmar.

### Workload Identity Federation

- Lärarens WIF-underlag anpassades till teamets verkliga projekt och repo.
- WIF-pool, GitHub-provider och service account-koppling skapades i GCP.
- GitHub Repository Variables för WIF konfigurerades.
- Deploy-workflowet bytte från statisk service account-nyckel till GitHub OIDC
  och WIF.
- WIF testades först från en branch och därefter genom en lyckad deploy från
  `main`.
- PR #18 godkändes av två medlemmar innan merge.

### SSH och åtkomst

- PR #19 lade till publika SSH-uppgifter för Lasse, Willi, Tim och Fajk.
- Jonny fanns redan i konfigurationen.
- Amin saknas fortfarande och läggs till när hans publika SSH-nyckel finns.
- Privata SSH-nycklar ska alltid stanna på respektive medlems dator.

### Riskanalys

- PR #21 lade till gruppens analys av risker med statiska Google Service
  Account-nycklar.
- Följande prioriterade risker är fortsatt öppna:
  - bred åtkomst till Terraform state via `allAuthenticatedUsers`
  - långlivad service account-nyckel som återstår efter WIF-migreringen
  - bred IAM-roll genom `roles/editor`
  - brandväggsregel som tillåter all trafik från `0.0.0.0/0`
  - ofullständig SSH-rutin och saknad medlem

### Spectre och praktisk säkerhetsanalys

- Team 2:s väg till den interna Spectre-plattformen verifierades via SSH,
  dynamisk port forwarding och en lokal SOCKS5-proxy.
- Plattformen identifierade anslutningen korrekt som Team 2 via IP-adressen
  `10.0.2.2`.
- En kvarlämnad lokal Terraform state-backup analyserades. Övningen visade att
  state kan avslöja känsliga värden även när filen ignoreras av Git.
- Den första flaggan identifierades genom analys och Base64-avkodning av ett
  värde i statefilen. Flaggvärdet dokumenteras inte i repot.
- Looking Glass analyserades och dess `target`-fält verifierades som sårbart
  för command injection genom ett neutralt test.
- Den andra flaggan identifierades med begränsade, läsande kommandon. Även detta
  flaggvärde utelämnas från dokumentationen.
- En personlig återanslutningsinstruktion skapades i Jonnys medlemsmapp så att
  anslutningen kan upprepas och felsökas på ett kontrollerat sätt.

Fynden visar två skilda risker: hemligheter som lever kvar i Terraform state
och osäker hantering av användarinmatning i ett shell-kommando. Rekommenderade
motåtgärder är säker fjärrlagring och begränsad åtkomst till state, sanering av
lokala statekopior, strikt inmatningsvalidering, kommandokörning utan shell och
minsta möjliga behörighet för tjänsten.

## Pull requests och verifiering

| PR | Resultat | Status |
| --- | --- | --- |
| [#17](https://github.com/itsx25-team2/kurs6-team2-infra/pull/17) | Produktbacklogg och arbetsflöde | Mergad |
| [#18](https://github.com/itsx25-team2/kurs6-team2-infra/pull/18) | Migrering till WIF | Mergad |
| [#19](https://github.com/itsx25-team2/kurs6-team2-infra/pull/19) | Fyra nya SSH-användare | Mergad |
| [#20](https://github.com/itsx25-team2/kurs6-team2-infra/pull/20) | Blue Team-agenda och backloggstatus | Mergad |
| [#21](https://github.com/itsx25-team2/kurs6-team2-infra/pull/21) | Riskanalys för service account-nycklar | Mergad |
| [#22](https://github.com/itsx25-team2/kurs6-team2-infra/pull/22) | Medlemsytor och avslutande backloggstatus | Mergad |
| [#23](https://github.com/itsx25-team2/kurs6-team2-infra/pull/23) | Uppdaterad närvaro i gruppens sammanfattning | Mergad |
| [#24](https://github.com/itsx25-team2/kurs6-team2-infra/pull/24) | Kompletterad riskdokumentation | Mergad |

Viktiga verifieringar:

- [WIF-test från member-branch](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34228835871)
- [Första verifierade WIF-deployen från main](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34231222239)
- [Deploy efter dokumentationsmerge](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34232416714)

## Bidrag som syns i repot

- Jonny: backlogg, agenda, WIF-implementering, verifiering, branchsynkning,
  issue-status, medlemsytor, proxyanslutning och praktisk flagganalys.
- Lars: SSH-ändringar, analys av risker med service account-nycklar och reviews.
- Fajk, Lars, Tim och Willi: granskningar och godkännanden av dagens pull
  requests.

Denna lista beskriver spårbara bidrag i GitHub och ska inte tolkas som en
fullständig närvarolista eller som att odokumenterat arbete saknas.

## Aktuell säkerhetsstatus

| Område | Status | Nästa kontroll |
| --- | --- | --- |
| WIF på `main` | Verifierad | Ta bort gammal nyckel och `GCP_SA_KEY`. |
| Terraform state-bucket | Risk kvarstår | Ta bort `allAuthenticatedUsers` och inför public access prevention. |
| CI/CD-behörighet | Risk kvarstår | Ersätt `roles/editor` med minsta nödvändiga roller. |
| Brandvägg | Risk kvarstår | Begränsa protokoll, portar och källor utan att bryta labben. |
| SSH-användare | Delvis klar | Lägg till Amin och dokumentera åtkomstrutinen. |
| Terraform state | Ny risk verifierad | Begränsa åtkomst och hantera lokala kopior säkert. |
| Looking Glass | Command injection verifierad | Dokumentera defensiva åtgärder och säker inmatningshantering. |
| Dokumentation | Pågående | Fortsätt uppdatera efter beslut och verifierade fynd. |

## Nästa gemensamma steg

1. Genomför kontrollerad borttagning av den gamla service account-nyckeln.
2. Stäng issue #9 och markera PB-03 som `Done` efter verifierad nyckelrensning.
3. Prioritera bucket-issues #6, #13 och #16 som nästa säkerhetsåtgärd.
4. Bedöm hur riskerna kring lokala statekopior ska följas upp i backloggen.
5. Dokumentera rekommenderade skydd mot command injection ur Blue Team-perspektiv.
6. Fortsätt därefter med IAM, brandvägg, SSH-rutin och dokumentation.

## Säkerhetsprincip

Gruppen arbetar iterativt: varje ändring görs i branch, verifieras med Terraform
och GitHub Actions, granskas av minst två medlemmar och mergas därefter till
`main`. Credentials, privata nycklar, state, planfiler och flaggvärden får inte
commitas.
