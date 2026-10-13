# Individuell sammanställning av flaggarbetet - Jonny Nguyen - 2026-09-24

## Syfte

Detta dokument sammanfattar mitt arbete med kursens flaggövningar fram till
den 24 september 2026. Syftet är att visa hur jag har arbetat metodiskt och
defensivt med felsökning, källanalys, GCP-identitet, lagring och
webbsårbarheter.

Flaggvärden, access tokens, nycklar och andra credentials är avsiktligt
utelämnade. Dokumentet skiljer också mellan en flagga som har identifierats och
en flagga som har registrerats i Spectre.

## Samlad status

| Område | Resultat | Spectre-status |
| --- | --- | --- |
| Terraform state och Base64 | Flagga identifierad | Registrerad den 8 september |
| Ursprunglig LookingGlass | Flagga identifierad | Registrerad den 8 september |
| Metadata och aktuell Storage-generation | Flagga identifierad | Inte inskickad |
| Metadata och raderad Storage-generation | Flagga identifierad | Inte inskickad |
| Git-historik, raderad fil | Flagga identifierad | Registrerad den 22 september |
| Avvikande remote-branch | Flagga identifierad | Registrerad den 22 september |
| IDOR i profilfunktionen | Flagga identifierad | Registrerad den 22 september |
| SQL injection i inloggningen | Sårbarhet verifierad, flagga återstår | Inte inskickad |

Totalt har sju av åtta flaggor identifierats genom analys. Det senast
verifierade leaderboard-läget den 22 september var fem av åtta registrerade
flaggor. De tre registreringarna den 22 september gjordes innan gruppens
gemensamma genomgång. Spectre saknade en funktion för att återkalla dem, vilket
är anledningen till att hittad status och inlämningsstatus dokumenteras
separat.

## Arbetssätt

Jag har försökt följa samma metod genom hela arbetet:

1. Bekräfta att undersökningen hör till kursens avgränsade labbmiljö.
2. Börja med dokumentation, klientkod, Git-historik eller andra passiva källor.
3. Använd en neutral markör för att verifiera en misstänkt sårbarhet.
4. Ändra en sak i taget och tolka resultatet innan nästa steg.
5. Använd läsande anrop och minsta nödvändiga åtkomst.
6. Skriv aldrig ut eller dokumentera tokens och andra credentials.
7. Rensa tillfälliga variabler och filer efter analysen.
8. Dokumentera både teknisk orsak och relevant Blue Team-åtgärd.

## Flagga 1 - Terraform state och Base64

### Hur flaggan hittades

En lokalt kvarlämnad `terraform.tfstate.backup` analyserades. Statefilen
innehöll ett Base64-kodat värde som kunde avkodas lokalt. Det avkodade värdet
följde kursens flaggformat.

### Vad jag lärde mig

Terraform state är inte vanlig källkod. Filen kan innehålla outputs,
resursattribut och känsliga värden i klartext eller i en kodning som Base64.
Att Terraform markerar ett värde som `sensitive` döljer främst värdet i viss
terminalutdata; det innebär inte att värdet är krypterat i state.

### Defensiva åtgärder

- Lagra state i en skyddad remote backend.
- Använd kryptering, versionshantering och strikt IAM.
- Ignorera lokala state- och backupfiler i Git.
- Rotera en hemlighet om den har förekommit i state eller historik.
- Behandla Base64 som kodning, inte som säker kryptering.

## Flagga 2 - Ursprunglig LookingGlass

### Hur flaggan hittades

Spectres LookingGlass tog emot ett användarstyrt `target`-fält. En neutral
markör användes först för att verifiera att indata nådde ett skalkommando.
Därefter användes begränsade, läsande kommandon för att hitta labbens
`flag.txt`.

### Vad jag lärde mig

Problemet var command injection: extern indata byggdes in i ett kommando som
tolkades av ett skal. Ett formulär som ser ut att vara ett enkelt
nätverksverktyg kan därför få större åtkomst än användaren ska ha.

### Defensiva åtgärder

- Använd inte ett skal för att köra ping eller liknande verktyg.
- Skicka validerade värden som separata processargument.
- Validera IP-adresser och värdnamn med en strikt tillåtelselista.
- Kör tjänsten med låg behörighet och begränsad åtkomst till filsystemet.

## Flagga 3 och 4 - Metadata och Cloud Storage-versioner

### Steg 1: Fastställ rätt request-format

LookingGlass-gränssnittets publika JavaScript analyserades. Klienten använde
`URLSearchParams` och skickade URL-kodad formulärdata, inte JSON. Tidiga
JSON-tester gav därför missvisande BusyBox-hjälptext eftersom backend inte
läste `target` på avsett sätt.

Detta visade varför metod, endpoint, content type och fältnamn måste verifieras
innan ett API-svar tolkas.

### Steg 2: Analysera den naiva patchen

Den uppdaterade tjänsten tog bort vissa separatorer, blanksteg och blockerade
programnamn. En neutral teststräng visade att en radbrytning fortfarande kunde
starta ett andra kommando. Skalets `IFS` kunde fungera som argumentavgränsare
efter att vanliga blanksteg hade tagits bort.

Svartlistade ord kunde dessutom delas upp och sättas ihop av skalet först efter
att filtret hade granskat texten. Filtret gav även falska positiva träffar när
en blockerad teckenföljd råkade förekomma inuti ett legitimt ord.

Lärdomen var att tecken- och ordsvartlistor inte löser command injection. Det
underliggande felet var fortfarande att användarstyrd text nådde ett skal.

### Steg 3: Nå GCP Metadata Service

Från LookingGlass-servern kunde GCP Metadata Service nås med den obligatoriska
headern `Metadata-Flavor: Google`. Endast nödvändig metadata kartlades:

- projekt-ID,
- instans- och projektattribut,
- anslutet service account,
- service accountets OAuth-scope,
- startup-skriptets beroenden.

Metadata Service kunde även lämna ut en kortlivad access token för VM:ns
identitet. Tokenen fångades direkt i en lokal variabel, skrevs inte ut och
rensades efter varje kontroll.

### Steg 4: Skilj scope från IAM

Service accountet hade `cloud-platform`-scope. Ett försök mot kursens
demonstrationshemlighet i Secret Manager gav ändå `PERMISSION_DENIED`.

Detta bekräftade att ett OAuth-scope anger vilka API:er en token kan användas
mot, medan IAM avgör vilka resurser identiteten faktiskt får läsa eller ändra.
Nekad Secret Manager-åtkomst var därför ett positivt säkerhetsresultat.

### Steg 5: Följ startup-skriptet

Instansens startup-skript visade att applikationsfiler hämtades från en privat
Cloud Storage-bucket. Service accountet hade den Storage-behörighet som krävdes
för serverns normala uppstart, även om det saknade Secret Manager-behörighet.

Objektmetadata listades med versioner aktiverade. Samma `flag.txt` fanns i två
generationer:

- en aktuell generation,
- en äldre generation som hade raderats.

Genom att läsa generationerna separat identifierades två olika flaggor.
Flaggvärdena sparades inte i repot och skickades inte in till Spectre.

### Defensiva åtgärder

- Eliminera shell execution i LookingGlass.
- Begränsa workloads åtkomst till Metadata Service.
- Ge service accounts minsta möjliga IAM-behörighet.
- Undvik att återanvända en privilegierad VM-identitet i onödiga containers.
- Separera bootstrap-resurser från applikationsdata.
- Tillämpa retention och säker radering även på äldre objektgenerationer.
- Logga åtkomst till metadata, tokens och känsliga buckets.

## Flagga 5 - Raderad fil i Git-historiken

### Hur flaggan hittades

Git-historiken granskades efter filer som hade raderats. En tidigare
`flag.txt` identifierades och kunde läsas från commitens förälder, alltså
versionen precis innan filen raderades.

### Vad jag lärde mig

Att radera en fil i en ny commit tar inte bort innehållet ur äldre commits.
Den som kan läsa repots historik kan normalt fortfarande återställa filen.

### Defensiva åtgärder

- Committa aldrig hemligheter, inte ens till en kortlivad branch.
- Rotera omedelbart en hemlighet som har hamnat i Git.
- Använd secret scanning och pre-commit-kontroller.
- Historikomskrivning kan minska exponeringen men ersätter inte rotation.

## Flagga 6 - Avvikande remote-branch

### Hur flaggan hittades

Alla remote-referenser granskades, inte bara den lokala standardbranchen. En
avvikande branch innehöll en flaggfil som inte syntes i den normala
arbetskopian.

### Vad jag lärde mig

Ett repos säkerhetsyta omfattar alla branches, tags och andra Git-referenser.
Kod eller hemligheter försvinner inte bara för att de inte finns på `main`.

### Defensiva åtgärder

- Inkludera alla referenser i secret scanning och repository-granskning.
- Radera gamla branches när de inte längre behövs.
- Kontrollera även forks, pull request-referenser och cachade kloner.

## Flagga 7 - IDOR i profilfunktionen

### Hur flaggan hittades

Efter normal inloggning ändrades profilens numeriska resurs-ID i ett läsande
anrop. Servern returnerade en annan användares profil utan att verifiera att
den inloggade användaren hade rätt till resursen. Flaggan fanns i den andra
profilens data.

### Vad jag lärde mig

Inloggning är inte samma sak som behörighetskontroll. En applikation måste
kontrollera åtkomst för varje objekt och varje request. Att ett ID är svårt att
gissa är inte ett säkerhetsskydd.

### Defensiva åtgärder

- Kontrollera ägarskap eller roll på serversidan för varje resurs.
- Returnera inte interna profilfält till obehöriga användare.
- Lägg till negativa behörighetstester för andra användares ID:n.
- Logga och följ upp onormal sekventiell åtkomst till resurs-ID:n.

## Flagga 8 - SQL injection återstår

### Vad som verifierades

Inloggningsfunktionen byggde en SQL-fråga med användarstyrd text. Ett enkelt
sant villkor kunde kringgå autentiseringskontrollen och även rikta resultatet
mot ett särskilt konto. Detta bekräftade SQL injection i den skarpa
kursmiljön.

Flera försök gjordes för att förstå kolumnantal och responsbeteende, men själva
flaggvärdet extraherades inte. Arbetet avbröts innan vidare analys och flaggan
är därför den enda som återstår att identifiera.

### Defensiva åtgärder

- Använd parametriserade SQL-frågor utan stränginterpolering.
- Lagra lösenord med en modern lösenordshash och jämför dem i applikationskod.
- Begränsa databasidentitetens behörigheter.
- Lägg till tester som verifierar att SQL-metatecken behandlas som vanlig data.
- Logga misslyckade och avvikande inloggningsförsök utan att logga lösenord.

## Inlämningshändelsen den 22 september

Tre identifierade applikationsflaggor registrerades i Spectre innan gruppen
hade gått igenom dem tillsammans. Spectres flaggsida erbjöd endast läsning och
inskickning och saknade en funktion för borttagning. Registreringarna kunde
därför inte återkallas från användargränssnittet.

Lärdomen är att en verifierad flagga och en inlämnad flagga ska behandlas som
två separata steg. Fortsatt rutin är att stoppa efter verifiering, dokumentera
utan flaggvärde och invänta gruppens uttryckliga beslut före inlämning.

## Säker hantering

- Inga flaggvärden finns i detta dokument.
- Inga access tokens, privata nycklar eller credentials har sparats.
- Kortlivade tokenvariabler rensades efter användning.
- Tillfälliga analysfiler placerades i `/tmp` och rensades.
- Inga nya flaggor skickades till Spectre under genomgången av metadata- och
  Storage-flaggorna.
- Inga produktionsresurser ändrades under flagganalysen.

## Nästa steg

1. Gå igenom denna sammanställning tillsammans med gruppen.
2. Låt gruppen själva återskapa de pedagogiska stegen utan att dela tokens.
3. Bestäm gemensamt om och när de två ännu oregistrerade metadataflaggorna ska
   skickas in.
4. Analysera SQL injection-flaggan separat med en tydlig stoppunkt före
   inlämning.
5. Skicka aldrig en flagga till Spectre utan uttryckligt godkännande från
   gruppen.
