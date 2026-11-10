# Jonny Nguyen – AI-redogörelse för Blue Team-arbetet

Jag använde Codex som stöd under Blue Team-arbetet för att gå igenom
dokumentation och Git-historik, strukturera förslag, förklara tekniska samband
och formulera arbetssammanfattningar. AI användes även som stöd vid
språkgranskning och för att koppla tekniska observationer till risk,
MITRE ATT&CK, KPI:er och rekommenderade kontroller.

Jag ansvarar själv för innehållet. AI-förslag behandlades inte som evidens utan
jämfördes med faktisk kod, Terraform- och Kubernetes-konfiguration,
PR-historik, Actions-resultat, testutdata, kursmaterial och relevanta källor.
En grön pipeline tolkades därför endast som att de körda kontrollerna lyckades;
den användes inte som bevis för att hela systemet var säkert.

AI var lämpligt för strukturering, pedagogiska förklaringar, språkgranskning
och förslag på defensiva kontrollfrågor. AI var inte lämpligt som ensam
beslutsfattare vid IAM- eller RBAC-ändringar, produktionstester,
riskbedömningar eller ATT&CK-mappning. Sådana beslut krävde mänsklig
granskning och verifiering i rätt miljö. Jag tog också hänsyn till risken för
hallucinationer, felaktiga säkerhetsråd, övertolkning av begränsad evidens och
informationsläckage. Hemligheter, privata nycklar och känsliga loggar ska inte
lämnas till AI-tjänster eller publiceras i repositoryt.

Min professionella slutsats är att AI kan öka förståelse och effektivitet, men
inte flytta ansvaret för scope, testval, evidens, prioritering eller slutligt
säkerhetsbeslut från den ansvariga säkerhetspersonen.
