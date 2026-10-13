# Product Backlog

Denna backlog används för grupp 2:s Blue Team-arbete i infra-repot.

Syftet är att samla säkerhetsrisker, förbättringar och dokumentationsbehov på ett spårbart sätt. GitHub Issues används för det praktiska arbetet, medan denna fil ger en sammanfattad översikt för gruppen och utbildaren.

## Statusförklaring

| Status | Betydelse |
| --- | --- |
| Open | Behöver göras eller undersökas. |
| In progress | Någon arbetar aktivt med punkten. |
| Review | Ändring finns i pull request och behöver granskas. |
| Done | Klart och verifierat. |

## Backlog

| ID | GitHub Issue | Titel | Prioritet | Status | Koppling |
| --- | --- | --- | --- | --- | --- |
| PB-01 | [#1](https://github.com/itsx25-team2/kurs6-team2-infra/issues/1) | Verifiera PR-flöde och CI-checks | Hög | Done | GitHub Actions, branch protection |
| PB-02 | [#6](https://github.com/itsx25-team2/kurs6-team2-infra/issues/6), [#13](https://github.com/itsx25-team2/kurs6-team2-infra/issues/13) | Begränsa åtkomst till Terraform state-bucket | Hög | In progress | `bootstrap/main.tf` |
| PB-03 | [#9](https://github.com/itsx25-team2/kurs6-team2-infra/issues/9) | Ersätt `GCP_SA_KEY` med Workload Identity Federation | Hög | Done | `.github/workflows/deploy.yml`, `bootstrap/` |
| PB-04 | [#7](https://github.com/itsx25-team2/kurs6-team2-infra/issues/7) | Minska behörighet för CI/CD service account | Hög | Done | `bootstrap/main.tf`, IAM |
| PB-05 | [#8](https://github.com/itsx25-team2/kurs6-team2-infra/issues/8) | Begränsa firewall-regeln från `0.0.0.0/0` | Hög | Done | `main.tf`, nätverk |
| PB-06 | [#12](https://github.com/itsx25-team2/kurs6-team2-infra/issues/12) | Dokumentera säker hantering av Terraform state och credentials | Medel | Done | `docs/`, `.gitignore` |
| PB-07 | [#11](https://github.com/itsx25-team2/kurs6-team2-infra/issues/11) | Granska Lasses föreslagna bucket-fix | Hög | Done | `member/larstorngrenchas` |
| PB-08 | [#10](https://github.com/itsx25-team2/kurs6-team2-infra/issues/10) | Skapa tydlig rutin för secrets och variabler i GitHub Actions | Medel | In progress | GitHub Actions, repo settings |
| PB-09 | [#15](https://github.com/itsx25-team2/kurs6-team2-infra/issues/15) | Kontrollera SSH-användare och åtkomstmodell | Hög | In progress | `variables.tf`, OS Login, Compute IAM |
| PB-10 | [#14](https://github.com/itsx25-team2/kurs6-team2-infra/issues/14) | Dokumentera dagens Blue Team-beslut efter workshop | Medel | Done | `docs/blue_team_agenda_2026-09-08.md` |
| PB-11 | [#16](https://github.com/itsx25-team2/kurs6-team2-infra/issues/16) | Granska och dokumentera uniform bucket-level access | Medel | Done | `bootstrap/main.tf`, GCS IAM |
| PB-12 | [#41](https://github.com/itsx25-team2/kurs6-team2-infra/issues/41) | Dokumentera och gör Headscale-installationen reproducerbar | Medel | In progress | Jumphost, Headscale, `docs/` |
| PB-13 | [#51](https://github.com/itsx25-team2/kurs6-team2-infra/issues/51) | Aktivera `primary` och verifiera subnet routing | Hög | Done | `main.tf`, Headscale, routing |
| PB-14 | [#52](https://github.com/itsx25-team2/kurs6-team2-infra/issues/52) | Inför och verifiera Headscale ACL-policy | Hög | In progress | Headscale, ACL, åtkomsttest |

## Första Prioritering

Nuvarande prioritering är PB-02, PB-08, PB-09, PB-12 och PB-14 eftersom de
berör åtkomst, autentisering, reproducerbar drift och nästa workshopsteg.

PB-02 har två GitHub issues eftersom Lasse också skapade en mer konkret observation om `allAuthenticatedUsers` i issue #13. Den bör hanteras tillsammans med PB-02/PB-07 i reviewarbetet.

PB-11 avslutades efter att teamet konstaterat att
`uniform_bucket_level_access = true` är en säkerhetsförbättring som flyttar
åtkomststyrningen till IAM. Frågan om explicit `public_access_prevention` kan
följas upp separat från denna avslutade granskning.

## Statusuppdatering 2026-09-08

- PB-03: WIF infördes via [PR #18](https://github.com/itsx25-team2/kurs6-team2-infra/pull/18), godkändes av två granskare och verifierades genom en [lyckad deploy från `main`](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34231222239). Punkten är fortfarande `In progress` tills service account-nyckeln och `GCP_SA_KEY` har tagits bort och verifierats.
- PB-08: Repository Variables för WIF är konfigurerade. En fullständig rutin för secrets och variables behöver fortfarande dokumenteras.
- PB-09: SSH-användarna Jonny, Lasse, Willi, Tim och Fajk finns i `terraform.tfvars`. Amin saknas fortfarande och den gemensamma åtkomstrutinen återstår.
- PB-10: Dagens agenda och säkerhetsbedömning mergades till `main` via [PR #20](https://github.com/itsx25-team2/kurs6-team2-infra/pull/20) efter gruppens granskning.

## Statusuppdatering 2026-09-10

- PB-03: Borttagningen av den långlivade service account-nyckeln och dess
  känsliga Terraform-output är förberedd för granskning. Bootstrap-konfigurationen
  är validerad och planen visar `0 to add, 0 to change, 1 to destroy`, där den
  enda resursen som tas bort är `google_service_account_key.cicd`. Punkten
  markeras som `Done` först efter mergad PR, genomförd bootstrap-apply, borttagen
  GitHub-hemlighet `GCP_SA_KEY` och en ny lyckad WIF-deploy från `main`.
- PB-02, PB-04 och PB-05: Kodändringarna för explicit stateåtkomst,
  least privilege och begränsade brandväggsregler är mergade. WIF når nu
  state-backenden, men apply stoppas eftersom `compute.networkAdmin` saknar
  `compute.firewalls.create`, `compute.firewalls.delete` och
  `compute.firewalls.update`. En snäv projektspecifik roll med endast dessa tre
  rättigheter är förberedd för granskning. Punkterna står kvar i `Review` tills
  bootstrap har applicerats och en deploy från `main` är verifierad.

## Statusuppdatering 2026-09-14

- PB-03 är `Done`. `GCP_SA_KEY` saknas i GitHub Secrets och alla
  användarhanterade nycklar för `team2-cicd` har inaktiverats, testats och
  raderats. En avslutande [deploy från `main`](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34826524653)
  lyckades med WIF efter raderingen.
- PB-04 är `Done`. Den tidigare rollen `roles/editor` är borttagen. CI/CD har
  separata Compute-roller och explicit åtkomst till state-bucketen. Projektet
  tillät inte en egen minimal brandväggsroll, så `roles/compute.securityAdmin`
  används efter dokumenterad säkerhetsbedömning. Rollen bör omprövas om
  utbildaren kan tillhandahålla en smalare roll.
- PB-05 är `Done`. Den breda regeln `team2-allow-traffic` är borttagen. Endast
  SSH på TCP 22 till jumphosten och intern trafik från `10.0.2.0/24` finns i
  Team 2:s brandväggsregler.
- PB-09 markerades först som `Done` efter den metadatahanterade SSH-rutinen. Den
  har återgått till `In progress` efter OS Login-migreringen i PR #39. Tim och
  Amin saknas i `os_admin_users`, och behovet av administrativ OS Login ska
  bedömas. Issue #15 har återöppnats.
- PB-07 är `Done`. Lasses ändring i PR #27 klarade kontroller, fick två
  approvals, mergades och verifierades i GCP. Issue #11 är stängt.
- PB-02 är fortsatt `In progress`. Den publika `allAuthenticatedUsers`-bindningen
  är borttagen och verifierad, men åtkomsten via projektets grundroller behöver
  fortfarande bedömas i issue #6. `public_access_prevention` följs upp separat
  i PB-11/issue #16.
- Dokumentations-PR #37 mergades och efterföljande
  [deploy från `main`](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34828593323)
  lyckades.
- PR #39 migrerade jumphosten till OS Login, blockerade metadatahanterade
  SSH-nycklar och kopplade ett dedikerat service account till VM:n. Efterföljande
  [deploy från `main`](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34831901973)
  lyckades. Livekontrollen visade att service accountet inte har några
  projektroller.
- PR #40 lade till Willis arbetsanteckningar om proxy, VM-start och en manuellt
  installerad Headscale-version. Installationen följs upp som PB-12/issue #41
  eftersom driftstatus, installationskälla och reproducerbarhet behöver
  verifieras och dokumenteras.

## Statusuppdatering 2026-09-15

- PR #43 lade till Lasses individuella arbetssammanfattningar.
- PR #44 kompletterade `os_admin_users` med Tim. Amin och bedömningen av minsta
  nödvändiga OS Login-roll återstår i PB-09/issue #15.
- PR #45-#48 införde Headscale-regeln och dokumenterade Headscale, DNS och
  Tailscale på jumphosten. Den första regeln var för bred och korrigerades i
  PR #49.
- PR #49 slutförde workshopens steg 5 för dagens deltagare och steg 6 för
  brandväggen. Efter lyckad deploy verifierades de avsedda källnäten,
  Headscale health och SSH via Tailnet.
- Jonny, Lasse, Fajk, Tim och Willibroad hade personliga Headscale-användare och
  online-enheter vid slutkontrollen. Amin registreras senare.
- PR #50 lade till en tvådagarssammanfattning och återanslutningschecklista för
  Amin.
- PB-11/issue #16 är `Done` efter dokumenterad bedömning av uniform
  bucket-level access.
- PB-12 är `In progress`: installation och drift är verifierade och
  anslutningsflödet är dokumenterat, men serverinstallationen och
  `config.yaml` behöver fortfarande göras reproducerbara.
- PB-13/issue #51 och PB-14/issue #52 skapades för workshopens steg 7 och 8.
  Ett befintligt medlemsutkast för `primary` måste synkas med senaste `main`
  och får inte återinföra metadatahanterade SSH-nycklar eller öppna
  brandväggsregler.

## Statusuppdatering 2026-09-17

- PB-13 är `Done`. PR #54 aktiverade `team2-primary` som `e2-micro` utan extern
  IP och med OS Login. PR #55 lade till en begränsad brandväggsregel för direkt
  Tailnet-trafik, och PR #56 gjorde Spectre-NAT persistent och idempotent.
- Subnet-rutterna `10.0.2.0/24` och `10.0.0.2/32` är annonserade, godkända och
  aktiva. Klientåtkomst till `primary` verifierades med ping och SSH.
- NAT-jämförelsen visade först jumphostens `10.0.2.2` och därefter klientens
  riktiga Tailnet-IP `100.64.0.3` när subnet-router-SNAT stängts av.
- `dnsmasq` installerades som proxy mot GCP DNS och Headscale Split DNS
  konfigurerades för `itsx25.chas-lab.dev`. Spectre verifierades via IP och DNS.
- Varje medlem behöver fortfarande aktivera och verifiera `accept-routes` på
  sin egen klient. Det blockerar inte den gemensamma PB-13-leveransen.
- PB-14 är `In progress`. PR #58 lade till och aktiverade en policy där alla
  registrerade teammedlemmar ingår i `group:admin`. Detta är ett medvetet
  kurslabb-beslut för smidigt samarbete, inte en least-privilege-modell.
- Den första policyversionen saknade avslutande `@` på användarnamnen och fick
  Headscale `0.29.3` att krascha i en restart-loop. Policyn korrigerades,
  validerades med `headscale policy check` och Headscale health verifierades
  därefter med HTTP 200.
- Tillåten trafik från Jonny till `primary` och Spectre fungerar. Test av nekad
  trafik från en andra användare och dokumenterad rollback återstår innan
  PB-14 kan markeras `Done`.

## Statusuppdatering 2026-09-24 - CI och IAM

- Återkommande deployfel spårades till att det begränsade CI-kontot saknade
  rättighet att läsa projektets IAM-policy för
  `google_project_iam_member.iap_tunnel_access`.
- Teamet valde att behålla least privilege och flytta projekt-IAM till
  `bootstrap` i stället för att ge CI rollen Project IAM Admin.
- State-migreringen genomfördes utan resursborttagning. Root och bootstrap ger
  båda `No changes`, och samtliga sex IAP-medlemmar finns kvar.
- Deploy-workflowen begränsas till relevanta root-Terraformfiler, serialiseras
  och väntar upp till fem minuter på state-låset.
- PR-kontrollen validerar både root och bootstrap.
- En riktig WIF-körning från `member/itzmejonny92` lyckades med commit
  `f313d7c`. Initiering, validering, plan och apply slutfördes via WIF i
  [GitHub Actions #36023608975](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/36023608975).
- CI/IAM-rättningen mergades via [PR #75](https://github.com/itsx25-team2/kurs6-team2-infra/pull/75).
- Efterföljande deploy från `main` lyckades i
  [GitHub Actions #36051272258](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/36051272258).
- En efterkontroll gav `No changes` för både root och bootstrap. GCP-instanser,
  intern DNS och applikationens health endpoint verifierades som friska.

## Arbetsflöde

1. Välj en backlogpunkt.
2. Skapa eller använd motsvarande GitHub Issue.
3. Arbeta från egen member-branch.
4. Gör en liten, tydlig ändring.
5. Kör:

```bash
terraform fmt -recursive
terraform validate
```

6. Pusha branchen.
7. Skapa pull request mot `main`.
8. Låt två personer granska och approve:a.
9. Uppdatera backlogstatus när ändringen är mergad.
