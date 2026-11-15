# Individuell slutrapport

**Namn:** Jonny Nguyen  
**Projekt/team:** Team 2 - ITSX25  
**Datum:** 2026-11-03  
## Syfte och kursmål

Rapporten sammanställer projektets resultat, KPI-uppföljning, post-mortem,
förbättringsarbete och min värdering av AI i säkerhetsarbetet. Den är skriven
för en fiktiv ledningsgrupp och skiljer mellan verifierade projektresultat,
separat Acme-labb och egna bedömningar.

Rapporten examinerar de uppdaterade kursmålen 4, 9, 10, 11 och 13:
säkerhetsmätningar och compliance-rapportering, incidentrespons och
post-mortem, KPI-rapportering för icke-tekniska beslutsfattare, professionell
användning av generativ AI samt förmågan att självständigt leda och leverera
ett komplext säkerhetsprojekt. MITRE ATT&CK- och threat intelligence-
materialet behålls som stödjande evidens från projektet och Red Team-labben,
men framställs inte som ett separat examinerande kursmål i denna uppgift.

## 1. Professionell sammanfattning

Team 2 har byggt och försvarat en molnbaserad miljö med Terraform, GitHub
Actions, Workload Identity Federation, Kubernetes/K3s och kontroller för
container-images. De viktigaste resultaten är att statiska molnnycklar har
ersatts med federerad autentisering, att infra- och applikationsbehörigheter
har separerats och att image-signering, SBOM och policyverifiering har använts
som delar av leveranskedjan.

Arbetet har förbättrat spårbarhet och minskat blast-radien vid fel, men vissa
kontroller är fortfarande beroende av manuella plattformssteg. Fullständig
reproducerbarhet, rollback, IAM/RBAC-granskning och aktuell larmtäckning måste
följas upp. Red Team-fynden från den separata Acme-labben visar varför
parametriserade frågor, säker shell-användning, minimal runtimebehörighet och
secret-hantering behöver behandlas som en sammanhängande kedja. De fynden är
inte bevis på sårbarheter i Comerits miljö.

Min rekommendation är att organisationen prioriterar en reproducerbar
plattform, minsta privilegium och mätbar uppföljning. De tre KPI:erna följer
upp åtgärd av höga fynd, identitetsbehörigheter och policygodkända images. De
kan stödja beslut om riskprioritering, ansvar och stopp av deploy, men behöver
kompletteras med incidentloggar, negativa tester och rollbackövningar.

För ledningen är den viktigaste slutsatsen att säkerhet inte kan bedömas med
en enda grön pipeline eller ett enskilt skanningsresultat. Tillförlitlig status
kräver en kedja av evidens: rätt identitet, rätt policy, rätt image, fungerande
detektion och möjlighet att återställa. Därför bör kvarstående osäkerhet
rapporteras öppet och få en ägare i stället för att döljas bakom ett numeriskt
resultat.

## 2. Kontext och avgränsning

Projektet omfattade en teamägd infrastruktur- och applikationsmiljö som först
byggdes och försvarades under Blue Team-fasen och senare flyttades till
Comerits förberedda GCP-miljö. Arbetet omfattade nätåtkomst, Terraform-state,
WIF, CI/CD, OS Login/IAP, K3s, Kubernetes-RBAC, app-deploy, SBOM, Trivy och
Sigstore-baserad imageverifiering.

Rapporten bygger på versionshanterad kod, PR:er, Actions-körningar,
säkerhetsrapporter, kursmaterial och dokumenterade driftkontroller. Red
Team-testet utfördes mot en separat, tilldelad Acme-labbmiljö. Den miljön
används som lärandeunderlag och ska inte blandas ihop med statusen i Comerits
GCP-projekt. Där extern eller aktuell driftsevidens saknas anges det som en
begränsning i stället för att fylla i med antaganden.

Comerits förberedda grundmiljö, teamets repositories och den separata
utbildningslabben är alltså tre olika evidensnivåer. Jag använder endast
Comerit-underlag för påståenden om plattformen och Acme-underlag för
Red Team-lärdomar. Denna avgränsning är viktig för att rapporten inte ska
blanda simulerade fynd med verkliga produktionsincidenter.

## 3. Mitt individuella bidrag

Jag arbetade med att förstå, verifiera och dokumentera säkerhetsarbetet över
hela kedjan. I infra-repot bidrog jag bland annat till grundläggande
Terraform- och gitignore-arbete, WIF och borttagning av tidigare
service-account-nyckel, separering av CI-behörigheter, begränsad SSH/OS Login
samt dokumentation av Comerits miljöbyte.

I company-website-arbetet bidrog jag till analys av applikationshärdning,
image-signering och policyverifiering. Jag använde PR-historik,
Actions-resultat, Kubernetes-kontroller och hälsokontroller för att skilja
mellan verifierade resultat och antaganden. När miljöbytet gav åtkomst- eller
deployproblem följde jag felsökningen stegvis tillsammans med gruppen och
dokumenterade skillnaden mellan en grön kodkontroll och faktiskt verifierad
drift.

Under Red Team-fasen dokumenterade jag den tillåtna attackkedjan från
login-analys till intern databasåtkomst i Acme-labben. Jag använde Codex som
pedagogiskt stöd för struktur, riskförklaring och dokumentation, men granskade
förslagen och utförde endast kontroller inom godkänd RoE.

### Projektledning och kvalitetssäkring

Jag synkade brancher, kontrollerade ändringar mot main, samordnade granskning
före merge och höll dokumentationen uppdaterad när miljön eller instruktionerna
ändrades. Jag verifierade först scope och åtkomst, därefter kod,
Actions-resultat, Terraform/Kubernetes-underlag och slutligen evidensen.
När underlaget inte räckte markerade jag det som en begränsning i stället för
att presentera ett antagande som verifierat resultat.

### Identifierbara projektartefakter

Följande länkar visar delar av arbetet som går att följa i Git-historiken och
projektets dokumentation:

- [WIF-konfiguration i infra](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/64ffba5)
- [Borttagning av service-account-nyckel](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/d327e82)
- [Separering av IAM från deploy](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/f313d7c)
- [Company-website: verifierad deploy-identitet](https://github.com/ITSX25-Chas/team2-company-website/commit/035fe53)
- [Sanerad Red Team-evidens](./red-team-evidence.md)

Länkarna ger spårbarhet utan att varje commit ensam representerar hela mitt
individuella bidrag.

## 4. Kompletterande threat intelligence och actionable intelligence

Följande tre prioriterade analysresultat bygger på Red Team-arbetet i den
separata Acme-labben. De ska inte tolkas som bevis på intrång i Comerits
miljö. TLP bedöms för den sanerade rapporteringen, inte som en klassificering
av hela GCP-miljön.

### Prioriterat resultat 1 - SQL-injektion och autentiseringsbypass

**Hot eller observation:** Login-funktionen reagerade med ett databassyntaxfel
vid kontrollerad specialteckenindata och en senare kontrollerad request gav en
administrativ session.  
**MITRE ATT&CK-koppling:** T1190 - Exploit Public-Facing Application.  
**Evidens och källor:** HTTP-svar och tidsstämplad Red Team-evidens i
[`red-team-evidence.md`](./red-team-evidence.md), inom godkänd RoE.  
**TLP-klassificering:** TLP:CLEAR för den sanerade rapporten eftersom den inte
innehåller credentials, tokens eller personuppgifter. Råloggar med känsliga
detaljer ska få en separat delningsbedömning.  
**Bedömning och betydelse:** Bristen kan påverka konfidentialitet och
integritet eftersom autentisering och databasfråga påverkas av samma indata.
Detta är hög konfidens i labbscenariot, men ingen produktionsobservation.  
**Actionable intelligence:** Använd parametriserade queries, serverstyrd
session och negativa tester för specialtecken. Larma på upprepade SQL-fel och
koppla dem till efterföljande administrativa sessionsskapanden.

### Prioriterat resultat 2 - Kommandoinjektion via diagnostikfunktion

**Hot eller observation:** En administrativ diagnostikfunktion använde
användarstyrd host-indata i en shellbaserad ping-kedja. Kontrollerad output
visade att ytterligare kommandon kunde påverka processen.  
**MITRE ATT&CK-koppling:** T1059.004 - Unix Shell.  
**Evidens och källor:** HTTP-svar från Acme-labben, process- och
runtimeobservationer i [`red-team-evidence.md`](./red-team-evidence.md).  
**TLP-klassificering:** TLP:CLEAR för den sanerade bilagan; detaljerade
råloggar bör begränsas om de innehåller åtkomstvägar eller känsliga värden.  
**Bedömning och betydelse:** En webbtjänst som kan starta shellkommandon får
en större attackyta och kan exponera runtime, filer eller nätverksanslutningar.
  
**Actionable intelligence:** Ta bort shellanrop eller använd strikt validerad
IP-/hostnamehantering med fast argumentlista. Larma på skalprocesser som
startas av webbapplikationen och verifiera att diagnostikfunktionen körs utan
onödiga privilegier.

### Prioriterat resultat 3 - Runtime- och secret-exponering efter fotfäste

**Hot eller observation:** I labbmiljön kunde runtime-identitet, container-
kontext, databasanslutning och hårdkodade databasuppgifter observeras. En
SUID-baserad kontroll visade dessutom effektiv root i containern.  
**MITRE ATT&CK-koppling:** T1552.001 - Credentials In Files och T1548.001 -
Setuid and Setgid.  
**Evidens och källor:** Dokumenterad output i
[`red-team-evidence.md`](./red-team-evidence.md) och den tillhörande RoE:n.  
**TLP-klassificering:** TLP:CLEAR endast för den sanerade versionen. Faktiska
credentials eller återanvändbara åtkomstuppgifter ska aldrig publiceras.  
**Bedömning och betydelse:** Exponerade secrets och överflödiga privilege-
mekanismer kan förlänga en attackkedja. Resultatet är hög konfidens i labben,
men ska inte beskrivas som en Comerit-finding.  
**Actionable intelligence:** Flytta secrets till säker secret-hantering,
rotera exponerade värden, bygg minimala images, inventera SUID och verifiera
att containergränser samt runtime-logs ger tillräcklig detektion.

## 5. Viktigaste projektresultat och evidens

Detta avsnitt motsvarar rapportmallens huvuddel för projektresultat. Avsnitt 4
är ett kompletterande analysunderlag från Red Team-labben och ska läsas som
stöd för rekommendationerna, inte som bevis på en produktionsincident.

### Resultat 1 - Federerad och separerad CI/CD-identitet

**Resultat:** WIF används i stället för statiska GCP-nycklar. Infra och
company-website har separerade identiteter med olika behörighetsnivåer.

**Evidens:**

- [WIF-konfiguration i infra](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/64ffba5)
- [Borttagning av service-account-nyckel](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/d327e82)
- [Separering av IAM från deploy](https://github.com/ITSX25-Chas/kurs6-team2-infra/commit/f313d7c)
- [Company-website: verifierad deploy-identity](https://github.com/ITSX25-Chas/team2-company-website/commit/035fe53)

**Verksamhets- och säkerhetsbetydelse:** En komprometterad workflow-token får
inte automatiskt full projektadministration. Det minskar blast-radien, men
WIF-villkor och IAM måste fortfarande granskas.

**Rekommendation:** Behåll separata service accounts, dokumentera en
behörighetsmatris och kör negativa IAM/RBAC-tester vid varje förändring.
**Prioritet:** Hög. **Ägare:** plattformsägare tillsammans med
säkerhetsansvarig.

### Resultat 2 - Imageproveniens och policykontroll

**Resultat:** Pipeline och Kubernetes-policy används för att koppla
produktionsimages till signering och godkänd källa. En image utan matchande
policy nekades i en kontrollerad dry-run.

**Evidens:**

- [Image-signering och verifiering](https://github.com/ITSX25-Chas/team2-company-website/commit/94acaa2)
- [Policyverifiering](https://github.com/ITSX25-Chas/team2-company-website/commit/89e7ada)
- [Supply-chain-dokumentation](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/workshop4_supply_chain_scanner.md)

**Verksamhets- och säkerhetsbetydelse:** Det blir svårare att oavsiktligt eller
medvetet deploya en image som saknar förväntad provenance. Kontrollen är dock
bara stark om policy, signering, RBAC och rollback kan återskapas.

**Rekommendation:** Versionshantera policy- och RBAC-underlaget, mät
policygodkända deployer och testa godkänd image, nekad image och återställning.
**Prioritet:** Hög. **Ägare:** DevSecOps-/plattformsteamet.

### Resultat 3 - Red Team-kedjan visar behovet av försvar i flera lager

**Resultat:** Acme-labben demonstrerade en kedja från SQL-injektion och
kommandoinjektion till root i en container och läsande åtkomst till känsliga
datakategorier.

**Evidens:** Detta är dokumenterat i den sanerade
[`red-team-evidence.md`](./red-team-evidence.md) från 2026-10-27. Det är ett
separat labbunderlag och inte ett påstående om intrång eller sårbarhet i
Comerits miljö.

**Verksamhets- och säkerhetsbetydelse:** Angreppskedjan visar att
inputvalidering, identitet, runtimebehörighet, secret-hantering och
databasåtkomst måste bedömas tillsammans.

**Rekommendation:** Återanvänd kedjan som defensiva testfall: parametriserade
frågor, inga shellanrop med användarindata, minimala images, inga onödiga
SUID-bitar och secrets utanför källkod. **Prioritet:** Hög i labbens
förbättringsarbete. **Ägare:** applikationsägare och plattformsägare.

## 6. KPI:er och ledningsrapportering

Jag valde tre KPI:er: kritiska och höga fynd åtgärdade inom SLA,
behörighets- och identitetskontroller med minsta privilegium samt
policyverifierade och spårbara container-images. Tillsammans mäter de
riskreduktion, åtkomstkontroll och leveranskedjans integritet.

KPI:erna är relevanta för en icke-teknisk beslutsfattare eftersom de kan
översättas till tre frågor: minskar riskerna i tid, har rätt identiteter rätt
åtkomst och når endast verifierade komponenter produktion? De kan stödja
prioritering, resursbeslut, ägarskap och beslut om att stoppa en deploy.

Begränsningen är att projektet inte har en fullständig, enhetlig historisk
baslinje för alla tre KPI:er. Vissa IAM-, logg- och rollbackkontroller måste
verifieras vid nya mätningar. Därför ska rapporteringen visa datakälla,
datakvalitet och statusen **ej verifierad** när underlaget inte räcker. Den
fullständiga definitionen finns i [`kpi.md`](./kpi.md).

## 7. Incidentrespons, post-mortem och förbättringsarbete

Post-mortemet gäller ett simulerat Red Team-intrång i Acme-labben, inte en
incident i Comerits miljö. Händelsen upptäcktes genom kontrollerade HTTP-svar,
SQL-fel och diagnostikutdata. Den rekommenderade hanteringen är att bekräfta
scope och tidslinje, bevara webb-, databas- och runtime-loggar, isolera den
berörda vägen utan att radera bevis, rotera exponerade credentials efter
godkännande, bygga en verifierad image och kontrollera återställningen.

De viktigaste orsakerna var osäker indata, för stora runtime-möjligheter,
exponerade konfigurationsuppgifter och bristande lagerseparation. Viktiga
förbättringar är parametriserade queries, säker diagnostik, secret-hantering,
minimal runtimebehörighet, reproducerbar policy/RBAC och korrelerad loggning.
Uppföljning ska ske genom konkreta negativa tester, policyavslag,
rollbackövningar och namngivna ägare. Detaljerna finns i
[`lessons-learned.md`](./lessons-learned.md).

## 8. AI i säkerhetsarbetet

### Konkreta användningsfall

Jag använde Codex som en AI-assistent för att strukturera rapporter, förklara
Terraform-, GCP-, Kubernetes- och säkerhetsbegrepp, jämföra kursmallar,
formulera pedagogiska meddelanden och föreslå hur tekniska observationer kunde
kopplas till KPI:er, MITRE ATT&CK och TLP. Under Red Team-fasen användes AI
också för att organisera tidsstämplade observationer och skilja mellan
verifierad labbevidens och hypotetiska nästa steg.

### När AI var lämpligt

AI gav särskilt värde när materialet var omfattande och behövde struktureras
till en begriplig rapport. Det var lämpligt att be om förklaringar av varför
en kontroll, ett kommando eller en ATT&CK-koppling var relevant, och därefter
kontrollera svaret mot kursmaterial, officiell dokumentation, kod och verklig
kommandoutdata. AI fungerade också bra för språkgranskning och för att anpassa
tekniskt innehåll till en ledningsgrupp.

### När AI var olämpligt eller otillräckligt

AI fick inte ensam avgöra om en sårbarhet var verklig, om en IAM-policy gav
rätt åtkomst eller om en deploy var säker. Det fick inte heller ersätta RoE,
mänskligt godkännande eller direkt verifiering i målmiljön. Vid Red Team-
arbete hade ett generellt AI-förslag kunnat bli för aggressivt eller hamna
utanför scope, och därför användes endast kontrollerade steg som passade den
godkända avgränsningen.

### Verifiering och mänsklig kontroll

Jag kontrollerade AI-förslag mot Git-diffar, PR:er, Actions-resultat,
Terraform- och Kubernetes-manifest, `kubectl auth can-i`, hälsokontroller,
HTTP-svar och tidsstämplad output. Jag skiljde uttryckligen mellan vad som
fanns i en källa, vad som var en rimlig tolkning och vad som bara var ett
förslag. Felaktiga eller obestyrkta formuleringar togs bort.

### Risker och professionella gränser

De viktigaste riskerna är hallucinationer, felaktiga ATT&CK-mappningar,
övertro på övertygande text, informationsläckage och bristande spårbarhet.
Lösenord, tokens, privata loggar och andra skyddsvärda uppgifter ska inte
skickas till en AI-tjänst. AI kan dessutom ge råd som är tekniskt möjliga men
olämpliga enligt scope, lag, etik eller ändringsstopp.

### Professionell slutsats

Jag skulle använda AI som ett granskningsbart hjälpmedel för struktur,
pedagogik, hypoteser och defensiva rekommendationer. Jag skulle behålla
mänskligt ansvar för scope, riskbedömning, testval, evidens, prioritering och
slutlig rapport. Varje säkerhetskritisk slutsats ska kunna förklaras utan att
AI-svaret används som enda källa.

I praktiken innebär det att jag först formulerar frågan med tydligt scope,
därefter använder AI för ett avgränsat förslag och till sist kontrollerar varje
relevant påstående. Om informationen är känslig, om åtgärden kan påverka drift
eller om resultatet måste fungera som revisionsbevis ska jag hellre använda en
godkänd intern källa eller genomföra ett manuellt test. AI ökar alltså min
arbetsförmåga, men flyttar inte ansvaret för beslutet.

## 9. Prioriterade rekommendationer

1. **Gör policy-controller, RBAC och andra manuella driftsteg reproducerbara.**
   Detta minskar konfigurationsdrift och förbättrar rollback. **Prioritet:**
   Hög. **Ägare:** plattformsägare.
2. **Behåll separata WIF- och service-account-behörigheter och följ upp dem
   med positiva och negativa tester.** Detta begränsar blast-radien.
   **Prioritet:** Hög. **Ägare:** IAM-/plattformsteamet.
3. **Inför KPI-uppföljning med datakvalitet, namngivna ägare och tydliga
   avvikelseåtgärder.** Detta gör säkerhetsstatus användbar för ledningen.
   **Prioritet:** Medel. **Ägare:** systemägare och säkerhetsansvarig.
4. **Verifiera rollback, återställning och larmkedja med övningar.** Det visar
   om arkitekturen fungerar efter ett fel, inte bara före. **Prioritet:** Hög.
   **Ägare:** drift- och incidentansvarig.

## 10. Individuell reflektion

### Vad kan jag nu som jag inte kunde när kursen började?

Jag kan nu följa en säkerhetskontroll från kod och IAM till pipeline, image,
Kubernetes och verifierad drift. Jag kan också bedöma skillnaden mellan en
grön pipeline, en fungerande applikation och en faktiskt säker och
återställbar miljö. Under kursen har jag lärt mig att evidens behöver vara
spårbar till en commit, ett kommando, en logg eller ett annat verifierbart
underlag.

### Vilket moment har förändrat mitt sätt att arbeta med cybersäkerhet mest?

Red Team-fasen förändrade mitt sätt att tänka mest. Jag såg konkret hur flera
små brister kan bilda en kedja: indata kan påverka SQL, en session kan ge
administrativ åtkomst, en diagnostikfunktion kan ge shellåtkomst och runtime-
eller secret-problem kan göra konsekvensen större. Det gjorde det lättare att
förstå varför förebyggande kontroller, minsta privilegium, loggning och
incidentrespons måste behandlas som delar av samma säkerhetsmodell.

### Vad skulle jag göra annorlunda om projektet började idag?

Jag skulle från början skapa en gemensam evidensmatris med kontroll, ansvarig,
datakälla, förväntat resultat, negativt test och rollback. Jag skulle också
skilja labb, historiska fynd och aktuell produktionsstatus tidigare i
dokumentationen. Dessutom skulle jag definiera KPI-baslinje och ägarskap
innan mätningen började, eftersom det annars blir svårt att avgöra om en
förändring är verklig eller bara beror på olika datakällor.

### Vad tar jag med mig till LIA och min framtida yrkesroll?

Jag tar med mig förmågan att arbeta stegvis inom en tydlig avgränsning och att
dokumentera medan arbetet pågår. Jag tar också med mig att kommunicera risk
till både tekniska och verksamhetsnära mottagare genom resultat, betydelse,
KPI och prioriterad rekommendation. Slutligen tar jag med mig en mer kritisk
syn på AI: det kan öka min förståelse och effektivitet, men jag måste själv
kontrollera källor, scope och konsekvenser.

Jag vill också fortsätta använda en arbetsmetod där varje viktig slutsats kan
spåras bakåt: vad observerades, vilket test gav observationen, vilken risk
innebär den och vem kan göra något åt den? Det gör samarbetet enklare, minskar
risken för missförstånd och gör det möjligt att förklara mina beslut även när
den ursprungliga arbetsmiljön inte längre finns kvar.

## 11. Källor och referenser

### Projektets evidens

- [Teamets Blue Team-säkerhetsrapport](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)
- [Supply Chain Security Scanner](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/workshop4_supply_chain_scanner.md)
- [K3s-plattform i Comerits miljö](https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/comerit_k3s_platform.md)
- [Gemensam anslutningsguide](https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/gemensam_anslutningsguide.md)
- [Sanerad Red Team-evidens](./red-team-evidence.md)

### Externa och kursrelaterade källor

- [MITRE ATT&CK](https://attack.mitre.org/)
- Kursens mallar och uppgiftsinstruktioner för avslutande rapportering.

### AI och egna bedömningar

Codex användes som AI-assistent för struktur, pedagogiska förklaringar,
språkgranskning och förslag. AI-förslag behandlades inte som självständig
evidens utan kontrollerades mot ovanstående projektkällor, kommandoutdata och
egna bedömningar.

## Slutkontroll

- [ ] Jag har tydligt beskrivit mitt eget bidrag och länkat till relevant underlag.
- [ ] Min threat intelligence använder MITRE ATT&CK korrekt.
- [ ] Jag har motiverat TLP-klassificeringen.
- [ ] Min actionable intelligence är konkret, prioriterad och genomförbar.
- [ ] Mina viktigaste resultat stöds av evidens och källor.
- [ ] Mina KPI:er är anpassade för en icke-teknisk beslutsfattare.
- [ ] Mitt post-mortem leder till konkreta förbättringar och uppföljning.
- [ ] Jag har beskrivit konkret AI-användning och självständigt värderat när AI är lämpligt eller olämpligt.
- [ ] Jag har beskrivit hur AI-genererade resultat verifierades.
- [ ] Mina rekommendationer följer av analysen och är prioriterade.
- [ ] Den professionella sammanfattningen fungerar fristående.
- [ ] Min individuella reflektion innehåller konkreta exempel.
- [ ] Källor, länkar och referenser fungerar.
- [ ] Inga lösenord, tokens, API-nycklar, personuppgifter eller andra skyddsvärda uppgifter finns i repositoryt.
- [ ] Alla ändringar är committade och pushade till GitHub efter granskning och godkännande.
