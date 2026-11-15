# Blue Team – individuell slutrapport

Detta är Jonny Nguyens individuella arbetsyta för Blue Team-examinationen.
Materialet sammanställer Team 2:s säkerhetsarbete och skiljer mellan
verifierade projektresultat, Red Team-lärdomar och egna bedömningar.

## Kursmål

Materialet är strukturerat för de uppdaterade kursmålen 4, 9, 10, 11 och 13:

- säkerhetsmätningar, KPI:er och rapportering till ledning,
- incidentrespons, post-mortem och förbättringsarbete,
- KPI-rapportering för icke-tekniska beslutsfattare,
- professionell användning och granskning av generativ AI,
- självständigt ledarskap, kvalitetssäkring och leverans av ett komplext
  säkerhetsprojekt.

MITRE ATT&CK- och threat intelligence-materialet finns kvar som stödjande
projekt- och Red Team-evidens, men är inte markerat som ett separat
examinerande kursmål för denna uppgift.

## Filstruktur

| Fil | Innehåll |
| --- | --- |
| [`individual-report.md`](individual-report.md) | Huvudrapport, individuellt bidrag, threat intelligence, KPI, post-mortem och AI-redogörelse. |
| [`kpi.md`](kpi.md) | KPI-definitioner, datakällor, mål, frekvens och åtgärder vid avvikelse. |
| [`lessons-learned.md`](lessons-learned.md) | Post-mortem, lessons learned och förbättringsförslag. |
| [`red-team-evidence.md`](red-team-evidence.md) | Sanerad evidens från den separata Acme-labben och koppling till Blue Team-lärdomar. |
| [`Material/`](Material/) | Utbildarens mallar och tidigare arbetsmaterial. Version 3 är referens för den uppdaterade strukturen; huvudfilerna ovan innehåller vårt anpassade material. |

## Rekommenderad granskningsordning

1. Läs `individual-report.md` för helheten och mitt individuella bidrag.
2. Kontrollera KPI-definitioner och beräkningar i `kpi.md`.
3. Läs `lessons-learned.md` för incidentrespons och förbättringsarbete.
4. Kontrollera att påståenden i `red-team-evidence.md` stöds av sanerad evidens.
5. Granska att kursmål, källor och AI-användning kan förklaras muntligt.

## Bevis- och sekretessprinciper

Endast verifierade uppgifter ska presenteras som fakta. Antaganden,
begränsningar och ej verifierade detektionspåståenden ska märkas tydligt.

Lösenord, tokens, sessioncookies, personuppgifter och andra skyddsvärda
värden får inte läggas i denna mapp. Evidens från Acme-labben får inte
beskrivas som ett intrång i Comerits produktionsmiljö.

## Inlämningsstruktur

De tre huvudfilerna är de dokument som hör till den individuella
slutinlämningen. README-filen och materialet i `Material/` fungerar som
navigations- och referensunderlag.
Innan inlämning bör gruppen kontrollera kursmål, källhänvisningar, PDF-format
och att varje studerandes eget bidrag framgår tydligt.
