# Team 2 - arbetssammanfattning 2026-10-05

## Närvaro

- Närvarande: Jonny Nguyen, Fajk Zhupa, Lars Torngren och Wilibroad Ngebi.
- Frånvarande: Tim Rundquist och Amin Mahamoud.

## Dagens mål

Dagens arbete fokuserade på Workshop: MITRE ATT&CK-mappning av fynd från
vecka 4-7, Threat Intelligence-analys och TLP-klassificering. Målet var att
göra gruppens tidigare tekniska arbete lättare att förstå, följa upp och
presentera för utbildaren.

## Genomfört arbete

1. Infra-repots dokumentation, backlog, Terraform-konfiguration, mergehistorik
   och tidigare arbetssammanfattningar gick igenom.
2. Verifierade historiska risker och kontroller sammanställdes i en ny,
   pedagogisk MITRE/TI/TLP-rapport.
3. Rapporten skiljer mellan:
   - åtgärdade och verifierade kontroller,
   - delvis åtgärdade risker,
   - öppet förbättringsarbete, och
   - kurslabbets fynd, som inte är bevis för en incident i Team 2:s driftmiljö.
4. WIF, CI/CD-behörigheter, brandvägg, Terraform state, Storage, OS Login och
   Headscale analyserades ur ett defensivt perspektiv.
5. TLP bedömdes utifrån att infra-repot är publikt. Den publicerbara
   sammanställningen är därför TLP:CLEAR, medan råa loggar, state, tokens och
   åtkomstdetaljer ska hållas utanför Git.
6. En efterföljande granskning av PR #78 bekräftade Trivy/Discord-arbetet från
   2026-10-01: Secret, RBAC, CronJob och testat larmflöde i K3s. Informationen
   berör främst company-website-repots supply-chain-dokumentation och ändrar
   inte dagens infra-riskstatus.

## Resultat

- Den nya sammanställningen finns i
  [MITRE ATT&CK, Threat Intelligence och TLP - infra](mitre_ti_tlp_summary_2026-10-05.md).
- PB-02, PB-09, PB-12 och PB-14 är fortsatt de viktigaste öppna
  förbättringsområdena.
- Kurslabbets LookingGlass- och flaggfynd dokumenteras som lärdomar för
  hotmodellering och försvar, utan flaggvärden, tokens eller
  reproduktionsinstruktioner.
- Ingen infrastruktur, IAM-behörighet, brandvägg eller Headscale-konfiguration
  ändrades under dagens dokumentationsarbete.

## Nästa steg

- Låt gruppen granska MITRE/TI/TLP-sammanställningen innan den commitas.
- Använd samma struktur för nya säkerhetsfynd: evidens, ATT&CK-koppling,
  status, tilltro, TLP och rekommenderad kontroll.
- Fortsätt arbetet med state-bucket, OS Login och reproducerbar
  Headscale-installation enligt backloggen.

## Säkerhet

Inga flaggvärden, lösenord, tokens, nycklar, råa statefiler eller interna
åtkomstdetaljer har lagts i dokumentationen.
