# Gemensam arbetssammanfattning - 2026-09-15

## Syfte

Team 2 genomförde Workshop 2 för Blue Team med fokus på GCP Metadata Service,
instansidentitet, Headscale, Tailscale och säkrare nätverksåtkomst. Arbetet
slutförde workshopens steg 5 för dagens deltagare och steg 6 för teamets
brandväggar.

## Närvaro

Följande gruppmedlemmar var närvarande:

- Jonny Nguyen (`itzmejonny92`)
- Fajk Zhupa (`fajkzhupa-chas`)
- Lars Törngren (`larstorngrenchas`)
- Tim Rundquist (`timrundquist`)
- Willi Broad Ngebi (`willibroadngebi-lab`)

Amin Mahamoud (`aminmahamoud-arch`) var frånvarande. PR #50 lade till en
sammanfattning och checklista så att han kan komma ikapp.

## Genomfört arbete

### Metadata och instansidentitet

- Metadata Service inspekterades från jumphosten med den obligatoriska
  `Metadata-Flavor: Google`-headern.
- OS Login och blockering av metadatahanterade SSH-nycklar verifierades.
- Jumphostens service account-identitet verifierades.
- Skillnaden mellan användarens lokala identitet och VM-instansens identitet
  demonstrerades mot Secret Manager utan att hemlighetens värde dokumenterades.

### Headscale och Tailscale

- Headscale `0.29.3` verifierades som aktivt på jumphosten.
- Serveradressen korrigerades till `https://team2.itsx25.chas-lab.dev` och
  health-endpointen svarade med HTTP 200.
- Tailscale installerades på jumphosten och deltagarnas arbetsstationer.
- Personliga Headscale-användare skapades för dagens fem deltagare.
- Deltagarnas enheter och jumphosten var online vid slutkontrollen.
- Den gemensamma anslutningsguiden utökades med installation, registrering,
  verifiering och felsökning för Headscale/Tailscale.

### Brandvägg och SSH

- Den första Headscale-regeln från PR #45 tillät port 8080 från hela internet.
- PR #49 begränsade port 8080 till utbildarens reverse proxy och port 22 till
  instruktörsnätet enligt workshopens steg 6.
- Terraform-kontroller och efterföljande deploy från `main` lyckades.
- De driftsatta brandväggsreglerna verifierades direkt i GCP.
- Headscale health och SSH via Tailnet fungerade efter driftsättningen.

### Backlog och dokumentation

- Issue #16 stängdes efter granskning av uniform bucket-level access.
- PB-12/issue #41 flyttades till `In progress`: Headscale fungerar och är
  dokumenterat, men installation och konfiguration är ännu inte reproducerbara.
- PB-13/issue #51 skapades för `primary`, subnet advertisement och routing.
- PB-14/issue #52 skapades för Headscale ACL-policy och verifiering av både
  tillåten och nekad trafik.
- Issue #15 behölls öppen eftersom Amin och bedömningen av minsta nödvändiga OS
  Login-roll återstår.

## Dagens pull requests

| PR | Bidrag | Resultat |
| --- | --- | --- |
| [#43](https://github.com/itsx25-team2/kurs6-team2-infra/pull/43) | Lasses tidigare arbetssammanfattningar | Mergad |
| [#44](https://github.com/itsx25-team2/kurs6-team2-infra/pull/44) | Komplettering av OS Login-listan | Mergad och driftsatt |
| [#45](https://github.com/itsx25-team2/kurs6-team2-infra/pull/45) | Första Headscale-regeln | Mergad, senare begränsad i #49 |
| [#46](https://github.com/itsx25-team2/kurs6-team2-infra/pull/46) | Willis Tailscale-dokumentation | Mergad |
| [#47](https://github.com/itsx25-team2/kurs6-team2-infra/pull/47) | Headscale-status i README | Mergad |
| [#48](https://github.com/itsx25-team2/kurs6-team2-infra/pull/48) | Status för workshopens steg 5 | Mergad, konfliktfragment rättade i #49 |
| [#49](https://github.com/itsx25-team2/kurs6-team2-infra/pull/49) | Tailnet-guide och säkra regler för steg 6 | Mergad, driftsatt och verifierad |
| [#50](https://github.com/itsx25-team2/kurs6-team2-infra/pull/50) | Sammanfattning och checklista för Amin | Mergad |

## Verifieringsbevis

- [Deploy efter PR #49](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34983968830)
- [Deploy efter PR #50](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34985255864)
- Headscale health: HTTP 200 efter brandväggsändringen.
- Tailscale: jumphosten och dagens fem medlemsenheter online.
- SSH: verifierad från Jonnys arbetsstation till jumphosten via Tailnet.

## Nästa steg

1. Synka påbörjat `primary`-arbete mot senaste `main` och hantera PB-13 utan
   att återinföra metadata-SSH eller öppna brandväggsregler.
2. Aktivera och verifiera annonserade rutter på klienterna.
3. Testa NAT jämfört med direkt routing och dokumentera käll-IP.
4. Planera och testa en begränsad ACL-policy i PB-14 med säker rollback.
5. Hjälp Amin med OS Login och personlig Tailnet-registrering.
6. Gör Headscale-installationen reproducerbar i PB-12.

## Säker dokumentation

Inga auth-id:n, privata SSH-nycklar, access tokens, Secret Manager-värden,
Terraform state eller andra credentials har lagts till i dokumentationen.
