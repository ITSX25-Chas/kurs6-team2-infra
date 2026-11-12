# KPI:er och säkerhetsmätningar

## KPI 1: Andel automatiserat scannade kod- och container-releaser (Coverage)
* **Definition:** Procentandel av alla mjukvarudriftsättningar som genomgår en automatiserad säkerhetsscanning (exempelvis SBOM-generering och sårbarhetsscanning) innan de når produktionsmiljön.
* **Datakälla:** CI/CD-loggar (t.ex. GitHub Actions) och larm från vårt automatiserade Trivy-verktyg.
* **Mål eller önskad riktning:** 100 % (Krav för kommande releaser).
* **Affärs- och säkerhetsmässigt syfte:** Garanterar att vi har kontroll över vår mjukvaruförsörjningskedja (Supply Chain). Genom att säkerställa att ingen kod går till produktion utan att scannas, minskar vi risken för intrång avsevärt och förbereder organisationen proaktivt för lagkrav som EU:s Cyber Resilience Act (CRA).

## KPI 2: Antal exponerade hemligheter i källkod och infrastruktur
* **Definition:** Antal upptäckta hårdkodade lösenord, API-nycklar eller okrypterade certifikat i vår versionshantering (Git-historik) eller infrastrukturfiler (t.ex. Terraform-state) per månad.
* **Datakälla:** Automatiserade scanningsverktyg samt manuella kodgranskningar.
* **Mål eller önskad riktning:** 0 incidenter (Nolltolerans).
* **Affärs- och säkerhetsmässigt syfte:** Historiska misstag i versionshantering kan leda till total systemkompromettering (vilket bevisades under våra tester där vi kunde extrahera gamla hemligheter). Detta KPI hjälper ledningen att följa upp hur väl utvecklarteamen efterlever säkra kodningsriktlinjer och förhindrar dataläckage.

## KPI 3: Andel överprivilegierade systemtjänster i produktion
* **Definition:** Procentandel av våra applikationer och mikrotjänster som körs med förhöjda rättigheter (t.ex. root-access eller full tillgång till Docker-socket) i vår klustermiljö.
* **Datakälla:** Infrastrukturkonfigurationer (Kubernetes manifests).
* **Mål eller önskad riktning:** < 5 % (Endast där det är absolut verksamhetskritiskt och väl dokumenterat).
* **Affärs- och säkerhetsmässigt syfte:** Minimerar skadan vid ett eventuellt dataintrång (Skadebegränsning/Least Privilege). Om en angripare tar över en applikation förhindrar ett lågt värde på detta KPI att de kan eskalera sina rättigheter och ta över den underliggande serverinfrastrukturen.
