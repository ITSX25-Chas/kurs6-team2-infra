# Sanerad Red Team-evidens

**Syfte:** stöd för den individuella slutrapporten.  
**Måltavla:** endast den tilldelade Acme-labbmiljön enligt godkänd RoE.  
**Viktig avgränsning:** resultaten nedan gäller inte Comerits GCP-miljö och ska
inte beskrivas som ett intrång i produktion.

## Verifierad kedja

| Steg | Observation | Evidens | Begränsning |
| --- | --- | --- | --- |
| Åtkomst | Måltjänsten svarade på TCP/8080 från rätt jumphost | HTTP 200, Werkzeug/Python-headers | Testet utfördes endast mot tilldelad intern labbadress |
| Login | Specialtecken i login gav SQL-syntaxfel | HTTP 500 jämfört med HTTP 401-baslinje | Inga data ändrades |
| Autentisering | Kontrollerad teststräng skapade administrativ session | HTTP 302 till dashboard och därefter HTTP 200 | Payload och cookies är redigerade |
| Kommandoinjektion | `host`-parametern kunde köra ett begränsat `id`-kommando | Ping-utdata följdes av `appuser` UID/GID | Ingen fil- eller nätverksändring |
| Container | Processen kördes i `/app` som lågprivilegierad användare | `id`, `pwd`, `uname`; `sudo` saknades | Ingen värdåtkomst bevisad |
| Rättighetseskalering | SUID-`find` gav effektiv UID root | Kontrollerad `id`-körning visade `euid=0` | Root gällde endast containern |
| Databas | Intern databas kunde nås med applikationskonfigurationen | Databasidentitet, schema och läsande aggregat | Lösenord, användarnamn och individdata redigerades |

## Relevans för Blue Team

Labbkedjan används som design- och testunderlag för följande skydd:

- parametriserade databasfrågor och generisk felhantering,
- säkra sessioner och serverstyrd auktorisation,
- validering utan shell-exekvering av användarindata,
- minimala container-images utan onödiga SUID-binära filer,
- secret-hantering utanför källkod och versionshistorik,
- loggning av avvikande HTTP-, process- och databasaktivitet.

## Bevisdisciplin

Flaggor, sessioncookies, lösenord, tokens och personuppgifter ingår inte i
denna bilaga. Resultaten ska läsas tillsammans med RoE:n och användas för att
förklara metod, risk och rekommenderade kontroller — inte som påstående om
Comerits produktionsmiljö.
