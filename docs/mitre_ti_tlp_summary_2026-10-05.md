# MITRE ATT&CK, Threat Intelligence och TLP - infra

**Datum:** 2026-10-05
**Klassificering:** TLP:CLEAR (sanerad för publicering i projektets publika repo)
**Omfattning:** Team 2:s infra-repo, dokumentation, mergehistorik och godkända kurslabb från vecka 4-7.

## Syfte och avgränsning

Detta är en defensiv sammanställning av verifierade risker, åtgärdade brister och
öppna förbättringar. En MITRE ATT&CK-koppling visar vilket angriparbeteende ett
fynd kan möjliggöra eller motverka. Den är inte bevis för att Team 2 har utsatts
för ett intrång.

Kurslabbets flaggor är separerade från Team 2:s driftmiljö. De är värdefulla för
lärande och hotmodellering, men är inte bevis för en aktiv sårbarhet hos Team 2.

## Så läser du dokumentet

Tänk på varje rad i tabellen som en kort analyskedja:

1. **Fynd eller kontroll** berättar vad teamet har hittat eller infört.
2. **Evidens** visar varför vi tror att uppgiften stämmer, till exempel kod,
   en pull request eller en lyckad driftkontroll.
3. **MITRE ATT&CK-koppling** beskriver angriparens möjliga beteende. Den säger
   inte att just det beteendet har hänt hos Team 2.
4. **Status** visar om risken är åtgärdad, delvis åtgärdad eller fortfarande
   behöver arbete.
5. **Tilltro** visar hur starkt underlaget är. Hög tilltro bygger på flera
   oberoende bevis, till exempel kod, CI och en efterkontroll.
6. **TLP** visar hur långt informationen får spridas. Själva dokumentet är
   sanerat för publicering; känsligt underlag ska inte läggas i Git.

## Lägesbild just nu

- **Verifierat klart:** WIF i stället för en långlivad GCP-nyckel, smalare
  brandväggsregler och en mer begränsad CI-identitet.
- **Delvis klart:** Storage- och åtkomstskydd har förbättrats, men behöver
  fortsatt IAM-granskning och tydliga minsta-behörighetsbeslut.
- **Nästa fokus:** Terraform state-bucket, OS Login samt reproducerbar
  Headscale-policy och återställning.

### Exempel: så tolkas en rad

Den första raden handlar om en gammal, långlivad GCP-nyckel. Risken var att den
kunde användas som en giltig molnidentitet om den hamnade fel. Teamets svar var
att ersätta nyckeln med WIF. Evidensen är både den mergade konfigurationen och
en lyckad WIF-deploy efter att nyckeln tagits bort. Därför är statusen
**åtgärdad och verifierad**, men loggning behövs fortfarande för att upptäcka
ovanliga anrop i framtiden.

## Sammanfattande tabell

| Fynd eller kontroll | Evidens | MITRE ATT&CK-koppling | Status och defensiv uppföljning | Tilltro | TLP |
| --- | --- | --- | --- | --- | --- |
| Långlivad CI/CD-nyckel för GCP service account | PB-03, mergehistorik och lyckad WIF-deploy från `main` efter borttagning av nyckeln | [T1078.004 Cloud Accounts](https://attack.mitre.org/techniques/T1078/004/) | **Åtgärdad och verifierad.** WIF ersätter nyckeln. Följ Cloud Audit Logs för oväntade service-account-anrop och skapande av nycklar. | Hög | CLEAR; nycklar och tokens är RED |
| För vida CI/CD-behörigheter | PB-04, bootstrap-IAM och efterkontroll visar att tidigare bred roll togs bort | Ingen entydig ATT&CK-teknik; riskförstärkare för flera molntekniker | **Åtgärdad med kvarvarande risk.** CI har avgränsade Compute-roller och explicit åtkomst till state-bucketen. `compute.securityAdmin` är bredare än idealet och ska omprövas. | Hög | CLEAR |
| Brandväggsregler som tidigare accepterade internettrafik | PB-05 och aktuell Terraform visar avgränsade regler för IAP, interntrafik, Tailnet och reverse proxy | [T1190 Exploit Public-Facing Application](https://attack.mitre.org/techniques/T1190/) | **Åtgärdad och verifierad.** Granska regler vid nya portar, taggar eller routning och bekräfta avsedda källnät. | Hög | CLEAR; nätinformation är AMBER+STRICT |
| Terraform state och backupfiler kan innehålla känsliga värden | PB-02 är öppen; kurslabb visade att statefiler och backupfiler kan innehålla kodade värden | [T1552.001 Credentials In Files](https://attack.mitre.org/techniques/T1552/001/) och [T1140 Decode Files or Information](https://attack.mitre.org/techniques/T1140/) | **Öppet förbättringsarbete.** Behåll en skyddad remote backend, strikt IAM och Git-ignore; rotera hemligheter som kan ha förekommit i state eller historik. | Hög för riskklassen, medel för aktuell exponering | CLEAR; faktisk state är RED |
| Storage-åtkomst och tidigare publik bindning | PB-02: `allAuthenticatedUsers` togs bort; uniform bucket-level access är dokumenterad | [T1530 Data from Cloud Storage](https://attack.mitre.org/techniques/T1530/) | **Delvis åtgärdad.** Granska indirekt åtkomst, explicit public access prevention och IAM. Logga läsning av känsliga objekt och granska versionshantering. | Hög | CLEAR; objektlistor och IAM-exporter är AMBER+STRICT |
| OS Login, IAP och Headscale minskar extern åtkomstyta | PR #39 och aktuell Terraform med OS Login och blockerade projekt-SSH-nycklar | [T1021.004 SSH](https://attack.mitre.org/techniques/T1021/004/) och [T1078 Valid Accounts](https://attack.mitre.org/techniques/T1078/) | **Delvis åtgärdad.** PB-09 är öppen tills minsta behövliga OS Login-roll och komplett användaröversikt är granskad. | Hög | CLEAR; enhets- och användarlistor är AMBER+STRICT |
| Gemensam Headscale-admin-grupp i kurslabbet | PB-14 och arbetssammanfattning 2026-09-17 | [T1078 Valid Accounts](https://attack.mitre.org/techniques/T1078/) | **Öppet förbättringsarbete.** Beslutet underlättar kursarbete men följer inte least privilege. Slutför nekad-trafik-test, rollback och senare rolluppdelning. | Hög | CLEAR |
| LookingGlass-kurslabb: command injection, metadata och objektversioner | Individuell flaggsammanfattning 2026-09-24, endast godkänd kursmiljö | [T1059.004 Unix Shell](https://attack.mitre.org/techniques/T1059/004/), [T1552.005 Cloud Instance Metadata API](https://attack.mitre.org/techniques/T1552/005/) och [T1530 Data from Cloud Storage](https://attack.mitre.org/techniques/T1530/) | **Labbfynd, inte Team 2-driftfynd.** Lärande: undvik skalexekvering av användarindata, begränsa metadata-åtkomst och tillämpa minsta IAM. | Hög för labbet | CLEAR; flaggor och tokens är RED |
| Headscale-installation och policyhantering är inte fullt reproducerbar i Git | PB-12 och PB-14 är öppna | Ingen direkt ATT&CK-teknik; drift- och granskningsgap | **Öppet förbättringsarbete.** Versionshantera installation, policy och återställning utan hemligheter; verifiera konfiguration efter varje ändring. | Hög | CLEAR |

## Uppdatering efter PR #78

PR #78 lade till teamets arbetssammanfattning från 2026-10-01. Den bekräftar
att Discord-webhook, Secret, RBAC, Trivy CronJob och en testad engångskörning
finns i K3s. Den förändrar inte infra-repots bedömning av WIF, IAM, brandvägg,
state eller Headscale. Uppgiften används som kompletterande evidens för
company-website-repots supply-chain-kontroll.

## Vad betyder statusen i praktiken?

| Status | Praktisk betydelse |
| --- | --- |
| **Åtgärdad och verifierad** | Ändringen finns i versionerad konfiguration och har kontrollerats i CI eller drift. Den ska ändå följas upp när miljön förändras. |
| **Delvis åtgärdad** | En viktig kontroll finns, men en del av riskbilden eller verifieringen återstår. Backloggen anger nästa steg. |
| **Öppet förbättringsarbete** | Teamet har identifierat en konkret uppgift, men den är inte färdig eller tillräckligt verifierad ännu. |
| **Labbfynd** | Fyndet kommer från den godkända kursmiljön. Det används för lärande och hotmodellering, inte som bevis om Team 2:s drift. |

## Vad menar vi med Threat Intelligence?

I den här kursen betyder Threat Intelligence inte att teamet försöker peka ut
en verklig angripare. Det betyder att vi använder tillförlitliga källor för att
bedöma:

- vilket angriparbeteende ett fynd kan möjliggöra,
- vilken kontroll som minskar risken,
- vilken logg eller kontroll som kan visa om något avviker, och
- hur säker vår bedömning är.

Det gör att ett tekniskt fynd blir ett underlag för beslut, prioritering och
uppföljning - inte bara en rad i en logg eller en GitHub Issue.

## Threat intelligence-bedömning

| Källtyp | Bidrag | Bedömning |
| --- | --- | --- |
| Terraform, bootstrap och Git-historik | Visar vilken kontroll som är versionshanterad och mergad | Primärkälla med hög tilltro |
| GitHub Actions, Terraform-planer och efterkontroller | Visar att åtgärder verifierats i CI eller drift | Hög tilltro när körning och efterkontroll stämmer |
| Backlog och arbetssammanfattningar | Kopplar risk till ansvar, beslut och återstående arbete | Medel till hög tilltro; kontrollera mot kod och CI |
| Godkända kurslabb | Ger realistiska exempel på angreppsbeteenden och detektionsbehov | Hög tilltro för labbet, inte för attribution eller Team 2:s drift |
| MITRE ATT&CK | Ger gemensamt språk för angriparbeteenden och försvarsfrågor | Analysramverk, inte incidentbevis |

Ingen indikator i underlaget gör det rimligt att attribuera fynden till en verklig
hotaktör. Analysen är därför beteendebaserad: vilken angreppsväg kan finnas,
vilken kontroll bryter kedjan och vilken telemetri skulle visa ett avvikande försök?

## TLP-rutin

TLP är en delningsmärkning, inte ett skydd för hemligheter.

Eftersom infra-repot är publikt är den här sammanställningen märkt
**TLP:CLEAR**. Det betyder inte att allt underlag är offentligt: råa loggar,
statefiler och åtkomstdetaljer måste hållas utanför repot enligt nivåerna nedan.

| Nivå | Användning i Team 2 |
| --- | --- |
| **TLP:CLEAR** | Sanerade lärande- och statusdokument som detta. Kan delas med utbildaren och ligga i ett publikt repo. |
| **TLP:AMBER** | Detaljerade granskningsunderlag, exempelvis loggutdrag eller konfiguration som underlättar missbruk. Dela med Team 2 och utbildaren. |
| **TLP:AMBER+STRICT** | Källmaterial som måste stanna hos den ursprungliga mottagargruppen, exempelvis detaljerad åtkomstinventering. |
| **TLP:RED** | Nycklar, tokens, flaggvärden, signerade URL:er och faktisk Terraform state. Skriv aldrig detta i Git eller Discord. |

## Rekommenderad fortsättning

1. Avsluta PB-02 med en IAM-granskning av state-bucketen och explicit `public_access_prevention`.
2. Avsluta PB-09 med en dokumenterad bedömning av minsta nödvändiga behörighet för OS Login.
3. Avsluta PB-12 och PB-14 med en reproducerbar Headscale-installation, policytest och återställningsrutin.
4. Behåll MITRE-kopplingen i nya issues: observation, berörd teknik, telemetri, ansvarig kontroll och osäkerhet.

## Referenser

- [MITRE ATT&CK Enterprise](https://attack.mitre.org/)
- [FIRST: Traffic Light Protocol 2.0](https://www.first.org/tlp/)
- [Produktbacklog](product_backlog.md)
- [Risker med statiska GCP-nycklar](GSA_key_risks.md)
- [Arbetssammanfattning 2026-10-01](team_work_summary_2026-10-01.md)
- [Arbetssammanfattning 2026-09-24](team_work_summary_2026-09-24.md)
