# Post-mortem, lessons learned och professionell sammanfattning

**Mottagare:** Comerit, systemägare och säkerhetsansvariga  
## Syfte och kursmål

Detta post-mortem analyserar ett simulerat Red Team-intrång i Acme-labben och
översätter erfarenheterna till förbättringar i Blue Team-arbetet. Dokumentet
examinerar kursmål 9 om incidentrespons, post-mortem och förbättringsarbete
samt kursmål 13 om att självständigt leda och leverera ett komplext
säkerhetsprojekt med kvalitet, dokumentation och professionell kommunikation.
Kursmål 13 synliggörs genom beskrivningen av planering, ansvar, uppföljning
och hur varje lärdom kopplas till en ägare, ett testfall och ett mätvärde.

## Händelse och avgränsning

Post-mortemet bygger på ett simulerat Red Team-intrång i den separat tilldelade
Acme-labben. Kedjan gick från en sårbar inloggningsfunktion till administrativ
åtkomst, kommandoinjektion, root i applikationscontainern och läsande åtkomst
till känsliga datakategorier. Händelsen upptäcktes genom kontrollerade HTTP-svar,
SQL-fel, diagnostikutdata och dokumenterade process- och databasobservationer.
Min roll var att genomföra tillåtna kontroller inom RoE, spara bevis, beskriva
attackkedjan och översätta observationerna till defensiva åtgärder. Detta är
inte en rapport om ett intrång i Comerits miljö och inga produktionsloggar
tolkas som bevis för att kedjan har inträffat där.

Avgränsningen innebär också att åtgärderna i detta post-mortem är
rekommendationer och testidéer. Under testfönstret ändrades inte måltavlan,
inga bakdörrar lades in och inga riktiga produktionshemligheter skulle ingå i
rapporten.

## Lesson learned 1 - En kontroll är inte färdig förrän den är reproducerbar

### Observation

Teamet verifierade att K3s, RBAC, image-policy och applikationsdeploy kunde
fungera i den nya miljön. Samtidigt dokumenterades att vissa delar, bland
annat policy-controller och delar av RBAC-konfigurationen, sattes upp manuellt
och inte fullt ut kunde återskapas från repositoryt.

### Orsak

Miljön flyttades till Comerits förberedda GCP-projekt. Ansvarsfördelningen
mellan teamets Terraform, Comerits grundmiljö och manuella driftsteg blev inte
helt synlig i samma kodflöde.

### Konsekvens

En grön kontroll i en körning är inte tillräcklig garanti för att miljön kan
återställas efter fel eller ändring. Manuella steg ökar risken för drift,
konfigurationsdrift och otydlig rollback.

### Förbättring

Versionshantera alla icke-hemliga manifest eller IaC, dokumentera ägare och
förutsättningar, och lägg till ett test som visar att kontrollen kan installeras,
verifieras och återställas i rätt ordning.

### Uppföljning

Plattformsägaren bör kunna visa ett reproducerbart installations- och
rollbacktest från versionshanterat underlag. Resultatet dokumenteras med
datum, commit, ansvarig och eventuella manuella förutsättningar.

## Lesson learned 2 - Minsta privilegium måste bevisas med negativa tester

### Observation

WIF ersatte statiska molnnycklar. Infra fick en privilegierad CI-identitet,
medan company-website fick separerade och begränsade identiteter. Kubernetes-
ServiceAccounten verifierades med `kubectl auth can-i`, bland annat för att
kontrollera att den inte fick läsa secrets.

### Orsak

Deploy, infra-administration och läsande kontroll har olika risknivåer och
behöver därför olika identiteter. Denna separation krävde samordning mellan
GitHub, GCP IAM och Kubernetes RBAC.

### Konsekvens

Blast-radien vid komprometterad pipeline minskar, men felaktiga eller
förändrade bindings kan fortfarande ge överbehörighet. En lyckad autentisering
visar inte att behörigheten är lämplig.

### Förbättring

Behåll en behörighetsmatris per repository och workflow. Kör både positiva och
negativa `auth can-i`-tester i samband med ändringar och dokumentera vem som
godkänt varje privilegierad identitet.

### Uppföljning

Vid nästa workflow-, IAM- eller RBAC-ändring ska både förväntad åtkomst och
förväntad nekad åtkomst testas. Resultatet ska sparas tillsammans med PR:en
och granskas av en namngiven ansvarig.

## Lesson learned 3 - Red Team-fynd ska omvandlas till förebyggande kontroller

### Observation

I den separata Acme-labben visade Red Team-kedjan hur SQL-injektion,
kommandoinjektion, SUID-konfiguration och hårdkodade databasuppgifter kunde
kopplas samman. Fynden dokumenterades med bevis, spår och rekommendationer.

### Orsak

Osäker indata nådde databas- och shell-logik, samtidigt som runtime- och
konfigurationsgränser gav fler möjligheter än nödvändigt.

### Konsekvens

En enskild brist kan bli allvarligare när den kombineras med svag identitet,
osäker runtime eller exponerade credentials. Lärdomen är relevant för
designen av Blue Team-kontroller, men labbfynden är inte bevis på sårbarheter
i Comerits miljö.

### Förbättring

Kombinera threat modelling, parametriserade frågor, negativ testning,
secret-scanning, minimal images, minsta runtimeprivilegium och tydliga
incidentindikatorer. Separera alltid labbresultat från verifierad produktions-
status i rapportering.

### Uppföljning

Varje förbättring ska kopplas till ett testfall, en ägare och ett mätvärde,
exempelvis lyckad negativ testning, policyavslag eller verifierad loggning.
Resultatet följs upp i backlog och i nästa post-mortem- eller övningsgenomgång.

## Professionell sammanfattning

Team 2 har under Blue Team-fasen byggt och försvarat en molnbaserad miljö med
Terraform, GitHub Actions, Workload Identity Federation, Kubernetes/K3s och
image-verifiering. Arbetet har minskat beroendet av statiska molnnycklar,
separerat infra- och applikationsbehörigheter och infört kontroller för
imageproveniens, SBOM och signering. Applikationshärdning och negativa tester
har dessutom använts för att minska risker i autentisering, profilåtkomst och
rendering.

Resultatet är en mer spårbar och försvarbar arkitektur, men inte ett bevis på
att alla risker är eliminerade. Kvarstående risker är framför allt beroendet
av manuella plattformssteg, behovet av återställnings- och rollbacktest,
fortlöpande IAM/RBAC-granskning samt ofullständigt verifierad övervakning och
larmkedja i den nya miljön.

Comerit bör prioritera tre saker: göra policy- och RBAC-installationen fullt
reproducerbar, införa kontinuerlig uppföljning med de föreslagna KPI:erna och
fastställa ägarskap för incidentrespons och återställning. De separata Red
Team-fynden från Acme-labben bör användas som testfall och designlärdomar,
inte rapporteras som intrång i Comerits miljö. Nästa beslut bör därför vara
vilka kontroller som ska vara obligatoriska före produktionsdeploy och vilken
evidens som krävs för att en risk ska kunna stängas.

För ledningen betyder detta att den tekniska kedjan bör översättas till
prioriterade beslut: vilka brister ska åtgärdas först, vilka loggar måste
samlas in och vem äger återställningen? Ett lyckat labbtest visar en möjlig
risk, men organisationen behöver därefter verifiera kontrollernas effekt i sin
egen miljö genom säkra negativa tester, mätbara KPI:er och återkommande
övningar.

## Incidentrespons och post-mortem

Detta avsnitt bygger på en simulerad Red Team-händelse i Acme-labben. Det är
inte en rapport om ett intrång i Comerits miljö och det finns inga påståenden
om att Comerits loggar faktiskt visade hela kedjan.

### Händelse och påverkan

Red Team kunde i labben följa en kedja från felaktig inputhantering till
administrativ åtkomst, kommandoinjektion, root i applikationscontainern och
läsande åtkomst till känsliga datakategorier. Påverkansbedömningen är därför
hög för konfidentialitet och integritet i labbscenariot.

### Förväntad detektion

Blue Team borde kunna leta efter en kombination av:

- ovanliga loginförfrågningar och SQL-fel,
- administrativa sessionsskapanden följt av diagnostikförfrågningar,
- skal- och SUID-processer från webbapplikationen,
- åtkomst till applikationsfiler och miljövariabler,
- oväntad databasautentisering och schemafrågor.

Enskilda loggrader är svagare än en korrelerad attackkedja. I vårt underlag
finns förväntade spår, men ingen komplett faktisk detektionsmätning från ett
SIEM. Detta är en viktig begränsning.

### Rekommenderad incidentrespons

1. Bekräfta mål, tidsfönster och om händelsen är labb eller produktion.
2. Bevara relevanta webb-, databas-, Kubernetes- och runtime-loggar.
3. Isolera eller stoppa den berörda applikationsvägen enligt incidentplan,
   utan att radera bevis.
4. Rotera exponerade credentials efter godkännande och kontrollera åtkomst
   från berörda identiteter.
5. Ta bort sårbar konfiguration, bygg en verifierad image och återställ från
   en känd god version.
6. Kontrollera att policy, RBAC, loggning och hälsokontroller fungerar efter
   återställning.
7. Dokumentera tidslinje, beslut, detektioner, missade signaler och åtgärder.

### Post-mortem och förbättringar

Post-mortemets viktigaste slutsats är att förebyggande kodfixar inte räcker
ensamma. Förbättringen måste också omfatta detektion, ansvar, återställning och
övning. Nästa övning bör använda den sanerade attackkedjan som testfall och
mätas med KPI:er för detektionstid, åtgärdstid och återställning. Dessa mått
ska först införas när datakällan och ägaren är beslutade.
