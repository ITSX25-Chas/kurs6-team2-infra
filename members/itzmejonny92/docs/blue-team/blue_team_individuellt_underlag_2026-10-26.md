# Jonny Nguyen: individuellt examinationsunderlag

Ett committillhörande namn visar spårbarhet men bevisar inte ensamt vem som
fattade varje beslut eller gjorde alla delar av ett grupparbete.

## Projektlänkar

- [Team 2: infrastruktur](https://github.com/ITSX25-Chas/kurs6-team2-infra)
- [Team 2: Company Website](https://github.com/ITSX25-Chas/team2-company-website)
- [Teamets säkerhetsrapport i Markdown](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)
- [Teamets säkerhetsrapport som PDF](../../docs/blue_team_sakerhetsrapport_2026-10-26.pdf)
- [Separat AI-redogörelse](blue_team_ai_redogorelse.md)

## Mina bidrag

Under Blue Team-fasen arbetade jag tillsammans med gruppen med att etablera,
säkra, testa och dokumentera vår miljö. Nedan är exempel som kan följas i
Git-historiken. Jag skiljer mellan det jag bidrog till och beslut eller
verifieringar som gruppen genomförde tillsammans.

| Område | Spårbart bidrag | Förklaring |
| --- | --- | --- |
| Infrastruktur och säker hantering | [Grundläggande uppsättning](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/cdb284b) och [förbättrad gitignore](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/61941e9). | Hur Terraform beskriver miljön och varför state och credentials inte ska committas. |
| WIF och nyckelhantering | [WIF-konfiguration](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/64ffba5) och [borttagning av tidigare service-account-nyckel](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/d327e82). | Skillnaden mellan federerad kortlivad autentisering och en långlivad nyckel samt varför behörigheter fortfarande behöver begränsas. |
| CI-behörighet och IAM | [Separering av privilegierad IAM från deploy](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/f313d7c); [dokumenterad verifiering](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/5bd6d2a). | Varför CI inte fick generell projektadministration och vilka avvägningar som kvarstod. |
| Nätverk och åtkomst | [Begränsning av SSH](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/502e833) och [OS Login på primary](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/76c1ec8). | Skillnaden mellan nätverksåtkomst och identitetsbehörighet samt vad som hör till den tidigare miljön. |
| Image-säkerhet och DevSecOps | [Signering och verifiering av images](https://github.com/ITSX25-Chas/team2-company-website/commit/94acaa2) samt [dokumenterad policyverifiering](https://github.com/ITSX25-Chas/team2-company-website/commit/89e7ada). | Hur digest, signering och policy kompletterar varandra och vad kontrollerna inte bevisar. |
| Applikationshärdning | [Autentisering och signaturförhandsvisning](https://github.com/ITSX25-Chas/team2-company-website/commit/fecfc53) samt [säkerhetstester och branchkontroller](https://github.com/ITSX25-Chas/team2-company-website/commit/47eb0bb). | Hur parametriserade frågor, lösenordsverifiering, begränsad rendering och tester minskar risk. |
| Analys och dokumentation | [MITRE/TI/TLP för infra](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/f052132), [MITRE/TI/TLP för appen](https://github.com/ITSX25-Chas/team2-company-website/commit/acba50f) och [verifiering av profilflödet](https://github.com/ITSX25-Chas/team2-company-website/commit/bf8e113). | Hur en ATT&CK-koppling motiveras, skillnaden mellan labb och faktisk incident samt begränsningar i livekontroller. |

Flytten till Comerit och IAP ingår i Blue Team-fasens slutliga läge men bör
inte förväxlas med den ursprungliga miljön under vecka 4–7. Exempel är
[IAP-deploy](https://github.com/ITSX25-Chas/team2-company-website/commit/035fe53)
och [K3s-bootstrap](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/b0296c5).

## AI-redogörelse

Den separata [AI-redogörelsen](blue_team_ai_redogorelse.md) beskriver hur
Codex användes, hur förslag verifierades och vilka professionella begränsningar
som tillämpades.
