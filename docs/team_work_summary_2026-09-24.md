# Team 2 - arbetssammanfattning 2026-09-24

## Omfattning

Dagens infrastrukturdel av Workshop 3.5-4 fokuserade på att ge
`company-website` ett internt DNS-namn i Team 2:s Tailnet. Arbetet genomfördes
stegvis med skrivskyddade kontroller före varje serverändring.

## Utgångsläge

- Headscale kördes som en aktiv `systemd`-tjänst på `team2-jumphost`.
- Den aktiva konfigurationen låg i `/etc/headscale/config.yaml`.
- MagicDNS var redan aktiverat med `team2.arpa` som basdomän.
- Teamets primary-server hade den privata adressen `10.0.2.3`.
- `extra_records` innehöll ännu ingen post för applikationen.

## Genomfört arbete

1. GCP- och OS Login-åtkomst till jumphosten verifierades via IAP med Jonnys
   personliga SSH-nyckel.
2. Headscales DNS-block lästes och validerades med `headscale configtest`.
3. En tidsstämplad backup av konfigurationen skapades före ändringen.
4. Följande interna A-post lades till:

   ```text
   company-website.team2.arpa -> 10.0.2.3
   ```

5. Headscale startades om och kontrollerades som aktiv.
6. Den gemensamma anslutningsguiden kompletterades med verifierings- och
   felsökningssteg.

## Viktig observation

`systemctl reload headscale` skickade `SIGHUP`, men loggen visade att den
installerade Headscale-versionen endast läste om ACL-policyn. För att läsa in
ändringen i `extra_records` krävdes därför en fullständig omstart av
Headscale-tjänsten.

## Verifiering

Efter omstart verifierades posten från Jonnys WSL-klient:

```text
company-website.team2.arpa -> 10.0.2.3
2 paket skickade, 2 mottagna, 0 procent paketförlust
```

Senare verifierades även HTTP-routning till applikationen via samma namn med
status `200` efter att Ingress hade konfigurerats i applikationsrepot.

## Säkerhet och återställning

- Inga tokens, privata nycklar eller credentials dokumenterades.
- Serverkonfigurationen validerades före omstart.
- En tidsstämplad backup sparades på jumphosten för återställning.
- DNS-posten pekar endast mot primary-serverns privata IP och kräver Tailnet-
  samt subnet-åtkomst.

## Git-status

- Commit `8dc6f19` dokumenterar DNS-posten och felsökningen i den gemensamma
  anslutningsguiden.
- Ändringen mergades till `main` via PR #72 i mergecommit `eddbade`.

## Uppföljning

- Varje medlem bör verifiera att Tailscale DNS och subnet-rutter är aktiverade.
- Testa `company-website.team2.arpa` från minst en ytterligare medlems klient.
- Flytta på sikt den manuella Headscale-konfigurationen till en reproducerbar
  och versionshanterad installationsrutin.

Applikationens Ingress-, image- och Cosign-arbete dokumenteras i det separata
[`company-website`](https://github.com/itsx25-team2/company-website)-repot.

## CI/IAM-uppföljning

Återkommande röda `Deploy Infrastructure`-körningar analyserades. PR-kontrollerna
var gröna, men deploymenten stoppades i `terraform plan` med HTTP `403` när
det begränsade CI-kontot försökte läsa projektets IAM-policy.

Projektets IAP-bindningar flyttades därför till den privilegierade
bootstrap-konfigurationen i stället för att ge `team2-cicd` en bred
Project IAM Admin-roll.

Migreringen verifierades i följande ordning:

1. Root-planen visade endast sex `forget` och `0 destroy`.
2. Bootstrap-planen visade sex befintliga IAP-medlemmar som skulle tas under
   bootstrap-förvaltning och `0 destroy`.
3. Bootstrap applicerades först och en ny plan gav `No changes`.
4. Root-planen applicerades därefter med
   `0 added, 0 changed, 0 destroyed`.
5. Root-state innehåller inte längre projekt-IAM, medan bootstrap-state
   innehåller samtliga sex Team 2-bindningar.
6. Slutliga planer för både root och bootstrap gav `No changes`.
7. Tailnet, MagicDNS och `company-website.team2.arpa` verifierades efter
   migreringen; webbplatsen svarade med HTTP `200`.

Deploy-workflowen har även förberetts med path-filter, serialiserad körning och
fem minuters väntetid på Terraform-låset.

Den första manuella branchkörningen använde den äldre committen `def2be9` och
misslyckades därför som väntat med HTTP `403` när root-konfigurationen försökte
återskapa projektets IAP-IAM. Efter att rättningen pushats genomfördes en ny
manuell körning från `member/itzmejonny92` med commit `f313d7c`.

Den nya körningen slutfördes framgångsrikt:

- GitHub Actions autentiserade mot GCP med WIF.
- Terraform initiering, validering, plan och apply gick igenom.
- Workflowet använde rätt commit och rätt medlemsbranch.
- Ingen långlivad service account-nyckel användes.
- Körningen finns i [GitHub Actions #36023608975](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/36023608975).

Ändringen mergades till `main` via [PR #75](https://github.com/itsx25-team2/kurs6-team2-infra/pull/75).
Den efterföljande [deployen från `main`](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/36051272258)
använde mergecommit `20b4693` och slutfördes framgångsrikt.

## Efterkontroll efter merge

Efter godkänd merge genomfördes en separat health check:

- root-konfigurationen validerades och gav `No changes`,
- bootstrap-konfigurationen validerades och gav `No changes`,
- samtliga sex IAP-bindningar lästes från bootstrap-state,
- `team2-jumphost` och `team2-primary` rapporterades som `RUNNING` i GCP,
- Tailnet nådde jumphosten via DERP,
- `company-website.team2.arpa` löstes till `10.0.2.3`,
- `/healthz` svarade HTTP `200` med `db=connected`, och
- webbplatsens startsida svarade HTTP `200`.

En separat interaktiv K3s-kontroll via SSH stoppades av lokal OS Login-
nyckelautentisering. Detta ändrade ingenting i driftmiljön; K3s-rollouten är
verifierad genom company-repots gröna deploylogg och fungerande live-endpoints.

## Gruppens CTF-resultat

Lars Törngren löste dagens sista flagga och dokumenterade arbetsgången i
[sin CTF-anteckning](../members/larstorngrenchas/flags_lt_2026-09-24.md).

Lasse hade tidigt hypotesen att flaggan fanns i lösenordsfältet för användaren
`flag`. Efter flera manuella försök och ytterligare vägledning använde han
`sqlmap` i den godkända kursmiljön med de tilldelade uppgifterna för
`dev`-användaren. Genom att lista databastabellerna upptäckte han att den
förväntade tabellen hade bytt namn till `legacy_users`. Innehållet bekräftade
hypotesen och den sista flaggan kunde identifieras.

Själva flaggvärdet dokumenteras inte i den gemensamma sammanfattningen.
