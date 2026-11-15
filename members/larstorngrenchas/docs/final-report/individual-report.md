# Individuell slutrapport

**Namn:** Lars Törngren
**Projekt/team:** Blue Team-projekt, Grupp 2
**Datum:** 2026-11-15

---

## Syfte och kursmål

I rapporten ska du sammanställa projektets resultat och dina egna reflektioner för en fiktiv ledningsgrupp. Du ska omsätta tekniskt säkerhetsarbete till mätbar uppföljning, förbättringsarbete och prioriterade rekommendationer. Du ska också värdera när AI är lämpligt eller olämpligt i professionellt säkerhetsarbete.

Rapporten knyter an till:

- **Kursmål 4:** säkerhetsmätningar, KPI:er och compliance-rapportering till ledningsnivå.
- **Kursmål 9:** incidentrespons, post-mortem och förbättringsarbete.
- **Kursmål 10:** KPI-rapportering för en icke-teknisk beslutsfattare.
- **Kursmål 11:** integrerad användning och professionell värdering av generativ AI och AI-assisterade säkerhetsverktyg.
- **Kursmål 13:** självständigt leda och leverera ett komplext säkerhetsprojekt med kvalitet, dokumentation och professionell kommunikation.

Bedömningen utgår från målgruppsanpassning, källanvändning, struktur, motivering och din förmåga att visa förståelse för helheten.

---

## 1. Professionell sammanfattning

Vi har genomfört en säkerhetsöversyn på företagets webbplats, för att identifiera och åtgärda sårbarheter som hotar verksamhetens konfidentialitet, integritet och tillgänglighet. Kritiska brister relaterade till obehörig åtkomst, dataläckage och hantering av känsliga uppgifter har åtgärdats och koden har skrivits om med moderna, säkra metoder vilket undanröjer dessa sårbarheter. Nedan visas de viktigaste rekommenderade åtgärderna, vilka vi i detalj går igenom längre ner i rapporten, samt hur uppföljning kan ske. I samband med presentation av rapporten, har vi också förslag på budgetering och resurstilldelning för att genomföra åtgärderna.

#### Strategiska rekommendationer och nästa steg i prioritetsordning
1.	Tydlig intern AI-policy och en styrningsstruktur för medarbetare.
2.	Integrera automatiska scanningar av all ny kod innan den tas i drift.
3.	Inför ett incidenthanteringssystem som övervakar IT-miljön i realtid.
4.	Standardisera IT-miljön så att all infrastruktur styrs via kod och eliminerar manuella ändringar i molntjänster.

#### Föreslagna nyckeltal för uppföljning
**Verifieringsgrad för säkerhetskontroller:** Mäter att de automatiserade testerna faktiskt körs vid varje kodändring.<br />
**Responstid vid larm:** Antal minuter från larm till att en säkerhetsåtgärd påbörjas.<br />
**Automatiseringsgrad:** Mäter hur stor del av infrastrukturen som styrs via kod.<br />

---

## 2. Kontext och avgränsning

Projektet går ut på att bygga och publicera en säker webbapplikation via GitHub, Docker, Kubernetes, Terraform och Google Cloud Platform. Syftet är att arbeta med molninfrastruktur i Google Cloud Platform (GCP), granska Terraform-kod ur ett säkerhetsperspektiv samt förbättra lösningen steg för steg genom ett agilt arbetsflöde. Tekniskt är projektet uppdelat i två repositories, ett som vi skapat inom gruppen, och ett som bygger på underlag från uppdragsgivaren (en zip-fil med ett repository). Det sistnämnda är själva webbapplikationen som vi alltså har tagit över, och utifrån detta gjort analys, genomfört säkerhetskontroller, vidtagit åtgärder och tagit fram förslag på ytterligare åtgärder. Applikationen är byggd med Flask, paketeras som en container i GitHub Container Registry (GHCR) och driftsätts kontrollerat till teamets K3s-kluster.

---

## 3. Mitt individuella bidrag

Mitt arbete har omfattat genomgång av aktuella repositories för att hitta säkerhetsproblem i koden. Jag konstaterade att den stora risken med det ursprungliga repot för ”Infra” är blocket som innehåller allAuthenticatedUsers. Jag skapade en issue med förslag på åtgärder, [issue #13](https://github.com/ITSX25-Chas/kurs6-team2-infra/issues/13) och [pull request #27](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/27). Jag analyserade sedan koden för Company Website och upptäckte bland annat felaktig användning av SQL-frågor vilket var sårbart för injection, hemligheter i klartext liggande i koden, felaktig hantering av lösenord, osäker användning av session cookies, samt osäker hantering av persondata på profilsida, och genomförde i samband med det [pull request #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29) [och pull request #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32). Sedan infogade jag alla gruppmedlemmar som ”SSH Users” i terraform.tfvars, och i samband med vårt arbete med övergång till WIF dokumenterade jag problem med användning av Service Account Key  (GSA_key_risks.md). Se vidare på länkarna här nedan. Jag fördjupade förståelsen för arbetsgången i GitHub. Efter ytterligare genomgång av repository för ”Company Website” så dokumenterade jag säkerhetsproblemen i två säkerhetsrapporter, uppdaterade backlog, och genomförde ett antal pull requests för att åtgärda olika funna problem, huvudsakligen kodändringar gällande Company Website. Dessutom gav jag bistånd med att införa Workload Identity Federation (WIF) som autentiseeringsmekanism i Google Cloud, lade ner en hel del arbete med att hitta flaggorna i tävlingen (Challenge), och att få proxy att fungera. Gällande samarbetet i gruppen, tog jag på mig ett ansvar att försöka få alla att komma med inpass till de beslut vi fattade, och stödja och uppmuntra kollegorna. Jonny var den som skötte våra repon på GitHub, och gjorde stora tekniska insatser med föredömlig dokumentation av gruppens arbete. Jag bidrog också med några sammanställningar av våra arbetsinsatser. Jag har även varit den som presenterat vårt arbete i olika sammanhang, exempelvis vid större zoom-möten.

Länkar:<br />
[Security adjustment to main.tf PR #3](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/3)<br />
[Feature SSH Users PR #19](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/19)<br />
[Issue #13](https://github.com/ITSX25-Chas/kurs6-team2-infra/issues/13)<br />
[Issue #16](https://github.com/ITSX25-Chas/kurs6-team2-infra/issues/16)<br />
[Removed block AllAuthenticatedUsers PR #27](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/27)<br />
[GSA Key Risks](https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/GSA_key_risks.md)<br />
[GSA Key Risks PR #21](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/21)<br />
[GSA Key Risks PR #24](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/24)<br />
[Team Work Summary](https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/team_work_summary_2026-10-01.md)<br />
[Team Work Summary PR #78](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/78)<br />
[Security adjustments top github-permissions.yaml PR #13](https://github.com/ITSX25-Chas/team2-company-website/pull/13)<br />
[Security report](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report.md)<br />
[Security report PR #14](https://github.com/ITSX25-Chas/team2-company-website/pull/14)<br />
[Security report addendum](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report-addendum.md)<br />
[Security report addendum PR #27](https://github.com/ITSX25-Chas/team2-company-website/pull/27)<br />
[Security update company website PR #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29)<br />
[More updates PR #30](https://github.com/ITSX25-Chas/team2-company-website/pull/30)<br />
[Even more updates PR #31](https://github.com/ITSX25-Chas/team2-company-website/pull/31)<br />
[Changes to deployment and dockerfile PR #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32)<br />
[Adjustments to product backlog PR #35](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/35)<br />

---

## 4. Viktigaste projektresultat och evidens

### Resultat 1
SQL injection och felaktigt lösenordsflöde i äldre login-kod. Löstes med parametriserade frågor, modern hash-verifiering och negativa autentiseringstester.

### Evidens 1
[MITRE ATT&CK, hotanalys, TLP-klassificering](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/mitre_ti_tlp_summary_2026-10-05.md)<br />
[Säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)<br />
[Changes to deployment and dockerfile PR #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32)<br />
[Security update company website PR #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29)<br />

### Verksamhets- och säkerhetsbetydelse 1
Risk för obehörig åtkomst, med potentiellt läckage eller förlust av data. Risk för att företagshemligheter kan bli avslöjade.

### Rekommendation 1
Koden har justerats så att denna sårbarhet är undanröjd. Rekommendation att införa åtgärder för kontroll av nyskapad kod, så att inte samma fel uppstår igen (se vidare under avsnittet om KPI:er och avsnittet med prioriterade rekommendationer).


### Resultat 2
Hårdkodad SECRET_KEY, seed-data och risk för hemligheter i kod/historik. Använd GitHub/Kubernetes-secrets, secret scanning och rotation om ett värde har exponerats.

### Evidens 2
[MITRE ATT&CK, hotanalys, TLP-klassificering](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/mitre_ti_tlp_summary_2026-10-05.md)<br />
[Säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)<br />
[Changes to deployment and dockerfile PR #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32)<br />
[Security update company website PR #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29)<br />

### Verksamhets- och säkerhetsbetydelse 2
Risk för röjande av hemligheter och konfidentiella uppgifter. Risk för att företagshemligheter kan bli avslöjade. Potentiellt exponderade lösenord behöver bytas, eftersom de kan ligga kvar i kodhistoriken.

### Rekommendation 2
Koden har justerats så att hemligheter inte är exponderade i koden, men lösenord och hemligheter behöver ändras eftersom de kan ligga kvar i kodhistoriken. Rekommendation att införa åtgärder för kontroll av nyskapad kod, så att inte samma fel uppstår igen (se vidare under avsnittet om KPI:er och avsnittet med prioriterade rekommendationer).

### Resultat 3
IDOR/bristande ägarkontroll vid profilåtkomst. Nu åtgärdad genom kontroll av behörig användare mot profil vid ändringar och vid e-postförhandsvisning.

### Evidens 3
[MITRE ATT&CK, hotanalys, TLP-klassificering](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/mitre_ti_tlp_summary_2026-10-05.md)<br />
[Säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)<br />
[Changes to deployment and dockerfile PR #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32)<br />
[Security update company website PR #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29)<br />

### Verksamhets- och säkerhetsbetydelse 3
Risk för obehörig åtkomst till personuppgifter, och potentiell manipulation av data. Stor risk för brott mot GDPR, som kan innebära stora böter.

### Rekommendation 3
Koden har justerats så att denna sårbarhet är undanröjd. Rekommendation att införa åtgärder för kontroll av nyskapad kod, så att inte samma fel uppstår igen (se vidare under avsnittet om KPI:er och avsnittet med prioriterade rekommendationer).

### Resultat 4
Trivy CronJob och Discord-rapportering i Kubernetes bekräftar Secret, RBAC, CronJob och testat larmflöde. Signerade images, SBOM och policykontroll minskar supply-chain-risk.

### Evidens 4
[MITRE ATT&CK, hotanalys, TLP-klassificering](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/mitre_ti_tlp_summary_2026-10-05.md)<br />
[Säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)<br />
[Automatiserad supply chain scanner PR #25](https://github.com/ITSX25-Chas/team2-company-website/pull/25)<br />

### Verksamhets- och säkerhetsbetydelse 4
Dessa kontroller gör arbetsflödet säkrare, och minskar risk för ”supply chain compromise”.

### Rekommendation 4
Vår rekommendation är att som en KPI införa kontroller av att dessa säkerhetsfunktioner verkligen fungerar i praktiken (se vidare under avsnittet om KPI:er och avsnittet med prioriterade rekommendationer).

---

## 5. KPI:er och ledningsrapportering

1. Verifieringsgrad för automatiserade säkerhets- och applikationskontroller, som syftar till att säkerställa hög kodkvalitet och förhindra att osäker kod (såsom SQL-injektioner eller osignerade container-images) når huvudgrenen. Detta är relevant för en icke-teknisk beslutsfattare genom att det ökar säkerheten för företagets både materiella och immateriella tillgångar. Det är också ett beslutsunderlag för prioritering av resurser för att förbättra arbetsflödet i CI/CD-pipeline. En begränsning är att en godkänd pipeline eller en kodåtgärd inte bevisar att alla kodvägar är säkra eller att applikationen är skyddad om den exponeras annorlunda i produktion. Datakällan mäter bara att testerna körs och täcker programkoden, däremot inte all potentiell exponering eller sofistikerade angreppskedjor.
2. Responstid vid upptäckt intrångsförsök i SIEM. Denna KPI mäter organisationens snabbhet att reagera på skarpa eller potentiella hot. Den fokuserar på den kritiska tiden från larm till påbörjad åtgärd (isolering). Detta är relevant för en icke-teknisk beslutsfattare genom att det ökar säkerheten för företagets systemarkitektur. Det kan fungera som ett beslutsunderlag både gällande investeringar (SIEM/SOAR) och gällande personalförstärkning.
3. Automatiseringsgrad i leveranskedjan (DevSecOps-effektivitet). Denna KPI tydliggör förebyggande åtgärder för att minska risken för långa driftuppehåll vid eventuella serverkrascher eller annat avbrott i driften. Det kan fungera som beslutsunderlag för att tillsätta mer resurser att utvidga automatisering. Begränsningar är att även om ett steg är dokumenterat som automatiserat i Terraform, kan någon ha loggat in manuellt via GCP-konsolen eller kört kubectl direkt mot klustret för att göra akuta ändringar. Denna typ av manuella ingrepp syns inte i pipeline-loggarna utan kräver aktiva drift-avstämningar. Data från GitHub visar att koden finns där, men den mäter inte om automatiseringen faktiskt fungerar vid en skarp återställning.

---

## 6. Incidentrespons, post-mortem och förbättringsarbete

Observationerna och erfarenheterna som beskrivs i denna rapport, har att göra med simulerade intrångsförsök i en miljö hos Company Website (en publik webbplats). De sårbarheter som beskrivs påverkade framförallt konfidentialitet och integritet hos systemet, men potentiellt även tillgänglighet.
Inloggningen på Company Website kunde kringås utan korrekt användarnamn eller lösenord. Man kunde dessutom obehörigen läsa användardata, manipulera användarkonton, och ladda ner databasen. Systemet använde inte ett korrekt lösenordsflöde, och det fanns risk för att kunna kringgå autentiseringen.
Detta åtgärdades med användning av parametriserade frågor, där SQL-förfrågan har ett visst antal givna parametrar med en platshållare för varje värde. Endast de förbestämda parametrarna kan finnas i SQL-frågan. Systemet använder nu starka, moderna kryptografiska algoritmer för att garantera att lösenord aldrig kan läsas eller verifieras felaktigt. Obehöriga användare kunde utnyttja profilsidan för att extrahera känslig information från databasen. Nu används strikt definierade, statiska variabler som blockerar obehörig datautlämning. Den justerade koden granskas av två personer i gruppen, innan den godkänns och implementeras. Förslag att minimera den manuella hanteringen och minska återställbarhetsrisken genom att driva allt via kod (Infrastructure as Code) och CI/CD-pipelines, införa automatiska säkerhetskontroller innan nya kodändringar rullas ut med en kontrollfunktion i CI/CD-pipeline (se KPI-dokument), samt införskaffa ett incidenthanteringssystem (SIEM eller SOAR) för att snabbt kunna detektera och åtgärda intrångsförsök. Dessa ändringar behöver följas upp genom de KPI:er som vi föreslagit. 

---

## 7. AI i säkerhetsarbetet

### Konkreta användningsfall

Jag har enbart använt gratisversioner av AI-verktyg i skolarbetet. Jag vet dock att betalversionerna är mer kompetenta och säkrare. Det är framförallt Gemini och Copilot som jag har använt, ibland i kombination för att kontrollera resultat från ett system mot ett annat. Jag har använt båda verktygen för att hjälpa till att ta fram kod. När jag har varit osäker på vad olika kodavsnitt åstadkommer, har jag bett om en förklaring från AI, och även bett om källhänvisning, så att jag har kunnat läsa mer på den aktuella webbplatsen. Jag har även i vissa fall använt AI för att förklara tekniska sammanhang, för att sammanfatta större textmängder, samt ibland att ge förslag på analys. Jag har alltid redigerat alla texter som AI har levererat, dels för att kontrollera innehållet, dels för att göra det till min egen text, och dels för att jag tycker att jag skriver bättre.

### När AI var lämpligt

För att spara tid använde jag AI som hjälp för att skapa en sammanfattning av mitt Red Team-arbete. Jag hade skapat ett omfattande dokument, med beskrivning av ett stort antal sårbarheter, MITRE ATT&CK-mappning, post mortem-redovisning, m. m. och ville snabbt få ett utkast till ”executive summary” som jag sedan kunde arbeta vidare med. Det tyckte jag fungerade bra, även om jag skrev om en hel del av texten. Det hjälpte mig att snabbt få in alla viktiga parametrar och fynd, så att jag inte glömde något. I detta fall var det fiktiv data, därför kände jag att jag kunde använda AI. Hade det varit ett verkligt fall hade jag inte gjort på det sättet, eftersom materialet innehöll fakta om upptäckta sårbarheter. Då hade jag fått skriva sammanfattningen helt manuellt. Detta sätter väl fingret på det motsägelsefulla. Just att sammanfatta stora textmängder är AI väldigt bra på. Men det är stor risk att det finns känslig data i materialet, som man kanske glömmer i stunden. Generellt är AI lämpligt för att förklara, sortera och strukturera data.

### När AI var olämpligt eller otillräckligt

Vid ett tillfälle i vårt Red Team-arbete tog jag hjälp av AI för att komma åt data som jag förstod skulle finnas på en adress jag hittat. Varken curl eller wget fanns tillgängliga, så då föreslog AI att använda perl, som också kan hantera nätverksanslutningar. Just detta var ett bra förslag (som jag givetvis även hade kunnat googla mig till). Men sedan fortsatte AI att föreslå olika metoder och undersökningsvägar som inte kändes bra att använda, då vi hade vårt scope som en avgränsning. Här hade jag kanske inte heller talat om för AI från början vad vårt scope innebar, så det kan ha varit mitt misstag också. När jag påtalade att jag kände mig osäker på om detta var utanför vårt scope, så höll AI med om det och tyckte att jag var ansvarsfull. Nu är det ju ofta så att AI håller med om mycket man skriver, speciellt om man ifrågasätter något. Så man får vara vaksam och verkligen utvärdera varje svar. Generellt är AI olämpligt för eget beslutsfattande, och egen riskbedömning.

### Verifiering och mänsklig kontroll

När jag använder AI så går jag alltid till de källor som AI använder för att generera sina förslag. Jag kanske inte kontrollerar alla webbplatserna (beroende på hur stor mängd det är), men åtminstone tre olika sajter går jag till. Oftast kan jag bedöma om ett svar är rimligt, men om jag inte kan det, ber jag AI specificera och utveckla svaret tills jag känner mig tillräckligt trygg, och har fått tillräcklig förståelse för att jobba vidare med resultatet. Ibland dubbelkollar jag med en annan AI.

### Risker och professionella gränser

En risk med generativ AI är att användare inte förstår hur den fungerar, kanske framförallt vilka begränsningar den har, och förlitar sig i alltför stor utsträckning på resultaten från AI. Dessutom kan information som matas in i en generativ AI hamna i orätta händer. En annan risk med AI är ”svarta lådan”-problemet, vilket innebär att det inte alltid går att fullt ut förstå hur AI-modellen har kommit fram till sitt svar. Hallucinationer betyder att AI hittar på svar som inte stämmer, utan är vilseledande eller felaktiga, vilket ibland kan vara svårt att upptäcka. Bias är ett tydligt problem, som har att göra med att det uppstår snedvridning beroende på fördomar som förekommer i träningsdatan. Vissa resultat som AI genererar kan dessutom innebära intrång i upphovsrätt eller immaterialrätt, vilket i värsta fall kan leda till processer och skadestånd.

### Professionell slutsats

För att minska riskerna med generativ AI behövs en tydlig styrningsstruktur. Medarbetarna behöver utbildas i hur man ska använda generativ AI i arbetet, att identifiera risker och inse att det är ett stödverktyg som inte ersätter mänskligt omdöme och sunt förnuft. 
- Säkerställ mänsklig inblandning och bedömning i viktiga steg vid användning av generativ AI. 
- Kräv att den modell som används tydligt redovisar sina steg i hur svaret genererats (chain-of-thought). 
- Övervakning av systemet med larm vid avvikelser, t. ex. om viss typ av data används i AI. Överväg att helt undanta viss typ av arbete från AI, om det innebär alltför stora risker att konfidentiell data kommer på avvägar. Exempel på sårbarheter är chat-botar som utsätts för prompt injection. Här finns även lagkrav, så ovarsam användning av AI kan dessutom innebära att organisationen kanske bryter mot lagen vid viss AI-användning. 
- Styr AI så att resultat under en viss sannolikhetsgrad inte genererar något svar alls (för att förhindra tvärsäkra men felaktiga svar). 
- Utvärdera användningen av AI regelbundet, för att se om kvaliteten förändras över tid. Spara loggar över användningen. 
- Kontrollera vilken version av modellen som används. 
- Använd AI-verktyg som erbjuder skade-ersättning om det är så att resultatet kränker någons upphovsrätt.

---

## 8. Prioriterade rekommendationer

#### 1. Etablera policy och styrningsstruktur för generativ AI

- Ta fram en tydlig intern AI-policy och en styrningsstruktur för medarbetare. Policyn bör inkludera obligatorisk utbildning, förbud mot insamling av konfidentiell data i publika AI-verktyg samt krav på ”chain-of-thought” (att modellen redovisar sina tankesteg). Systemen bör övervakas med larm vid avvikelser, och vissa kritiska riskbedömningar helt undantas från AI-användning. Inför loggning av AI-användning och versionskontroll.
- Detta bör göras för att AI-verktyg är kraftfulla verktyg, som är bra på att förklara, sortera och strukturera data, men medför stora risker kring dataläckage (om känslig information matas in i publika modeller), hallucinationer (påhittade svar), bias (snedvriden träningsdata) samt tekniska sårbarheter som prompt injections. 
- AI får aldrig ersätta mänskligt omdöme eller eget beslutsfattande. Därigenom minskas risker kring informationssäkerhet, immaterialrättsbrott och regulatoriska lagkrav. Användningen möjliggör tidsvinst och effektivisering vid exempelvis hjälp med kodning och textmanus, förutsatt att rigorös mänsklig verifiering och källkontroll tillämpas.
**Kritisk/Hög prioritet** (Bör införas omedelbart i takt med att verktygen används i det dagliga arbetet).<br />
**Ägare av nästa steg:** IT-säkerhetsansvarig (CISO)/Legal & Compliance.

#### 2. Automatisera säkerhetskontroller och kodgranskning i CI/CD-pipelinen

- Inför fasta kontrollfunktioner i CI/CD-pipelinen som automatiskt scannar nyskapad kod efter sårbarheter (såsom SQL-injektioner) och hemligheter (secret scanning). Etablera även en strikt process där all kod granskas av minst två personer innan godkännande. Som en KPI bör det mätas att dessa automatiserade kontroller faktiskt körs och fungerar i praktiken.
- Det här förhindrar att tidigare åtgärdade sårbarheter eller nya säkerhetsbrister (t.ex. hårdkodade nycklar eller felaktiga lösenordsflöden) letar sig in i huvudgrenen och produktionen igen.
- Denna åtgärd minskar risken för obehörig åtkomst, dataläckage, förlust av data samt ”supply chain compromise”. Det möjliggör högre och mer verifierbar kodkvalitet.
**Kritisk/Hög prioritet**  (Bör prioriteras högt då det säkrar det löpande utvecklingsarbetet).<br />
**Ägare av nästa steg:** Utvecklarteamet/DevOps-ansvarig.

#### 3. Införskaffa och konfigurera incidenthanteringssystem (SIEM/SOAR)

- Investera i och implementera ett incidenthanteringssystem (SIEM eller SOAR). Fokusera på att konfigurera larmflöden och mäta responstiden från upptäckt loggning/larm till påbörjad isolering eller åtgärd.
- Detta bör göras för att organisationen snabbt ska kunna detektera, larma om och hantera skarpa eller potentiella hot och intrångsförsök i realtid.
- Det här minskar risken för långdragna, oupptäckta intrång som hotar systemarkitekturen. Det ger ledningen ett tydligt beslutsunderlag för framtida investeringar och personalförstärkning.
**Hög prioritet**<br />
**Ägare av nästa steg:** IT-säkerhetsansvarig (CISO)/Infrastrukturteamet.

#### 4. Övergång till Infrastructure as Code (IaC) och eliminering av manuella ändringar

- Minimera den manuella hanteringen i molnkonsoler eller direkt mot klustret genom att driva all infrastruktur via kod (t.ex. Terraform) och CI/CD-pipeline. Genomför regelbundna drift-avstämningar för att säkerställa att inga manuella ändringar gjorts vid sidan av pipeline.
- Det här bör genomföras för att manuella ändringar inte syns i pipeline-loggarna och skapar en falsk trygghet. Genom att sätta upp allt som kod säkerställs att miljön går att återställa på ett snabbt och tillförlitligt sätt.
- Det minskar risker för fel vid återställning och risken för långa driftuppehåll vid eventuella serverkrascher eller andra avbrott.
**Medelhög prioritet**<br />
**Ägare av nästa steg:** Infrastrukturteamet/Cloud Architects.

---

## 9. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?
Jag har utvecklat min tekniska förståelse för hur man kan utnyttja sårbarheter både i koden, och i systemets konfiguration. I Red Team-arbetet tränade jag på att använda SQL Injection, command injection, att kringgå session cookies, att söka efter brister i konfigurationen av molnmiljön med mera. Det här gör att jag också har blivit bättre på att säkra den typen av luckor och svagheter i säkerhetsarbetet. Jag har även lärt mig traffic light protocol, ett system för att tydliggöra hur information i en säkerhetsrapport får delas.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?
I vårt arbete med både Red Team och Blue Team, så har jag fått en bredare förståelse för hur många områden där risker och sårbarheter kan uppstå. Jag är mer ödmjuk inför uppgiften, och inser hur svårt det är, speciellt i stora organisationer med många människor och många system, att verkligen täppa till alla hål. Detta gör prioriteringen till en av de viktigaste momenten i allt säkerhetsarbete. Förmågan att kunna se helheten, och snabbt kunna bedöma var sårbarheterna är som störst.

### Vad skulle jag göra annorlunda om projektet började idag?
Jag hade varit ännu mer noggrann med att tidsbestämma alla mina åtgärder (exempelvis i Red Team-attackerna), för att kunna koppla dessa till logg-poster. Och ännu mer noggrann att dokumentera vad jag gjorde i projektet. Men jag hade också önskat mig ett mer sammanhållet och kontinuerligt projekt, där allting hade varit kopplat till samma miljö. Som det nu har varit, hade vi en miljö för de första tre veckorna, en annan för vårt Blue Team-arbete, och en tredje miljö för Red Team. Vi hade ingen möjlighet att diskutera mellan Blue Team och Red Team (Purple Team), där den ena sidan kunde visa sina fynd samtidigt som den andra visade vad de gjorde på sin kant. Generellt under utbildningen har kontinuiteten saknats, vilket har påverkat situationen negativt. Samtidigt kan man givetvis också säga, att verkligheten är långt ifrån perfekt. Ute på företag och i andra organisationer finns också brister, som gör att det kanske saknas loggar, eller att en del av företaget inte genomfört åtgärder som en annan del är beroende av. Så det kanske har varit bra träning på det viset. Oförutsägbara händelser och misstag är en del av livet, ävenså i företag och offentlig verksamhet.

### Vad tar jag med mig till LIA och min framtida yrkesroll?
Att lyssna och resonera utifrån den information jag kan inhämta från organisationen. Att inse vilka begränsningar som finns, kunskapsmässigt, organisatoriskt, hierarkiskt, och tidsmässigt, men ändå försöka göra det bästa möjliga utifrån dessa förutsättningar. Att respektera den kompetens som finns på plats, och försöka använda mig av den för att förbättra saker. Att anstränga mig till det yttersta för att delge mina kunskaper och min kompetens där jag upptäcker luckor i organisationens samlade kompetens. Att försöka hitta bryggor mellan den kompetens som finns och den kompetens som saknas.
Två konkreta saker som jag kommer att använda är MITRE ATT&CK och TLP. Men jag kommer också att propagera för utbildning och träning av personalen, för att minska sårbarheten för phishing. Jag har förstått att mitt LIA-företag får stora mängder spam, där en ansenlig mängd också är phishing-försök. Ett relativt nytt fenomen är tydligen phishing via Teams, som jag ännu inte hunnit sätta mig in i.

---

## 10. Källor och referenser

Lista de källor du faktiskt har använt, exempelvis:

- standarder och ramverk,
- kursmaterial,
- teknisk dokumentation,
- loggar och projektartefakter,
- AI-genererat material när det har påverkat analysen eller texten.

Använd ett konsekvent sätt att ange källorna. Det ska gå att skilja mellan externa fakta, projektets evidens, AI-genererade förslag och dina egna bedömningar.

#### Ramverk och standarder:
[MITRE ATT&CK](https://attack.mitre.org/)<br />
[CWE MITRE](https://cwe.mitre.org/)<br />
[TLP FIRST](https://www.first.org/tlp/)<br />

#### Riktlinjer för AI-användning:
[DIGG Riktlinjer för AI-användning](https://www.digg.se/ai-for-offentlig-forvaltning/riktlinjer-for-generativ-ai/bedom-riskerna-med-anvandningen-och-sakerstall-lamplig-sakerhet)<br />
[FIIVE Risker med AI](https://www.fiive.se/blog/risker-med-ai)<br />

#### Kursmaterial:
[Ledningsrapportering och KIP:er](https://chasacademy.instructure.com/courses/583/pages/lasmaterial-vecka-13-ledningsrapportering-och-kpi-er?module_item_id=24899)<br />
[Incidentrespons och post-mortem](https://chasacademy.instructure.com/courses/583/pages/lasmaterial-vecka-12-incidentrespons-post-mortem-och-tlp?module_item_id=24894)<br />
[Självstudier v 11](https://chasacademy.instructure.com/courses/583/pages/sjalvstudier-vecka-11?module_item_id=24887)<br />
[Självstudier v 10](https://chasacademy.instructure.com/courses/583/pages/sjalvstudier-vecka-10?module_item_id=24865)<br />
[Självstudier v 9](https://chasacademy.instructure.com/courses/583/pages/sjalvstudier-vecka-9?module_item_id=24833)<br />

#### Projektets commits och pull requests:
[Team 2 Infrastruktur](https://github.com/ITSX25-Chas/kurs6-team2-infra/pulls)<br />
[Team 2 Company Website](https://github.com/ITSX25-Chas/team2-company-website/pulls)<br />

---

## Slutkontroll

- [x] Jag har tydligt beskrivit mitt eget bidrag och länkat till relevant underlag.
- [x] Mina viktigaste resultat stöds av evidens och källor.
- [x] Mina KPI:er är anpassade för en icke-teknisk beslutsfattare.
- [x] Mitt post-mortem leder till konkreta förbättringar och uppföljning.
- [x] Jag har beskrivit konkret AI-användning och självständigt värderat när AI är lämpligt eller olämpligt.
- [x] Jag har beskrivit hur AI-genererade resultat verifierades.
- [x] Mina rekommendationer följer av analysen och är prioriterade.
- [x] Den professionella sammanfattningen fungerar fristående.
- [x] Min individuella reflektion innehåller konkreta exempel.
- [x] Källor, länkar och referenser fungerar.
- [x] Inga lösenord, tokens, API-nycklar, personuppgifter eller andra skyddsvärda uppgifter finns i repositoryt.
- [x] Alla ändringar är committade och pushade till GitHub.
