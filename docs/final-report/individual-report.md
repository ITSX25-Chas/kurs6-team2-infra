# Individuell slutrapport
**Namn:** Fajk Zhupa
**Kurs:** Avancerad IT-säkerhet, ITSX25

## 1. Vad gjorde vi?
Under projektet har vi arbetat med IT-säkerhet ur både ett Red Team- och Blue Team-perspektiv. Min insats har sträckt sig från att aktivt söka sårbarheter – såsom att extrahera känsliga hemligheter (flaggor) ur raderade Git-brancher och identifiera SQL-injections och container escapes i vår Flask-applikation – till att bygga försvar. På försvarssidan arbetade jag med att säkra vår K3s-infrastruktur genom nätverkssegmentering, Terraform-brandväggar och implementering av ett automatiserat SBOM- och Trivy-scanningsflöde.

## 2. Vad blev resultatet?
Resultatet är en tydlig kartläggning av hur snabbt små applikationssårbarheter kan eskalera till systemkritiska intrång. Vi lyckades dock inte bara identifiera riskerna (kopplade till MITRE ATT&CK-ramverket) utan även implementera konkreta, automatiserade lösningar. Ett avgörande resultat var vår DevSecOps-pipeline som nu kan varna för sårbarheter i mjukvarans leveranskedja i realtid.

## 3. Hur kan resultatet följas upp?
För att säkerställa att våra tekniska insatser ger varaktigt affärsvärde har jag tagit fram tre strategiska KPI:er (se `kpi.md`). Istället för att mäta tekniska detaljer fokuserar dessa på uppföljning för ledningen: täckningsgrad för scannad kod, nolltolerans mot hårdkodade hemligheter, och minimering av överprivilegierade containrar. Dessa KPI:er är mätbara via våra CI/CD-loggar och klustermanifest och ger ledningen direkt insyn i vår säkerhetsställning.

## 4. Vad lärde vi oss? (Inklusive AI-användning)
Tekniskt lärde vi oss att automatisering är det enda hållbara sättet att hantera sårbarheter över tid. En betydande del i detta arbete, och en viktig lärdom, var användandet av Generativ AI.

**Värdering av AI i säkerhetskontext:**
Jag har använt AI-verktyg för att effektivisera framtagandet av boilerplate-kod för Kubernetes CronJobs, bygga skelett för MITRE-mappningar och som ett interaktivt bollplank vid Terraform-felsökning. 
* **Lämplighet:** AI är oerhört kraftfullt för att accelerera utveckling och förklara komplexa tekniska loggar.
* **Risker och begränsningar:** AI är högst olämpligt att lita på blint när det gäller Infrastructure as Code (IaC) och behörighetsstyrning. Ett konkret exempel är riskerna för "hallucinationer"; om en AI genererar en felaktig nätverkspolicy eller missar en säkerhetskonfiguration i K3s, kan det öppna kritiska bakdörrar. 
* **Professionellt ansvar:** Det professionella ansvaret ligger alltid hos mig som säkerhetsingenjör. All AI-genererad kod måste verifieras, förstås och valideras mot ramverk (exempelvis OWASP och PTES) innan driftsättning.

## 5. Vad bör göras härnäst? (Mot LIA och yrkesrollen)
Projektet har varit en perfekt brygga till min kommande LIA och min framtida yrkesroll. Att ha fått operativ erfarenhet av Supply Chain Security, container-härdning och SBOM-hantering (via Trivy och Cosign) gör mig mycket väl rustad för att arbeta med compliance-krav såsom EU:s kommande Cyber Resilience Act (CRA).

Genom att ha drivit familjens taxiverksamhet har jag med mig en stark förståelse för att teknik måste tjäna affären. Detta projekt har stärkt min förmåga att översätta tekniska risker (exempelvis en öppen Docker-socket) till verksamhetsrisker som en ledningsgrupp kan fatta beslut utifrån. Det är exakt den förmågan – att kombinera tekniskt DevSecOps-djup med processförståelse – jag tar med mig in i samtalen med bolag som Logos Payment Solutions och nDigital framöver.

