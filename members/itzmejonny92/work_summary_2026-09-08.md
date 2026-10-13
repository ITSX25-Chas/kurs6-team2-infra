# Individuell arbetssammanfattning - Jonny Nguyen - 2026-09-08

## Fokus

Dagens arbete har fokuserat på att etablera ett spårbart Blue Team-arbete,
införa Workload Identity Federation (WIF), verifiera ändringarna före merge och
hålla GitHub Issues, backlogg och dokumentation synkroniserade.

## Genomfört arbete

### Backlogg och arbetssätt

- Skapade en produktbacklogg kopplad till GitHub Issues.
- Dokumenterade hur GitHub Issues används för det dagliga arbetet och hur
  backloggfilen uppdateras manuellt.
- Skapade och uppdaterade statuskommentarer i berörda issues.
- Prioriterade state-bucket, WIF, IAM, brandvägg och SSH utifrån säkerhetsrisk.
- Dokumenterade dagens Blue Team-agenda och säkerhetsbedömning.
- Stängde issue #14 efter att dokumentationen hade granskats och mergats.

### Workload Identity Federation

- Granskade lärarens `wif.patch` och upptäckte att den innehöll värden från en
  testmiljö som inte kunde appliceras direkt.
- Anpassade konfigurationen till projektet `itsx25-lab`, team 2 och repot
  `Itzmejonny92/kurs6-team2-infra`.
- Lade till en WIF-pool, en GitHub OIDC-provider och en begränsad koppling till
  CI/CD-service accountet.
- Lade till GitHub Repository Variables för WIF-provider och service account.
- Ändrade GitHub Actions från statisk `GCP_SA_KEY` till kortlivad
  OIDC-baserad autentisering.
- Behöll den gamla nyckeln tillfälligt som reserv tills WIF verifierats på
  `main`.

### Verifiering

- Körde `terraform fmt -check -recursive`.
- Validerade både teammodulen och bootstrap-modulen.
- Kontrollerade Terraform-planerna före apply.
- Bootstrap-planen visade tre tillägg, inga ändringar och inga borttagningar.
- Efter apply visade bootstrap och teammodulen `No changes`.
- Testade WIF från `member/itzmejonny92` genom en lyckad manuell Actions-körning.
- Skapade PR #18, som godkändes av två medlemmar och mergades till `main`.
- Verifierade en lyckad deploy från `main` efter WIF-migreringen.

### Synkning och dokumentation

- Synkade återkommande senaste `main` till `member/itzmejonny92`.
- Tog in gruppens SSH-ändring från PR #19 och verifierade vilka användare som
  finns i `terraform.tfvars`.
- Synkade gruppens riskanalys om Google Service Account-nycklar från PR #21.
- Skapade en personlig dokumentationsyta för varje gruppmedlem.
- Uppdaterade projektets README så medlemsytorna är lätta att hitta.

### Åtkomst till Spectre och flagganalys

- Hämtade jumphostens externa IP från Terraform och verifierade SSH-åtkomsten.
- Startade en lokal SOCKS5-proxy med dynamisk port forwarding över SSH.
- Verifierade att Windows nådde proxyn på `127.0.0.1:1080`.
- Startade Opera GX med en separat profil, SOCKS5-proxy och fjärrbaserad
  DNS-uppslagning.
- Verifierade att Spectre identifierade anslutningen som Team 2 via
  jumphostens interna IP-adress `10.0.2.2`.
- Skapade en återanvändbar personlig instruktion för anslutning, verifiering,
  felsökning och säker frånkoppling.

### Säkerhetsfynd i flaggövningen

- Analyserade en lokalt kvarlämnad och ignorerad `terraform.tfstate.backup`.
- Identifierade att Terraform state kan innehålla känsliga värden i klartext
  eller Base64-kodad form även när värdet markeras som känsligt i Terraform.
- Avkodade övningens Base64-värde lokalt och identifierade den första flaggan
  utan att dokumentera själva flaggvärdet.
- Kartlade statefilens nätverksuppgifter och skilde mellan CIDR-intervall,
  gateway, intern VM-adress och publik NAT-adress.
- Undersökte Spectres Looking Glass och verifierade med en neutral markör att
  fältet `target` var sårbart för command injection.
- Använde endast läsande kommandon för att förstå körmiljön och identifierade
  övningens andra flagga i `flag.txt`.
- Dokumenterade att flaggvärden, credentials och statefiler inte ska publiceras
  i repot.

## Egna bedömningar

- WIF skulle testas på en branch före merge för att inte riskera den fungerande
  pipelinen på `main`.
- Den gamla service account-nyckeln ska tas bort först efter bekräftad WIF-deploy
  från `main`.
- PB-03 ska vara `In progress`, inte `Done`, tills både nyckelresursen och
  GitHub-hemligheten `GCP_SA_KEY` är borttagna och verifierade.
- `uniform_bucket_level_access = true` är en säkerhetsförbättring. Den direkta
  bucket-risken är IAM-medlemmen `allAuthenticatedUsers`; public access
  prevention bör användas som ytterligare skydd.
- Inget issue ska stängas enbart för att en ändring är påbörjad eller finns i en
  branch. Kontrollpunkterna ska vara verifierade först.
- En ignorerad statefil är fortfarande en lokal säkerhetsrisk. `.gitignore`
  förhindrar en commit men krypterar, raderar eller skyddar inte filens innehåll.
- Looking Glass-fyndet visar att extern inmatning inte får byggas in i ett
  shell-kommando. Inmatningen behöver valideras och kommandon ska köras med
  separata argument och minsta möjliga behörighet.

## Samarbete och spårbarhet

- [PR #17](https://github.com/itsx25-team2/kurs6-team2-infra/pull/17): produktbacklogg och arbetsflöde.
- [PR #18](https://github.com/itsx25-team2/kurs6-team2-infra/pull/18): WIF-migrering.
- [WIF-test på member-branch](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34228835871): lyckad autentisering, plan och apply.
- [WIF-deploy från main](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34231222239): lyckad verifiering efter merge.
- [PR #20](https://github.com/itsx25-team2/kurs6-team2-infra/pull/20): Blue Team-agenda och backloggstatus.
- [PR #22](https://github.com/itsx25-team2/kurs6-team2-infra/pull/22): medlemsytor och avslutande backloggstatus, mergad.
- [PR #23](https://github.com/itsx25-team2/kurs6-team2-infra/pull/23): uppdaterad närvaro i gruppens sammanfattning, mergad.
- [PR #24](https://github.com/itsx25-team2/kurs6-team2-infra/pull/24): kompletterad riskdokumentation, mergad.

## Kvarstående arbete

1. Ta bort den gamla service account-nyckeln och dess känsliga Terraform-output.
2. Applicera och verifiera nyckelrensningen i bootstrap-modulen.
3. Ta bort `GCP_SA_KEY` från GitHub Secrets och avsluta PB-03/issue #9.
4. Åtgärda state-bucketens `allAuthenticatedUsers` och inför public access
   prevention.
5. Fortsätt med least privilege för CI/CD-service accountet och begränsning av
   brandväggsregeln.
6. Lägg till Amin i SSH-konfigurationen när hans publika nyckel är tillgänglig
   och dokumentera gruppens SSH-rutin.
7. Ta med riskerna från Terraform state och command injection i fortsatt
   Blue Team-analys och backloggprioritering.

## Säker hantering

Inga privata SSH-nycklar, service account keys, credentials, Terraform state,
planfiler eller flaggvärden har lagts i dokumentationen eller commitats.
