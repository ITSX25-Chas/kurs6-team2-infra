# Individuell arbetssammanfattning - Jonny Nguyen - 2026-09-22

## Syfte

Mitt fokus var att pedagogiskt undersöka och förstå de två flaggorna som hör
till Workshop 2 Blue Team. Arbetet genomfördes stegvis så att varje tekniskt
antagande kunde verifieras innan nästa steg påbörjades. Inga flaggor skickades
in till Spectre under denna genomgång.

## Mitt arbete

- Utgick från att de två första flaggorna från den 8 september redan var
  lösta och avgränsade arbetet till de två efterföljande workshopflaggorna.
- Analyserade LookingGlass-gränssnittets nätverksanrop med webbläsarens
  utvecklarverktyg.
- Läste den publika klientkoden och konstaterade att API:t tar emot
  URL-kodad formulärdata i fältet `target`, inte JSON.
- Verifierade normal funktion med ett neutralt anrop mot `127.0.0.1`.
- Använde ofarliga markörer för att förstå hur serverns indatafilter
  bearbetade separatorer, blanksteg och blockerade programnamn.
- Bekräftade att en radbrytning kunde kringgå filtret och starta ett andra
  skalkommando.
- Verifierade att `${IFS}` kunde återskapa ett argumentavstånd efter att
  vanliga blanksteg hade tagits bort.
- Visade att svartlistade ord kunde delas upp med en tom skalvariabel och
  sättas ihop först vid körning.
- Nådde GCP Metadata Service från LookingGlass-servern med den obligatoriska
  headern `Metadata-Flavor: Google`.
- Kartlade metadata på minsta nödvändiga nivå: projekt-ID, instansattribut,
  anslutet service account och OAuth-scope.
- Hämtade en kortlivad access token direkt till en lokal variabel utan att
  skriva ut eller dokumentera tokenvärdet.
- Verifierade att Secret Manager nekade åtkomst genom IAM trots
  `cloud-platform`-scope.
- Analyserade instansens startup-skript och identifierade att applikationsfiler
  hämtades från en privat Cloud Storage-bucket.
- Använde VM-identitetens tillåtna Storage-behörighet för att lista
  objektmetadata och objektgenerationer.
- Identifierade en aktuell och en raderad generation av samma flaggfil och
  läste versionerna separat.
- Hittade båda workshopflaggorna utan att spara deras värden i repot eller
  skicka in dem till Spectre.
- Rensade den lokala tokenvariabeln och tillfälliga analysfiler efter arbetet.

## Pedagogisk lösningsförklaring

### 1. Förstå det riktiga API-anropet

De första terminaltesterna skickade JSON och gav därför missvisande
BusyBox-hjälptext. Genom att läsa JavaScriptet på Spectres LookingGlass-sida
framgick det att klienten använder `URLSearchParams` och skickar formulärdata.
När samma format användes i terminalen fungerade ping-anropet normalt.

Lärdomen är att man först måste förstå metod, endpoint, content type och
fältnamn. Ett svar från fel request-format säger annars väldigt lite om den
verkliga applikationslogiken.

### 2. Verifiera command injection utan att orsaka skada

Servern försökte skydda sig genom att ta bort vissa specialtecken, blanksteg
och programnamn. Ett semikolon och vanliga blanksteg försvann, men en
radbrytning överlevde och tolkades av skalet som början på ett nytt kommando.
En neutral `printf`-markör bekräftade detta utan att ändra serverns tillstånd.

När blanksteg togs bort kunde skalvariabeln `${IFS}` användas som avgränsare.
När exempelvis ett programnamn svartlistades kunde namnet delas upp med en tom
variabel och sättas ihop av skalet efter att filtret redan hade körts.

Detta visar varför svartlistning inte är ett tillräckligt skydd. Grundfelet är
att användarstyrd indata fortfarande når ett skal.

### 3. Nå Metadata Service

Command injection-vägen gjorde att HTTP-anrop kunde utföras från
LookingGlass-instansen. GCP Metadata Service är endast tillgänglig lokalt från
instansen och kräver headern `Metadata-Flavor: Google`. Via tjänsten gick det
att identifiera serverns projekt och service account samt hämta en kortlivad
token.

Tokenen skrevs inte ut. Den lagrades tillfälligt i en lokal skalvariabel och
rensades efter användning.

### 4. Skilj OAuth-scope från IAM

Service accountet hade `cloud-platform`-scope, men ett försök att läsa
workshopens demo-hemlighet i Secret Manager gav `PERMISSION_DENIED`.
Detta var ett viktigt positivt säkerhetsresultat: scopet gör API-anrop möjliga,
men IAM avgör fortfarande vilka resurser identiteten får använda.

### 5. Följ startup-skriptets beroenden

Instansens startup-skript visade att en applikationszip hämtades från en privat
Cloud Storage-bucket. Denna observation gav en spårbar koppling mellan
serveridentiteten och Storage-resursen. Service accountet hade inte åtkomst
till Secret Manager, men hade den Storage-behörighet som krävdes av serverns
normala uppstart.

### 6. Förstå objektversionering

Listning av objektmetadata med versioner aktiverade visade två generationer av
samma `flag.txt`: en aktuell version och en tidigare raderad version. Genom att
ange respektive generationsnummer kunde versionerna läsas separat och de två
flaggorna identifieras.

Det visar att en fil som skrivs över eller raderas inte nödvändigtvis är borta.
Cloud Storage-versionering är användbar för återställning, men äldre
generationer måste också omfattas av organisationens regler för
informationsklassning, retention och säker radering.

## Viktiga lärdomar

- Användarinmatning ska aldrig byggas in i ett skalkommando.
- IP-adresser och värdnamn bör valideras med en strikt tillåtelselista och
  skickas som separata processargument utan ett skal.
- Svartlistor kan kringgås och ger samtidigt falska positiva träffar på
  legitima ord.
- Workloads åtkomst till Metadata Service måste behandlas som en möjlig väg
  till serveridentiteten.
- Ett service account ska ha minsta möjliga IAM-behörighet.
- `cloud-platform`-scope ersätter inte IAM-kontroller.
- Kortlivade tokens är fortfarande credentials och ska aldrig loggas,
  publiceras eller commitas.
- Cloud Storage-versionering innebär att även raderade eller överskrivna
  hemligheter kan finnas kvar.
- API-analyser bör börja med korrekt request-format och neutrala kontrolltest.

## Resultat

De två flaggorna från Workshop 2 identifierades och lösningskedjan kunde
förklaras från osäker indata till metadataidentitet och objektversionering.
Flaggvärden, tokens, SSH-nycklar och andra credentials har inte lagrats i denna
sammanfattning eller commitats till repot. Flaggorna har inte skickats in till
Spectre inom ramen för denna genomgång.

## Nästa steg

- Gå igenom lösningskedjan tillsammans med gruppen innan någon skickar in
  flaggorna.
- Diskutera defensiva åtgärder för command injection, metadataåtkomst,
  service accounts och Storage-retention.
- Fortsätt därefter med nästa flagga som en separat, pedagogisk övning.
