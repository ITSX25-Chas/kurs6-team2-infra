
# Post-mortem, lessons learned och professionell sammanfattning

## Händelse och avgränsning

Det här post-mortemet handlar om det simulerade pentestet mot Acme Corps internportal (http://10.0.0.5:8080), som genomfördes den 20 oktober 2026 under kursens Red Team-fas. Testmiljön bestod av en medvetet sårbar webbapplikation byggd i Python/Flask med en tillhörande databas och intern tjänst.

Testet genomfördes utan att jag hade någon tidigare information om systemet. Jag började med att undersöka miljön och leta efter möjliga sårbarheter. Under arbetet hittade jag bland annat SQL-injektion i inloggningen, bekräftade command injection via diagnostikformuläret och lyckades komma åt känslig information genom den interna tjänsten.

Det gick att ta sig från helt obehörig åtkomst till root-behörighet och komma åt personuppgifter på mindre än 20 minuter. Testet visade hur flera olika säkerhetsbrister kunde användas tillsammans för att ta kontroll över systemet.

---

## Lesson learned 1

### Observation
En SQL-injektion i inloggningsformuläret gjorde att jag kunde komma åt admin-panelen utan att behöva logga in på vanligt sätt.

### Orsak
Problemet berodde på att applikationen byggde SQL-frågor direkt från användarens inmatning utan att använda parametriserade frågor. Dessutom kontrollerades åtkomsten till admin-panelen via en cookie på klientsidan istället för att behörigheten verifierades på servern.

### Konsekvens
De två bristerna gjorde det möjligt att få full åtkomst till admin-panelen utan att känna till något lösenord. Det visar hur SQL-injektion och bristande åtkomstkontroll kan förstärka varandra och göra det betydligt enklare för en angripare att ta sig in.

### Förbättring
SQL-frågor bör alltid använda parametriserade frågor för att förhindra att användarinmatning kan påverka frågorna direkt. Behörigheter ska också kontrolleras på serversidan och inte enbart baseras på information som finns i en cookie hos användaren.

### Uppföljning
Efter att bristerna har åtgärdats bör ett nytt pentest genomföras för att kontrollera att samma sårbarheter inte längre fungerar. Det är även bra att lägga till automatiserade säkerhetstester i CI/CD-pipelinen för att upptäcka liknande problem tidigare.

---

## Lesson learned 2

### Observation
Webbapplikationen kördes med root-behörighet. Det innebar att command injection i diagnostikformuläret kunde ge åtkomst till hela servern.

### Orsak
Driftsmiljön hade inte härdats tillräckligt. Applikationen kördes direkt som root istället för att använda en separat systemanvändare med begränsade rättigheter.

### Konsekvens
När jag hade bekräftat command injection kunde jag komma åt känsliga konfigurationsfiler, hitta databaslösenord i klartext och även nå en intern tjänst som innehöll personuppgifter. Problemet blev betydligt allvarligare eftersom applikationen hade så höga behörigheter från början.

### Förbättring
Webbapplikationer bör inte köras som root. Istället bör man skapa en separat användare med endast de behörigheter som applikationen behöver. Det är också viktigt att begränsa filsystemsåtkomsten så att applikationen inte kan läsa eller ändra filer som den inte behöver.

### Uppföljning
Efter åtgärden bör man kontrollera att applikationen inte längre körs som root. Detta kan exempelvis verifieras genom att kontrollera resultatet från `id` via diagnostikfunktionen. Det bör även göras regelbundna kontroller av vilka processer i produktionsmiljön som körs med root-behörighet.

---

## Lesson learned 3

### Observation
En intern tjänst som innehöll känsliga personuppgifter, bland annat personnummer och löneuppgifter, gick att nå utan autentisering från servernätverket.

### Orsak
Tjänsten var inte tänkt att vara tillgänglig utifrån, men saknade ändå egen autentisering. Istället förlitade man sig på att nätverksisoleringen skulle skydda informationen. När jag väl hade fått åtkomst till servern genom RCE fanns det inget ytterligare skydd som stoppade mig från att komma åt tjänsten.

### Konsekvens
Jag kunde komma åt och exfiltrera personnummer och löneuppgifter för tre personer i företagsledningen (VD, CFO och säkerhetschef). Detta innebär en potentiell personuppgiftsincident som behöver utredas och där organisationen måste bedöma om en anmälan till IMY krävs inom 72 timmar.

### Förbättring
Även interna tjänster bör ha krav på autentisering. Det räcker inte att bara förlita sig på att tjänsten ligger bakom ett internt nätverk. Nätverksisolering är ett extra skydd, men bör inte vara det enda skyddet för känslig information.

### Uppföljning
Efter att ändringarna har genomförts bör man kontrollera att den interna tjänsten faktiskt kräver autentisering. Det är också viktigt att regelbundet gå igenom vilka interna tjänster som finns och kontrollera att känslig information inte kan nås utan rätt behörighet.

---

## Professionell sammanfattning

Under kursens Red Team-fas genomförde jag ett simulerat pentest mot Acme Corps interna medarbetarportal. Testet visade att det fanns flera allvarliga säkerhetsbrister som tillsammans gjorde det möjligt att gå från helt obehörig åtkomst till full kontroll över servern på mindre än 20 minuter.

Fyra kritiska brister identifierades: SQL-injektion som gjorde det möjligt att kringgå inloggningen, bristande åtkomstkontroll till admin-panelen, command injection som gav root-behörighet och en intern tjänst utan autentisering som exponerade känsliga personuppgifter. Det som gjorde situationen extra allvarlig var att bristerna kunde användas tillsammans i en attackkedja där varje steg gav möjlighet att komma vidare till nästa.

Den största risken var att personnummer och löneuppgifter för tre personer i företagsledningen kunde kommas åt. Det innebär en potentiell personuppgiftsincident som behöver utredas och bedömas utifrån GDPR:s krav.

En viktig lärdom från testet är att även enskilda säkerhetsbrister kan få mycket större konsekvenser när de kombineras med andra. Därför räcker det inte att bara åtgärda en del av problemen.

Organisationen bör prioritera att åtgärda SQL-injektionen och åtkomstkontrollen, se till att applikationen inte längre körs med root-behörighet och införa autentisering på den interna tjänsten. Ledningen behöver även se till att personuppgiftsincidenten utreds och att frågan om eventuell anmälan till IMY hanteras.
