# Individuell slutrapport

**Namn:** Tim Rundquist  
**Projekt/team:** Kurs 6 – Team 2  
**Datum:** 2026-11-09

---

## 1. Professionell sammanfattning

Under kursens sju veckor arbetade Team 2 med att bygga upp och säkra en molnbaserad infrastruktur i Google Cloud Platform. Efter infrastrukturarbetet genomförde vi även ett simulerat intrångstest mot en intern webbapplikation, Acme Corps medarbetarportal.

Under arbetet med infrastrukturen upptäckte vi flera säkerhetsbrister. Bland annat hade CI/CD-kontot för breda behörigheter och brandväggsreglerna tillät trafik från hela internet. Vi arbetade med att åtgärda dessa problem genom Pull Requests och förbättringar i vår CI/CD-pipeline, där vi även använde branch protection.

Under intrångstestet hittade vi fyra kritiska sårbarheter som tillsammans gjorde det möjligt att genomföra en attackkedja. På mindre än 20 minuter lyckades vi gå från att sakna behörighet till att få root-åtkomst på servern. Vi kunde även komma åt och hämta personnummer och löneuppgifter för tre personer i företagsledningen.

De största riskerna som framkom var läckaget av personuppgifter, att webbapplikationen kördes med root-behörighet och att känsliga uppgifter fanns lagrade i klartext i konfigurationsfiler.

För att kunna följa upp säkerhetsarbetet tog vi fram tre KPI:er. De mäter hur snabbt kritiska säkerhetsbrister åtgärdas, hur mycket känslig information som exponeras vid pentester och hur väl infrastrukturen följer principen om minsta möjliga behörighet.

Det viktigaste framåt är att åtgärda sårbarheterna i webbapplikationen, se till att applikationer inte körs som root och införa autentisering på interna tjänster. Organisationen behöver också bedöma om personuppgiftsläckaget ska anmälas till IMY.

---

## 2. Kontext och avgränsning

Projektet var uppdelat i två delar. Under blue team-fasen, som pågick under vecka 4–7, arbetade Team 2 med att bygga en molninfrastruktur i GCP. Vi använde Terraform för infrastrukturen, GitHub Actions för CI/CD-pipelinen och Workload Identity Federation för autentisering. En viktig del av arbetet var att hitta och åtgärda säkerhetsbrister i miljön.

Under red team-fasen genomförde vi ett simulerat penetrationstest mot Acme Corps interna medarbetarportal. Det var en avsiktligt sårbar Flask-applikation med en tillhörande databas och en intern tjänst. Syftet var att undersöka vilka sårbarheter som fanns och hur de kunde användas för att ta sig vidare i systemet.

Underlaget till rapporten kommer från Terraform-koden och Git-historiken från infrastrukturarbetet, pentestrapporten med flaggor och loggutdrag samt våra dokumenterade lessons learned från intrångstestet.

Det är viktigt att nämna att testet genomfördes i en kontrollerad labbmiljö. Resultaten ska därför inte ses som ett test av en verklig produktionsmiljö.

---

## 3. Mitt individuella bidrag

Under blue team-fasen ansvarade jag bland annat för att köra bootstrap-modulen lokalt och lösa de problem som uppstod i början. Det handlade exempelvis om ett syntaxfel i `main.tf` och en resurskollision i GCP där ett service account redan fanns. För att lösa det behövde jag importera resursen med `terraform import`.

En av mina större uppgifter var issue #7, där jag arbetade med att begränsa behörigheterna för CI/CD-tjänstekontot. Den ursprungliga rollen `roles/editor` gav för breda rättigheter i GCP-projektet. Jag ersatte den därför med mer specifika roller: `roles/compute.networkAdmin` och `roles/compute.instanceAdmin.v1` i `bootstrap/main.tf`.

För att komma fram till vilka roller som behövdes gick jag igenom vilka typer av resurser som skapades av team-modulen. Efter ändringen upptäckte vi att CI/CD-pipelinen inte längre hade åtkomst till Terraform state. Jag löste det genom att lägga till en separat `roles/storage.objectAdmin`-bindning på den aktuella bucketen, i stället för att ge tillbaka bredare behörigheter på projektnivå.

Jag var även med och arbetade med brandväggsanalysen i issue #8. Utöver det registrerade jag min publika SSH-nyckel i GCP OS Login och kontrollerade att jag kunde ansluta till jumphosten.

Under red team-fasen deltog jag i rekognosceringen. Jag var bland annat med och identifierade SQL-injektionssårbarheten samt hittade flaggor genom command injection och SSRF.

Mina relevanta commits finns i branchen i teamets GitHub-repo.

---

## 4. Viktigaste projektresultat och evidens

### Resultat 1 – För breda behörigheter i CI/CD

CI/CD-tjänstekontot hade från början rollen `roles/editor`, vilket gav kontot omfattande skrivrättigheter i hela GCP-projektet.

**Evidens**

I `bootstrap/main.tf` och Git-historiken går det att se den ursprungliga konfigurationen. Det går även att följa ändringen där den breda rollen ersattes med mer specifika compute-roller genom en Pull Request.

**Verksamhets- och säkerhetsbetydelse**

Om CI/CD-kontot skulle bli komprometterat hade en angripare kunnat få mycket stora möjligheter att ändra resurser i GCP-projektet. Genom att begränsa behörigheterna minskar vi risken för att ett intrång får lika stora konsekvenser.

**Rekommendation**

Alla IAM-bindningar bör granskas regelbundet. Breda roller ska undvikas om det inte finns en tydlig och dokumenterad anledning att använda dem.

**Prioritet: Hög**

### Resultat 2 – Flera sårbarheter som ledde till ett lyckat intrång

Under penetrationstestet hittade vi fyra kritiska brister som tillsammans gjorde det möjligt att genomföra en attackkedja som ledde till root-åtkomst och exponering av känslig information.

**Evidens**

I pentestrapporten finns följande flaggor som visar de olika stegen i attacken:

- `FLAG{sqli_foothold}`
- `FLAG{broken_access_control}`
- `FLAG{rce_command_injection}`
- `FLAG{internal_pii_exfil}`

Loggutdragen visar även `uid=0(root)` och JSON-svar som innehöll personnummer och löneuppgifter.

**Verksamhets- och säkerhetsbetydelse**

Personnummer och löneuppgifter för tre personer i företagsledningen kunde hämtas av en obehörig angripare. Det innebär en potentiell personuppgiftsincident som behöver bedömas utifrån GDPR.

**Rekommendation**

SQL-injektionen och bristerna i åtkomstkontrollen bör åtgärdas omedelbart. Organisationen behöver även utreda personuppgiftsläckaget och bedöma om det ska anmälas till IMY.

**Prioritet: Kritisk**

---

## 5. KPI:er och ledningsrapportering

Vi valde tre KPI:er för att kunna följa upp säkerhetsarbetet och ge ledningen en bild av säkerhetsläget utan att de behöver ha djupa tekniska kunskaper.

**KPI 1 – Andel kritiska fynd som åtgärdas inom 14 dagar**

Den här KPI:n visar hur bra organisationen är på att ta hand om allvarliga säkerhetsbrister. Målet är att alla kritiska fynd ska åtgärdas inom 14 dagar. Om resultatet hamnar under 80 % behöver organisationen undersöka varför åtgärderna tar för lång tid.

**KPI 2 – Antal kategorier av känslig information som exponeras vid senaste pentest**

Den här KPI:n visar vilken typ av känslig information som går att komma åt vid ett penetrationstest. I vårt test hittade vi fyra kategorier av känslig information. Målet är att inga känsliga uppgifter ska exponeras, alltså ett resultat på 0. Resultatet bör även minska mellan testtillfällena.

**KPI 3 – Andel infrastruktur som följer principen om minsta möjliga behörighet**

Den här KPI:n visar hur bra infrastrukturen är på att begränsa behörigheter. Målet är 100 %, vilket innebär att inga breda behörigheter eller öppna brandväggsregler ska finnas utan en tydlig motivering.

En begränsning med dessa KPI:er är att de bara visar det vi faktiskt har testat och granskat inom projektets omfattning. Det kan fortfarande finnas säkerhetsproblem som vi inte har upptäckt.

---

## 6. Incidentrespons, post-mortem och förbättringsarbete

Det simulerade penetrationstestet genomfördes den 20 oktober 2026 mot Acme Corps medarbetarportal. Vi började med att kartlägga applikationen och dess tjänster med hjälp av verktyg som Nmap och ffuf. Därefter hittade vi en SQL-injektion i inloggningsformuläret och kunde ta oss vidare genom att utnyttja brister i åtkomstkontrollen via en manipulerad cookie.

Senare hittade vi även command injection i diagnostikformuläret. Det gjorde det möjligt att köra kommandon på servern. Till sist använde vi SSRF för att nå en intern tjänst och komma åt känslig information.

Under testet blev det tydligt hur flera mindre bra säkerhetslösningar kan kombineras och leda till ett mycket allvarligare problem. Vi identifierade framför allt tre viktiga lärdomar.

**Första lärdomen var hur farlig kombinationen av SQL-injektion och bristande åtkomstkontroll kan vara.** SQL-injektionen gjorde det möjligt att komma vidare från inloggningen, medan den bristande kontrollen på serversidan gjorde att vi kunde få tillgång till administratörsfunktioner. Grundproblemet var att SQL-frågor byggdes direkt från användarens inmatning och att behörigheten inte kontrollerades ordentligt på serversidan.

**Den andra lärdomen var vikten av att inte köra applikationer som root.** Eftersom webbapplikationen hade root-behörighet fick command injection mycket större konsekvenser. I stället för att bara kunna påverka applikationen kunde vi få kontroll över hela servern och läsa känsliga konfigurationsfiler. En dedikerad användare med begränsade rättigheter hade minskat konsekvenserna.

**Den tredje lärdomen var att interna tjänster också behöver skyddas med autentisering.** Under testet kunde vi nå en intern tjänst utan att behöva logga in. Det visade att det inte räcker att förlita sig på att en tjänst bara är tillgänglig från ett internt nätverk. Om en angripare redan har tagit sig in på en server kan även interna tjänster bli åtkomliga.

Utifrån detta är de viktigaste förbättringarna att använda parametriserade SQL-frågor, kontrollera behörigheter på serversidan, köra applikationer med begränsade rättigheter och kräva autentisering på interna tjänster.

Efter att åtgärderna har genomförts bör ett nytt penetrationstest utföras för att kontrollera att sårbarheterna verkligen är lösta.

---

## 7. AI i säkerhetsarbetet

### Konkreta användningsfall

Under projektet använde jag Claude från Anthropic som ett stöd i det tekniska arbetet. I blue team-fasen använde jag AI framför allt vid felsökning, exempelvis när bootstrap-modulen gav syntaxfel, när jag behövde använda `terraform import` och när vissa `gcloud`-kommandon inte fungerade som förväntat.

Under red team-fasen använde jag AI för att diskutera attackkedjan och få hjälp med att strukturera dokumentationen av de sårbarheter vi hittade.

### När AI var lämpligt

Ett bra exempel var när CI/CD-pipelinen slutade fungera efter att vi tog bort rollen `roles/editor`. Jag beskrev problemet för AI och fick förslag på att använda en separat IAM-bindning för den aktuella bucketen.

AI kunde förklara skillnaden mellan behörigheter på projektnivå och behörigheter som bara gäller en specifik resurs. Jag fick även ett konkret Terraform-exempel som jag kunde testa. Det sparade tid och gav mig en bra utgångspunkt, utan att jag behövde börja leta igenom all dokumentation från början.

### När AI var olämpligt eller otillräckligt

Det var däremot inte tillräckligt att bara följa AI:ns förslag när vi ändrade IAM-behörigheter. AI hade inte full koll på vår specifika miljö, vilka resurser som skapades av Terraform eller hur behörigheterna i vårt GCP-projekt var uppbyggda.

Jag behövde därför själv gå igenom Terraform-koden, kontrollera vilka resurser som användes och se till att rollerna gav rätt behörigheter utan att ge mer åtkomst än nödvändigt.

AI kunde inte heller veta säkert om en ändring skulle påverka någon annan del av pipelinen. Det behövde kontrolleras genom att faktiskt köra och testa ändringen.

### Verifiering och mänsklig kontroll

Jag körde kommandona i terminalen och kontrollerade resultatet i stället för att lita blint på AI:ns svar. Terraform-koden validerades med `terraform validate`, och jag gick igenom planen innan `apply` kördes.

När det gällde dokumentationen från penetrationstestet jämförde jag AI:ns sammanfattningar med mina egna anteckningar och terminaloutput. På så sätt kunde jag kontrollera att informationen stämde och att inga viktiga detaljer hade ändrats.

### Risker och professionella gränser

En av de största riskerna med AI i säkerhetsarbete är att man litar för mycket på svaren. AI kan exempelvis ge ett Terraform-block som fungerar rent tekniskt men som ändå skapar en säkerhetsrisk.

Det finns också en risk att man accepterar för breda behörigheter om man inte själv granskar förslagen ordentligt. En annan viktig sak är informationssäkerhet. Loggar, lösenord, nycklar och personuppgifter ska inte delas med en AI-tjänst hur som helst.

### Professionell slutsats

Jag tycker att AI är ett användbart verktyg för att förstå tekniska problem, felsöka och få hjälp med dokumentation. Däremot bör AI inte användas som den enda grunden för beslut som påverkar säkerheten.

I ett framtida arbete inom cybersäkerhet skulle jag använda AI som ett stöd när jag analyserar problem och letar efter lösningar. Men innan jag genomför en ändring skulle jag alltid kontrollera informationen mot dokumentation, tester och den faktiska miljön.

---

## 8. Prioriterade rekommendationer

**1. Åtgärda SQL-injektionen och bristerna i åtkomstkontrollen (Kritisk)**

Använd parametriserade SQL-frågor och se till att behörigheter alltid kontrolleras på serversidan.  
**Ansvarig:** Utvecklingsteamet.  
**Tidsplan:** Åtgärdas omedelbart.

**2. Se till att applikationer inte körs som root (Kritisk)**

Skapa en separat systemanvändare med så få rättigheter som möjligt. På så sätt begränsas skadan om applikationen skulle bli komprometterad.  
**Ansvarig:** Driftsteamet.  
**Tidsplan:** Åtgärdas omedelbart.

**3. Inför autentisering på interna tjänster (Hög)**

Det räcker inte att förlita sig på nätverksisolering. Även interna tjänster ska kräva autentisering för att förhindra att en angripare kan komma åt dem efter ett intrång.  
**Ansvarig:** Arkitektur- och driftsteamet.

**4. Utred personuppgiftsläckaget (Hög)**

Organisationen behöver göra en incidentbedömning och avgöra om läckaget ska anmälas till IMY enligt GDPR. Om incidenten ska anmälas gäller normalt en tidsfrist på 72 timmar från det att organisationen fått vetskap om den.  
**Ansvarig:** Dataskyddsombud och ledning.  
**Tidsplan:** Bedömningen bör påbörjas omedelbart.

**5. Inför regelbundna penetrationstester (Medel)**

Genomför penetrationstester minst en gång per år och följ upp resultaten med hjälp av KPI 1 och KPI 2. På så sätt går det att se om säkerhetsarbetet faktiskt ger resultat över tid.  
**Ansvarig:** Säkerhetsansvarig.

---

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?

När kursen började hade jag en grundläggande förståelse för IAM-roller, men jag visste inte riktigt hur man i praktiken tar reda på vilka behörigheter som faktiskt behövs. Nu har jag fått erfarenhet av att gå igenom Terraform-kod, undersöka vilka resurser som skapas och koppla dem till rätt GCP-roller. Det är något jag känner att jag kommer ha nytta av framöver.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?

Det är framför allt red team-fasen. Att själv få testa att attackera ett system gav en helt annan förståelse än att bara läsa om olika sårbarheter. Jag fick se hur flera brister kan hänga ihop och göra varandra mycket farligare.

SQL-injektionen var inte det enda problemet. Det var kombinationen av SQL-injektion, bristande åtkomstkontroll, root-behörighet och en intern tjänst utan autentisering som gjorde att vi kunde komma så långt i attacken.

Det har förändrat hur jag ser på defense in depth. Det räcker inte att ha flera säkerhetslager om de enskilda lagren inte fungerar som de ska.

### Vad skulle jag göra annorlunda om projektet började idag?

Jag hade försökt dokumentera mer under tiden som arbetet pågick, i stället för att försöka komma ihåg och återskapa allt i efterhand.

Under penetrationstestet gick arbetet ganska snabbt och det var lätt att glömma att spara exakt output och tidsstämplar. Jag har förstått att dokumentation inte bara är viktig för att kunna skriva en bra rapport. Den behövs också för att kunna visa vad som faktiskt har hänt och göra om testerna vid ett senare tillfälle.

### Vad tar jag med mig till LIA och min framtida yrkesroll?

Det är framför allt två saker jag tar med mig. Den första är principen om minsta möjliga behörighet. Jag ser det inte längre bara som ett teoretiskt begrepp, utan som något man behöver tänka på i det dagliga arbetet. Man bör alltid fråga sig om en användare eller process verkligen behöver de rättigheter den har.

Den andra saken är att säkerhet måste testas och verifieras i praktiken. Att en CI/CD-pipeline visar grönt betyder bara att de kontroller som kördes gick igenom. Det betyder inte automatiskt att systemet är säkert.

---

## 10. Källor och referenser

- MITRE ATT&CK Framework: https://attack.mitre.org
- Google Cloud IAM-dokumentation: https://cloud.google.com/iam/docs
- Teamets pentestrapport och loggutdrag (2026-10-20).
- Teamets infrastrukturrepo: https://github.com/ITSX25-Chas/kurs6-team2-infra
- Claude (Anthropic) användes som stöd vid felsökning, tekniska resonemang och dokumentation. Förslagen kontrollerades mot den faktiska miljön och terminaloutputen.
