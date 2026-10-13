# Team 2 - arbetssammanfattning 2026-10-01

## Omfattning

Dagens infrastrukturdel av Workshop 3.5-4 fokuserade på att testa att lägga upp en Lightweight Supply Chain Security Scanner (Fajk), samt att dokumentera tillkommande säkerhetsbrister i company-website efter att koden uppdaterades med ytterligare funktioner. Dessutom dokumenterades de olika tips och idéer som utbildaren förmedlade under Zoom-sessionen.

## Genomfört arbete med Supply Chain Security Scanner (Fajk)

1. En webhook skapades på Discord.
2. Den aktuella webhooken sparades som en Secret på produktionsservern (team2-primary).
3. RBAC-behörigheter (ServiceAccount, ClusterRole, ClusterRoleBinding) skapades på produktionsservern för att ge skannern rättigheter.
4. Uppsättning och applicering av ett cron-job med Kubernetes och Trivy genomfördes skarpt i K3s-klustret (produktionsmiljön).
5. Testkörning av cron-jobbet (genom att manuellt skapa ett engångsjobb) verifierades direkt på team2-primary där resultatet skickades via webhooken.
6. Koden är committad och mergad till main via PR #25.

## Git-status

- Commit `202acc2` dokumenterar arbetet med Supply Chain Security Scanner.
- Ändringen mergades till `main` via PR #25 i mergecommit `1274aff`.
- Commit `5c4469a`dokumenterar tillkommande säkerhetsbrister efter koduppdatering av company-website.
- Ändringen mergades till `main` via PR #27 i mergecommit `5c4469a`.


## Tips från utbildaren (Dennis)

### Tänkbara åtgärder för att ytterligare säkra vår miljö och våra servrar
(Anteckningar från dagens genomgång av Dennis. En del av detta kan säkert redan vara genomfört.)

### Kontrollera vår kod, både lokalt och i GitHub Actions (PR Check) med tänkbara verktyg:
Chekov
Trivy
Graphite
KubeLinter
(TFsec, daterat)

### Kontrollera behörigheter och brandvägg utifrån Least Privilege
Kontrollera brandväggsinställningar
Kontrollera Headscale Policy
Eventuellt tunnel in till GCP?

### Implementera OIDC OSLogin på båda servrarna (jumphost och primary)
Eliminera behov av Service Account Key för primary

### Ta hjälp av AI för att gå igenom och upptäcka eventuella svagheter
OBS! Var försiktig så att AI inte försöker hjälpa till med sådant som inte är efterfrågat.
