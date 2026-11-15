# KPI:er och säkerhetsmätningar

## Syfte och kursmål

I den här delen ska du ta fram tre KPI:er som kan användas för att följa upp säkerhetsläget eller effekten av säkerhetsarbetet.

Arbetet knyter an till:

- **Kursmål 4:** beskriva hur säkerhetsmätningar, KPI:er och compliance-rapportering används för att kommunicera säkerhetsstatus till ledningsnivå.
- **Kursmål 10:** producera säkerhetsmätningar och KPI-rapportering anpassad för en icke-teknisk beslutsfattare.

Utgå från projektets befintliga resultat. Du behöver inte skapa nya tekniska tester enbart för denna del.
---

## KPI 1

### Verifieringsgrad för automatiserade säkerhets- och applikationskontroller

### Syfte och mottagare
Att säkerställa hög kodkvalitet och förhindra att osäker kod (såsom SQL-injektioner eller osignerade container-images) når huvudgrenen.
Primär mottagare är CISO i organisationen, icke-teknisk beslutsfattare som har användning av denna information är exempelvis driftchef eller vd. Denna KPI hjälper organisationen att förstå hur arbetet med att säkra och minska sårbarheter i kodutvecklingen fortskrider, och säkerställande av att gamla fel inte dyker upp på nytt vid justeringar eller kompletteringar.

### Definition och beräkning
Mätetal: Procentandel helt lyckade och godkända pipeline-körningar i förhållande till det totala antalet initierade körningar i GitHub Actions.
Beräkning: (Antal helt lyckade pipeline-körningar (gröna) / Totalt antal startade pipelinekörningar) x 100

### Datakälla och datakvalitet
Datakälla är det totala antalet registrerade körningar från Workflows i GitHub, uppdelat på respektive status Success och Failure. Data kan aggregeras via GitHubs inbyggda insiktsverktyg (GitHub Insights) eller via GitHub API för att spåra trender över tid. För att datakällan ska vara 100% tillförlitlig krävs att felaktiga SQL-frågor, eventuella sårbarheter i koden och bristande container-signeringar är konfigurerade med blockering (fail-fast).

### Målvärde eller önskad riktning
Högre värde är bättre, antal lyckade körningar ska helst överstiga 95%, och att alla upptäckta säkerhetsavvikelser blockeras automatiskt.

### Mätfrekvens

En gång per månad.

### Tolkning och åtgärd vid avvikelse

Ett värde under 75% behöver åtgärdas omgående.

---

## KPI 2

### Responstid vid upptäckt intrångsförsök i SIEM 

### Syfte och mottagare
Denna KPI mäter organisationens snabbhet att reagera på skarpa eller potentiella hot. Den fokuserar på den kritiska tiden från larm till påbörjad åtgärd (isolering).
Primär mottagare är produktägaren, ytterligare mottagare kan vara CISO och driftchef samt vd. Denna KPI hjälper till att förstå det kvalitetsarbete som syftar till förbättring av säkerheten och förmågan att snabbt upptäcka och åtgärda intrångsförsök.

### Definition och beräkning
Mätetal: Tidsstämpel för påbörjad åtgärd minus Tidsstämpel för genererat larm i detektionssystem.

### Datakälla och datakvalitet
Datakällan är loggdata och incidenthanteringssystem (SIEM/SOAR).
Datakvaliteten är hög, men kräver tidssynkronisering på alla loggande system och automatisk tidsstämpling vid statusändring i incidentverktyget för att undvika manuell efterregistrering.

### Målvärde eller önskad riktning
- Kritiska larm (Severity High/Critical): Mindre än 15 minuter.
- Mindre kritiska larm: mindre än 2 timmar.

### Mätfrekvens
Uppföljning sker månadsvis (aggregerat), men avvikelser övervakas i realtid.

### Tolkning och åtgärd vid avvikelse
- Pågående larm: Eskalera till krisledning/Incident Response-team om det gäller ett pågående, ohanterat larm.
- Trender (vid missat månadsmål): Genomför en Root Cause Analysis (RCA). Beror det på underbemanning, för högt brus (false positives) i SIEM, eller otydliga processer? Justera därefter larmregler eller resursfördelning.

---

## KPI 3

### Automatiseringsgrad i leveranskedjan (DevSecOps-effektivitet)

### Syfte och mottagare
Minimera den manuella hanteringen och minska återställbarhetsrisken genom att driva allt via kod (Infrastructure as Code) och CI/CD-pipelines. Primär mottagare är produktägaren, ytterligare mottagare kan vara CISO, driftchef och vd. Denna KPI tydliggör förebyggande åtgärder för att minska risken för långa driftuppehåll vid eventuella serverkrascher eller annat avbrott i driften.

### Definition och beräkning
Beräkning: Antal (alternativt procentsats) manuellt uppsatta plattformskontroller eller distributionssteg som har migrerats till helt automatiserade, versionshanterade pipelines.

### Datakälla och datakvalitet
- En fullständig inventeringslista över samtliga plattformskontroller och distributionssteg (deploy-steg) som krävs för att sätta upp och drifta miljön.
- Status för varje steg (t.ex. ”Manuellt konfigurerat”, ”Skriptat men manuellt kört” eller ”Helt automatiserat via IaC/pipeline”).
- Versionshanterade filer (Terraform-kod, GitHub Actions, filer i .github/workflows) för att verifiera att stegen faktiskt ligger i kod.
- Data kommer dels från vårt GitHub-arkiv (infra-repot) där Terraform-konfigurationer och pipeline-definitioner lagras, dels driftmiljön från Google Cloud Platform där konfigurationsstatus från molnmiljön kan jämföras med kodbasen.
- Begränsningar är att även om ett steg är dokumenterat som automatiserat i Terraform, kan någon ha loggat in manuellt via GCP-konsolen eller kört kubectl direkt mot klustret för att göra akuta ändringar. Denna typ av manuella ingrepp syns inte i pipeline-loggarna utan kräver aktiva drift-avstämningar. Data från GitHub visar att koden finns där, men den mäter inte om automatiseringen faktiskt fungerar vid en skarp återställning (t.ex. ordningsföljden mellan manuella RBAC-installationer och policy-controllern).

### Målvärde eller önskad riktning
Målet är 0 manuella plattformskontroller i den nya miljön (allt ska kunna återskapas automatiskt). 
Alternativt att man mäter (antalet helt automatiserade plattformskontroller / totala antalet plattformskontroller) x 100, för att få en procentsats. 

### Mätfrekvens
En gång per månad.

### Tolkning och åtgärd vid avvikelse
Detta är ett successivt arbete under begränsad tid, med målsättningen att slutligen landa på 0. Ett värde över 0 är dock inget som kräver någon akut åtgärd.
---

## Samlad ledningsrapportering

Skälet till att jag valt just dessa KPI:er är att de hjälper till att minska risker orsakade av den mänskliga faktorn. Genom att införa vissa automatiserade kontroller, larmfunktioner och återställning, minskar man problem orsakade av stress, glömska och slarv.

- För den första KPI:n är det högre värden som är bättre. Om värdena fortsätter att ligga på en låg nivå, måste ytterligare åtgärder vidtas. För KPI nummer 2 vill man ha så kort tid så möjligt som genomsnittlig reaktionstid. För den sista KPI:n ska trenden ticka neråt mot noll (alternativt en procentsats nära hundra).
- Alla dessa KPI:er stöder en prioriterad förändring mot säkrare kod och säkrare miljö. Det går att följa en önskad trend mot det mål som är uppsatt.
- Som angivits ovan finns det svaga punkter i dessa KPI:er gällande data. För den första KPI:n behöver man inse begränsningarna med vad en godkänd körning innebär, och den andra KPI:n kräver att man verkligen får all data man behöver från loggar och system, och att bemanningen är adekvat. KPI nummer tre kräver återställningstester för att se att automatiseringen fungerar.
- Dessa KPI:er ger stöd för att fatta beslut om investeringar (SIEM) och personalförstärkningar. Det ger också stöd för prioritering av befintliga resurser, exempelvis att arbeta med strukturen i arbetsflödet i CI/CD-pipeline.

---

## Kontroll före commit

- [x] Jag har definierat tre relevanta KPI:er.
- [x] KPI:erna mäter mer än enbart genomförda aktiviteter.
- [x] Varje KPI har definition, datakälla och mottagare.
- [x] Varje KPI har ett målvärde, gränsvärde eller en önskad riktning.
- [x] Jag har beskrivit hur KPI:erna ska tolkas och följas upp.
- [x] Jag har beskrivit vad en avvikelse bör leda till.
- [x] Min rapportering är begriplig för en icke-teknisk beslutsfattare.
- [x] Jag har beskrivit KPI:ernas begränsningar.
