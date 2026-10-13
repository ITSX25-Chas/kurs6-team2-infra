# Amin Mahamoud - individuell arbetsyta

Den här mappen är Amins personliga dokumentationsyta för Kurs 6 och gruppens
Blue Team-arbete med GCP, Terraform, Headscale, Tailscale och K3s.

## Arbetsbranch

`member/aminmahamoud-arch`

## Börja här utan merge eller konflikter

Den senaste gemensamma anslutningsguiden kan alltid läsas direkt på GitHub:

```text
https://github.com/itsx25-team2/kurs6-team2-infra/blob/main/docs/gemensam_anslutningsguide.md
```

Om repot redan finns lokalt kan senaste versionen läsas utan checkout, merge
eller ändring av arbetsfiler:

```bash
git fetch origin
git show origin/main:docs/gemensam_anslutningsguide.md | less
```

Synka inte medlemsbranchen innan `git status --short --branch` har
kontrollerats. Om en fast-forward misslyckas ska teamet granska branchen innan
någon merge, rebase eller konfliktlösning görs.


## Viktiga filer

| Fil | Syfte |
| --- | --- |
| [Uppföljning till 2026-09-21](sammanfattning_missade_dagar_2026-09-14_2026-09-15.md) | Gruppens genomförda arbete och Amins checklista för OS Login, Headscale, routing, ACL, K3s och organisationens repositories. |

## Användning

- Egna anteckningar och arbetssammanfattningar
- Beslut, observationer och frågor från säkerhetsgranskningar
- Underlag och källor kopplade till gruppens issues
- Resultat från tester som inte innehåller känsliga värden

## Arbetslogg

| Datum | Vad gjordes? | Nästa steg |
| --- | --- | --- |
| 2026-09-08 | Personlig dokumentationsyta skapad. | Lägg till egna anteckningar från Blue Team-arbetet. |
| 2026-09-15 | En tvådagarssammanfattning och återanslutningschecklista lades till efter frånvaro. | Läs sammanfattningen, verifiera OS Login och registrera `amin-workstation` i teamets Tailnet. |
| 2026-09-17 | Upphämtningsdokumentet kompletterades med steg 7, Split DNS och ACL-status. | Registrera `amin-workstation`, aktivera privata rutter och be teamet lägga till `amin@` i policyn. |
| 2026-09-21 | Uppföljningen kompletterades med K3s, IAP, GitHub-organisationen och infra-repots transfer. | Godkänn organisationsinbjudan, uppdatera Git-remote och följ checklistan i uppföljningsfilen. |
| 2026-09-24 | Konfliktfri åtkomst till senaste gemensamma guide dokumenterades. | Läs guiden via GitHub eller `git show` innan medlemsbranchen synkas. |

## Viktigt

Privata SSH-nycklar, service account keys, credentials, Terraform state och
planfiler får aldrig sparas eller commitas här.

## Gemensamma dokument

- [Projektets README](../../README.md)
- [Product Backlog](../../docs/product_backlog.md)
- [Gemensam anslutningsguide](../../docs/gemensam_anslutningsguide.md)
- [Blue Team-agenda 2026-09-08](../../docs/blue_team_agenda_2026-09-08.md)
- [Setup Summary 2026-09-07](../../docs/setup_summary_2026-09-07.md)
