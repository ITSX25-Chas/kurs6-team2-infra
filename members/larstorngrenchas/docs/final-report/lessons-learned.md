# Post-mortem, lessons learned och professionell sammanfattning

## Syfte och kursmål

I den här delen ska du genomföra ett kort post-mortem över ett verkligt eller simulerat intrångsförsök i projektet. Du ska identifiera tre viktiga lärdomar och omsätta projektets resultat till information för en professionell mottagare.

Arbetet knyter an till:

- **Kursmål 9:** utföra incidentrespons, post-mortem och förbättringsarbete efter ett verkligt eller simulerat intrångsförsök.
- **Kursmål 13:** självständigt leda och leverera ett komplext säkerhetsprojekt med höga krav på kvalitet, dokumentation och professionell kommunikation.

En lesson learned är inte bara något som gick bra eller dåligt. Den ska visa vad som hände, varför det hände, vilken betydelse det fick och hur framtida säkerhetsarbete kan förbättras.

---

## Händelse och avgränsning

Observationerna och erfarenheterna som beskrivs nedan, har att göra med simulerade intrångsförsök i en miljö hos Company Website (en publik webbplats). De sårbarheter som beskrivs påverkade framförallt konfidentialitet och integritet hos systemet, men potentiellt även tillgänglighet. Problemen upptäcktes genom att vår grupp gjorde en genomlysning av hela webbplatsen och den aktuella koden. Jag själv var delaktig både i felsökningen, analysen och konkreta justeringar i koden för att rätta till bristerna.
Se bland annat <br />
[Säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report.md)<br />
[Tillägg säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report-addendum.md)<br />
[Sammanfattande säkerhetsrapport med koppling till MITRE ATT&CK](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)<br />
[Justeringar av GitHub Permissions PR #13](https://github.com/ITSX25-Chas/team2-company-website/pull/13)<br />
[Säkerhetsjusteringar av company website PR #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29)<br />
[Changes to deployment and dockerfile PR #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32)<br />

---

## Lesson learned 1

### Observation
Inloggningen på Company Website är alldeles för enkel att kringgå genom SQL Injection.

### Orsak
SQL-förfrågan använder data som skickas in av användaren direkt i SQL, utan att den valideras eller saneras.

### Konsekvens
Man kan logga in utan korrekt användarnamn eller lösenord. Man kan obehörigen läsa användardata och manipulera användarkonton, samt eventuellt tillskansa sig full kontroll över databasen. Detta är givetvis förödande, då databasen kan innehålla känsliga personuppgifter och även företagshemligheter.

### Förbättring
Användning av parametriserade frågor, vilket innebär att man använder sig av ”prepared statements”, där SQL-förfrågan har ett visst antal givna parametrar med en platshållare för varje värde som ska fyllas med det innehåll som kommer från inmatningen. Endast de förbestämda parametrarna kan finnas i SQL-frågan.

### Uppföljning
Den justerade koden granskas av två personer i gruppen, innan den godkänns och implementeras. Föreslås även att införa automatiska säkerhetskontroller innan nya kodändringar rullas ut (se KPI-dokument och prioriterade åtgärder i rapporten).

---

## Lesson learned 2

### Observation
Felaktig hantering och jämförelse av lösenord.

### Orsak
Koden använder inte ett korrekt lösenordsflöde. Istället för att verifiera lösenordet mot ett säkert hashvärde i databasen, jämförs `password_hash` direkt mot användarens inmatning i SQL-frågan. Den enda användningen av `check_password_hash()` är i ett sekundärt villkor, men huvudflödet för login är inte korrekt implementerat.

### Konsekvens
Lösenord kan obehörigen verifieras felaktigt eller kringgås, logiken blir otillförlitlig och det är risk för att helt kunna kringgå autentiseringen.

### Förbättring
Kryptera alla lösenord med en stark algoritm, exempelvis bcrypt eller argon2. För extra säkerhet kan man också använda sig av ”salt”. Verifiera med `check_password_hash()` eller motsvarande säker metod. Använd en tydlig, korrekt autentiseringsmodell utan att lägga lösenord i SQL-frågor.

### Uppföljning
Den justerade koden granskas av två personer i gruppen, innan den godkänns och implementeras. Föreslås även att införa automatiska säkerhetskontroller innan nya kodändringar rullas ut (se KPI-dokument och prioriterade åtgärder i rapporten).

---

## Lesson learned 3

### Observation
En uppdatering till koden för Company Website visade att en funktion för email-signatur innehåller brister och säkerhetsproblem, och kan avslöja känsliga uppgifter från databasen.

### Orsak
Förhandsvisningen av email-signaturen var känslig för SQL-injektion i Jinja-renderingen.

### Konsekvens
Möjlighet att hämta känslig data från databasen utan att vara inloggad eller auktoriserad. Detta kan riskera att exponera känsliga personuppgifter (brott mot GDPR) eller företagshemligheter.

### Förbättring
Borttagning av dynamisk rendering i filen routes.py. Endast förutbestämda variabler får skickas in. Själva ersättningen tolkar inte längre malltext som Jinja, och aktuell endpoint accepterar bara exakta variabelnamn. Övriga programmatiska uttryck avvisas.

### Uppföljning
Den justerade koden granskas av två personer i gruppen, innan den godkänns och implementeras. Föreslås även att införa automatiska säkerhetskontroller innan nya kodändringar rullas ut (se KPI-dokument och prioriterade åtgärder i rapporten).

---

## Professionell sammanfattning

Nedan redovisas de viktigaste resultaten från en proaktiv säkerhetsgenomlysning av källkoden och systemmiljön för webbplatsen Company Website. Granskningen genomfördes för att identifiera, analysera och åtgärda kritiska sårbarheter som hotade systemets konfidentialitet, integritet och tillgänglighet.
Samtliga identifierade brister har åtgärdats genom konkreta kodjusteringar, intern expertgranskning och verifiering.

### Identifierade risker och affärskonsekvenser
Under genomlysningen identifierades tre kritiska sårbarhetsområden som skulle kunna leda till obehörig systemåtkomst och dataläckor:
- Allvarliga brister i inloggningen: Detta innebar att en extern aktör helt kunnat kringgå lösenordskrav, kunna läsa eller manipulera känslig användardata samt potentiellt ta full kontroll över bakomliggande databaser. Bland annat kan detta innebära ett brott mot GDPR.
- Felaktig hantering av lösenord: Systemets logik för att verifiera användarlösenord mot databasen var felaktigt implementerad. Detta medförde en hög risk för att autentiseringen helt kunde kringgås på grund av otillförlitlig validering.
- Sårbarhet i profilhantering: En funktion för förhandsvisning av e-postsignaturer saknade tillräcklig dataseparering. Obehöriga användare kunde utnyttja detta för att extrahera känslig information från databasen. Även detta kan innebära ett brott mot GDPR, och möjligt läckage av hemliga företagsuppgifter.

### Genomförda åtgärder
För att eliminera riskerna och minimera attackytan har följande åtgärder genomförts:
1. Säkerställd datavalidering: Inmatningsdata från användare saneras och valideras nu strikt genom industristandarden ”prepared statements”, vilket blockerar möjligheten till skadlig manipulering.
2. Robust autentiseringsmodell: Lösenordshanteringen har strukturerats om från grunden. Systemet använder nu starka, moderna kryptografiska algoritmer för att garantera att lösenord aldrig kan läsas eller verifieras felaktigt.
3. Restriktiv mallhantering: Den osäkra mallen har tagits bort och ersatts med strikt definierade, statiska variabler som blockerar obehörig datautlämning.

### Kvalitetssäkring och rekommendationer framåt
För att säkerställa att sårbarheterna inte introduceras igen har en strikt fyrögonprincip tillämpats, där alla kodjusteringar granskats och godkänts av minst två gruppmedlemmar innan driftsättning.

### Rekommendation till IT-ledning och CISO
För att upprätthålla en långsiktigt hög säkerhetsnivå rekommenderas att verksamheten snarast inför en tydlig intern AI-policy, utbildning och en styrningsstruktur för medarbetare, samt automatiska säkerhetskontroller (SAST/DAST) direkt i utvecklingskedjan. Detta automatiserar upptäckten av liknande sårbarheter innan ny kod tillåts nå produktionsmiljön. I vår rekommendation ingår även införandet av ett incidenthanteringssystem, vilket möjliggör övervakning av systemet i realtid, och därmed förmågan att upptäcka, isolera och förhindra intrång. Dessutom menar vi att infrastrukturen i möjligaste mån ska drivas av kod (Infrastructure as Code), då automatiserade och strukturerade processer minskar risken för mänskliga misstag. I vår samlade rapport framgår både vår syn på prioritering av åtgärderna, vem eller vilka som bör äga frågan, och vid presentation av vår rapport har vi även förslag på budget och resurstilldelning.

---

## Kontroll före commit

- [x] Jag har avgränsat vilket intrångsförsök eller vilken incident mitt post-mortem gäller.
- [x] Jag har beskrivit min egen roll i incidentresponsen.
- [x] Jag har formulerat tre tydliga lessons learned.
- [x] Jag skiljer på observation och bakomliggande orsak.
- [x] Jag beskriver konsekvensen av varje lärdom.
- [x] Varje lesson learned leder till en konkret förbättring och uppföljning.
- [x] Den professionella sammanfattningen fokuserar på resultat, risk och betydelse.
- [x] Texten är begriplig utan alla tekniska detaljer från projektet.
