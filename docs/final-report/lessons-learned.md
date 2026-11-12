# Lessons learned och professionell sammanfattning

## Lesson Learned 1: Historiken glömmer aldrig (Git & Hemligheter)
* **Händelse/Orsak:** Under projektets granskning framkom det att angripare kunde extrahera kritiska hemligheter direkt från gamla Git-brancher och Terraform state-filer, trots att dessa "raderats" i senare uppdateringar.
* **Konsekvens:** Risk för fullständig kompromettering av infrastrukturen genom att obehöriga får tillgång till systemets nycklar.
* **Förbättring och uppföljning:** Införande av strikt hantering av hemligheter via krypterade miljövariabler (GitHub Actions secrets) i CI/CD-kedjan, kombinerat med utbildning för teamet. Följs upp via "KPI 2: Antal exponerade hemligheter".

## Lesson Learned 2: Säkerhet i leveranskedjan kräver automation
* **Händelse/Orsak:** Manuella kontroller av mjukvaruberoenden och infrastruktur var ineffektiva och riskerade att släppa igenom kända sårbarheter till produktionsmiljön (K3s).
* **Konsekvens:** Okända sårbarheter i tredjepartsbibliotek exponerade systemet för risk.
* **Förbättring och uppföljning:** Vi utvecklade och implementerade en CronJob-baserad Trivy-scanner med Discord-larm för att omedelbart upptäcka sårbarheter. Följs upp via "KPI 1: Scannade releaser". Detta säkerställer även en framtidssäker hantering av SBOM (Software Bill of Materials).

## Lesson Learned 3: Falsk trygghet i applikationscontainrar
* **Händelse/Orsak:** Vår analys (inklusive utnyttjande av SQL-injections i Flask-applikationen) visade att applikationer som körs med för höga rättigheter (t.ex. tillgång till Docker-socket) kan användas som språngbrädor.
* **Konsekvens:** En isolerad applikationsrisk kunde eskaleras till ett fullskaligt infrastrukturintrång (Container Escape).
* **Förbättring och uppföljning:** Implementering av nätverkssegmentering (via Headscale/Tailscale) och principen om minsta möjliga behörighet (Least Privilege) för alla containrar. Följs upp via "KPI 3: Överprivilegierade tjänster".

---

## Professionell sammanfattning till ledningsgruppen

**Resultat, risker och rekommendationer**
Under projektperioden har vi genomfört en omfattande teknisk och strategisk analys av vår IT-miljö. Arbetet har identifierat kritiska verksamhetsrisker, i synnerhet relaterat till överprivilegierade system och exponering av nycklar i källkodens historik. Dessa brister har historiskt möjliggjort för obehöriga att eskalera sina rättigheter i nätverket.

För att möta dessa risker har vi gått från reaktiva åtgärder till proaktiv automation. Vi har framgångsrikt implementerat automatiserad sårbarhetsscanning och etablerat tydliga riktlinjer för vår infrastruktur (DevSecOps). 

**Våra främsta rekommendationer för nästa kvartal är:**
1. **Prioritera säkerhetsautomation:** Säkerställ att ledningen allokerar resurser för att integrera säkerhet i leveranskedjan till 100 % för att framtidssäkra oss mot lagkrav som Cyber Resilience Act (CRA).
2. **Kräv behörighetsgranskning:** Inför krav på att alla tjänster ska byggas enligt "Least Privilege" för att isolera eventuella intrång på applikationsnivå.
3. **Mät det som räknas:** Använd de presenterade KPI:erna löpande i ledningsgruppens uppföljning för att basera IT-beslut på evidens och faktisk risk snarare än antaganden.
