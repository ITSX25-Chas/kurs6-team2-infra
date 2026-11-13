# KPI:er och säkerhetsmätningar

## KPI 1

### Namn
Andel kritiska fynd som åtgärdas inom 14 dagar

### Syfte och mottagare
Den här KPI:n visar hur snabbt organisationen tar hand om de säkerhetsbrister som upptäcks vid ett pentest. Det räcker inte att bara hitta problemen, utan det är också viktigt att de faktiskt blir åtgärdade. Om andelen är hög visar det att organisationen arbetar aktivt med sin säkerhet.

Mottagare: VD och säkerhetsansvarig.

### Definition och beräkning
`Antal kritiska fynd som åtgärdats inom 14 dagar / totalt antal identifierade kritiska fynd × 100`

I vårt pentest hittades fyra kritiska brister: SQL-injektion, Broken Access Control, RCE och SSRF som ledde till läckage av personuppgifter.

### Datakälla och datakvalitet
Informationen hämtas från pentestrapporten och GitHub Issues/PR-historiken. En begränsning är att mätningen bara omfattar de delar som testades under pentestet. Det kan alltså finnas andra brister som inte upptäcktes utanför scope.

### Målvärde eller önskad riktning
Målet är att alla kritiska fynd ska åtgärdas inom 14 dagar, alltså 100 %. Om resultatet hamnar under 80 % behöver det följas upp.

### Mätfrekvens
Efter varje pentest och löpande tills samtliga kritiska fynd har åtgärdats.

### Tolkning och åtgärd vid avvikelse
Ett högt värde visar att organisationen är bra på att ta hand om upptäckta säkerhetsproblem. Om värdet hamnar under 80 % innebär det att för många kritiska brister fortfarande är öppna. Då behöver det lyftas till ledningen så att åtgärder kan prioriteras.

---

## KPI 2

### Namn
Antal kategorier av känslig information som exponeras vid pentest

### Syfte och mottagare
Den här KPI:n visar vilken information en obehörig person faktiskt skulle kunna komma åt. Jag tycker att det är ett bra sätt att visa konsekvenserna av säkerhetsbristerna, eftersom det kan vara lättare för ledningen att förstå att personuppgifter och löneinformation har läckt än att förstå tekniska begrepp som SSRF.

Mottagare: VD, styrelse och dataskyddsombud.

### Definition och beräkning
Mätningen baseras på antalet olika kategorier av känslig information som en obehörig angripare kunde komma åt under det senaste pentestet.

I vårt test fick vi åtkomst till personnummer (3 personer), löneuppgifter (3 personer), databaslösenord i klartext och information om den interna systemarkitekturen. Det motsvarar totalt fyra kategorier.

### Datakälla och datakvalitet
Underlaget kommer från pentestrapporten och loggar från testet. En begränsning är att resultatet bara visar vad vi lyckades hitta under den tid som var avsatt för testet. Det behöver därför inte betyda att all exponerad information har upptäckts.

### Målvärde eller önskad riktning
Målet är att inga kategorier av känslig information ska kunna nås av obehöriga. Det innebär ett målvärde på 0. Resultatet bör också minska mellan varje pentest.

### Mätfrekvens
Efter varje genomfört pentest.

### Tolkning och åtgärd vid avvikelse
Om känslig information kan nås av obehöriga innebär det en risk för både organisationen och de personer som berörs. Om exempelvis personnummer eller löneuppgifter exponeras behöver det utredas direkt. Organisationen behöver även bedöma om det rör sig om en personuppgiftsincident som ska anmälas till IMY inom 72 timmar enligt GDPR.

---

## KPI 3

### Namn
Andel infrastrukturresurser med begränsade behörigheter

### Syfte och mottagare
Den här KPI:n handlar om hur väl vi begränsar behörigheter i infrastrukturen. Om en angripare lyckas ta sig in i ett system ska personen inte automatiskt få tillgång till alla andra delar. Genom att bara ge konton och tjänster de behörigheter de faktiskt behöver kan vi minska risken för större skador.

Mottagare: IT-chef och säkerhetsansvarig.

### Definition och beräkning
`Antal IAM-roller och brandväggsregler med begränsad åtkomst / totalt antal granskade IAM-roller och brandväggsregler × 100`

I vårt projekt bytte vi bland annat ut den breda rollen `roles/editor` mot mer specifika behörigheter. Vi begränsade även brandväggsregler från `0.0.0.0/0` till specifika subnät.

### Datakälla och datakvalitet
Informationen kan hämtas med hjälp av `gcloud projects get-iam-policy` och `gcloud compute firewall-rules list`. Resultatet behöver granskas manuellt eller med hjälp av script, eftersom alla för breda behörigheter inte automatiskt upptäcks.

### Målvärde eller önskad riktning
Målet är 100 %, vilket innebär att alla behörigheter och brandväggsregler ska vara begränsade till vad som faktiskt behövs. Undantag ska ha en tydlig motivering. Trenden ska vara stigande.

### Mätfrekvens
Vid större ändringar i infrastrukturen och minst en gång per sprint.

### Tolkning och åtgärd vid avvikelse
Om det finns för breda behörigheter ökar risken för att en angripare kan göra mer skada om ett konto blir komprometterat. Ett exempel är `roles/editor`, som ger betydligt större åtkomst än vad som ofta behövs. Om sådana behörigheter upptäcks bör de granskas och begränsas senast under nästa sprint.

---

## Samlad ledningsrapportering

Jag valde dessa tre KPI:er eftersom de visar olika delar av organisationens säkerhetsarbete. Den första handlar om hur snabbt vi åtgärdar säkerhetsbrister som upptäcks. Den andra visar vilken information som riskerar att hamna i fel händer. Den tredje visar hur bra vi är på att begränsa behörigheter i infrastrukturen.

Det jag tycker är viktigast att följa är om antalet exponerade informationskategorier minskar mellan pentesterna. Om det inte sker någon förbättring kan det vara ett tecken på att vi inte kommer åt grundproblemen. KPI:erna kan också hjälpa ledningen att avgöra var mer tid och resurser behöver läggas, till exempel på att åtgärda kritiska brister eller förbättra behörighetshanteringen.

Det finns samtidigt begränsningar. KPI:erna visar bara det vi har testat och den information vi har tillgång till. De säger exempelvis inte så mycket om insiderhot, personalens säkerhetsmedvetenhet eller attacker som inte upptäckts. Därför behöver de kompletteras med exempelvis logganalys och uppföljning av säkerhetsutbildningar.
