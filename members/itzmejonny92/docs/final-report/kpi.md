# KPI:er och säkerhetsmätningar

**Mottagare:** Comerit, systemägare och säkerhetsansvariga  
**Kontext:** Team 2:s Blue Team-arbete och tillhörande Red Team-lärdomar  
**Kursmål:** 4 och 10 – säkerhetsmätningar, KPI:er och ledningsrapportering
anpassad för en icke-teknisk beslutsfattare.

## KPI 1 - Kritiska och höga fynd åtgärdade inom SLA

### Syfte

KPI:n visar om identifierade säkerhetsrisker faktiskt minskar inom en
överenskommen tid. Den mäter effekt och riskreduktion, inte bara hur många
ärenden som har skapats.

### Definition och beräkning

```text
Antal stängda kritiska/höga fynd inom överenskommen SLA
dividerat med totalt antal kritiska/höga fynd med passerad SLA
gånger 100
```

Ett fynd räknas som stängt först när åtgärden är implementerad, granskad och
verifierad med ett test eller annat tydligt bevis. Ett dokumenterat beslut att
acceptera en risk ska inte räknas som åtgärdat.

### Datakälla

GitHub Issues, säkerhetsrapporter, pull requests, testresultat och
product-backlog i infra- och company-website-repona.

### Datakvalitet

Underlaget finns i flera dokument, PR:er och backloggar och är därför inte
automatiskt enhetligt. En baslinje behöver fastställas innan KPI:n används som
ett jämförbart trendmått. Ett fynd får bara räknas som åtgärdat när det finns
verifierbar evidens.

### Målvärde eller önskad riktning

Minst 90 procent inom SLA och ingen kritisk risk utan ägare eller beslutad
riskacceptans. Riktningen ska vara stigande över tid.

### Mätfrekvens

Mät varje sprint och rapportera månadsvis till systemägare, IT-ansvarig och
säkerhetsansvarig.

### Mottagare

Systemägare, IT-ansvarig och säkerhetsansvarig. Resultatet ska sammanfattas
för ledningen utan att mottagaren behöver läsa tekniska kommandon eller
enskilda ärenden.

### Tolkning

Ett högt värde visar att risker minskar inom beslutad tid. Ett lågt värde kan
indikera bristande prioritering, otydligt ägarskap eller otillräcklig kapacitet
och ska därför analyseras tillsammans med ålder och allvarlighetsgrad.

### Åtgärd vid avvikelse

Tilldela en ägare, prioritera fyndet i backloggen, dokumentera orsaken till
förseningen och eskalera kritiska fynd utan planerad åtgärd.

## KPI 2 - Behörighets- och identitetskontroller med minsta privilegium

### Syfte

KPI:n visar om CI/CD och Kubernetes använder rätt identitet och rätt
behörighetsnivå. Målet är att en komprometterad pipeline inte automatiskt ska
kunna administrera hela molnprojektet eller läsa applikationshemligheter.

### Definition och beräkning

```text
Antal granskade identitetskopplingar som uppfyller WIF-, RBAC- och
minsta-privilegium-kraven dividerat med totalt antal granskade kopplingar
gånger 100
```

En kontroll ska bland annat verifiera rätt GitHub-repository, rätt workflow,
rätt service account, frånvaro av statiska nycklar och att Kubernetes-
ServiceAccounten bara kan utföra dokumenterade operationer.

### Datakälla

GitHub Actions-konfiguration, WIF-attributvillkor, IAM-policyer, Kubernetes
RBAC-manifest, `kubectl auth can-i` och dokumenterad PR-granskning.

### Datakvalitet

Konfigurations- och `auth can-i`-bevis visar vad som verifierades vid en viss
tidpunkt, men extern IAM-status och ändringar i den nya miljön måste verifieras
igen vid varje mätning. Ett saknat eller föråldrat bevis ska markeras som ej
verifierat, inte som godkänt.

### Målvärde eller önskad riktning

100 procent av produktionskopplingarna ska använda WIF och en granskad,
ändamålsenligt begränsad identitet. Inga långlivade molnnycklar i GitHub.

### Mätfrekvens

Kontrollera vid varje ändring av workflow, IAM eller RBAC och sammanfatta vid
varje sprintavslut. Mottagare är plattformsägare, utvecklingsansvarig och
säkerhetsansvarig.

### Mottagare

Plattformsägare, utvecklingsansvarig och säkerhetsansvarig. För ledningen
rapporteras främst om behörighetsrisken minskar eller om en avvikelse kräver
beslut.

### Tolkning

100 procent betyder att alla granskade kopplingar uppfyller de definierade
kraven, inte att all åtkomst i projektet är riskfri. Ett avvikande värde kräver
en konkret behörighetsgranskning och kan motivera att en deploy stoppas.

### Åtgärd vid avvikelse

Stoppa deployen vid en oväntad behörighet, återkalla eller begränsa identiteten,
uppdatera IAM/RBAC och kör om negativa behörighetstester innan godkännande.

## KPI 3 - Policyverifierade och spårbara container-images

### Syfte

KPI:n visar hur stor del av produktionsdeployerna som använder en image med
spårbar byggkälla, SBOM/attestering och godkänd signatur. Den mäter effekten av
supply-chain-kontrollerna, inte bara om en skanner har körts.

### Definition och beräkning

```text
Antal produktionsdeployförsök med godkänd image-policy och spårbar attestering
dividerat med totalt antal produktionsdeployförsök gånger 100
```

Avvisade testbilder ska registreras som kontrollbevis, men de ska inte räknas
som lyckade deployer. En deploy ska även kunna kopplas till commit, workflow,
image-digest och policybeslut.

### Datakälla

GitHub Actions-loggar, SBOM/attestering, container registry, Sigstore-
policy-controller, Kubernetes-events och deployhistorik.

### Datakvalitet

Policybevis, dry-run-resultat och deployhistorik visar kontrollerade händelser,
men täckningen beror på att alla deployer och policybeslut loggas. Fullständig
enforcement, rollback och långsiktig trend måste följas upp separat.

### Målvärde eller önskad riktning

100 procent av produktionsdeployerna ska vara policygodkända. Omatchade eller
osignerade images ska nekas innan de når produktion.

### Mätfrekvens

Mät per deploy och rapportera trenden varje sprint till plattformsägare och
säkerhetsansvarig.

### Mottagare

Plattformsägare och säkerhetsansvarig. På ledningsnivå översätts resultatet
till frågan om endast verifierade komponenter når produktion.

### Tolkning

Ett högt värde visar att de deployer som mättes uppfyllde kontrollen. Ett lågt
värde eller en saknad digest/provenance visar att leveranskedjan behöver
undersökas innan deployen tillåts fortsätta.

### Åtgärd vid avvikelse

Stoppa deployen, kontrollera signeringskedja och digest, undersök om policyn
eller workflowet har ändrats och skapa ett spårbart undantag endast efter
beslut av ansvarig.

## Motivering

De tre KPI:erna täcker olika delar av säkerhetsarbetet. Den första visar om
identifierade risker verkligen minskar. Den andra visar om vägen från GitHub
till moln och Kubernetes är begränsad till rätt identitet och rätt operationer.
Den tredje visar om den kod som når produktion har en verifierbar leveranskedja.
Tillsammans ger de därför en bild av både resultat, åtkomst och förebyggande
kontroller. De bygger på befintliga källor i projektet: PR:er, CI-loggar,
Terraform- och Kubernetes-konfiguration, säkerhetsrapporter och verifierade
kontroller. De ska inte användas som bevis för att Comerit är fritt från risk;
de är uppföljningsmått som gör förändringar och avvikelser synliga. Vid varje
mätning måste ansvarig också ange datakvalitet och eventuella kontroller som
inte kunde verifieras i den aktuella miljön.

## Samlad ledningsrapportering

KPI:erna bör rapporteras tillsammans med period, ansvarig, datakälla,
datakvalitet och avvikelse. En ledningsrapport behöver inte visa varje tekniskt
kommando. Den ska i stället svara på tre frågor: vilken risk följs upp, ligger
resultatet inom beslutad tolerans och vilket beslut krävs om resultatet avviker?

Ett exempel är att rapportera KPI 2 som: "Identitetskontroller: 100 procent
granskade, inga statiska nycklar hittade, nästa granskning vid ändring av
workflow eller IAM." Om datakällan inte räcker för ett säkert mått ska statusen
vara **ej verifierad** i stället för att en uppskattning presenteras som fakta.

Ledningen bör särskilt uppmärksamma trend över tid: sjunkande åtgärdstakt,
återkommande behörighetsavvikelser eller nekade images som ökar utan tydlig
orsak. KPI:erna kan stödja beslut om prioriterad riskreduktion, bemanning,
ägarskap och om en deploy ska stoppas. De visar däremot inte ensamma om en
attack har skett, om loggningen upptäcker allt eller om en återställning fungerar
i praktiken. Därför behöver rapporten kompletteras med säkerhetsfynd,
incidentloggar, negativa tester, rollbackövningar och ansvarigas bedömning.
