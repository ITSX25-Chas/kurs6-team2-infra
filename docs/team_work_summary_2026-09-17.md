# Gemensam arbetssammanfattning - 2026-09-17

## Syfte

Team 2 fortsatte Workshop 2:s steg 7 med fokus på en privat `primary`-instans,
subnet routing, skillnaden mellan NAT och direkt routing samt åtkomst till
Spectre via Split DNS. Arbetet fortsatte därefter med steg 8 och en första
Headscale ACL-policy.

## Närvaro

Följande gruppmedlemmar var närvarande:

- Jonny Nguyen (`itzmejonny92`)
- Fajk Zhupa (`fajkzhupa-chas`)
- Tim Rundquist (`timrundquist`)
- Willi Broad Ngebi (`willibroadngebi-lab`)

Amin Mahamoud (`aminmahamoud-arch`) och Lars Törngren
(`larstorngrenchas`) var frånvarande.

## Genomfört arbete

- `team2-primary` aktiverades som `e2-micro` på `10.0.2.3` utan extern IP.
- OS Login och `block-project-ssh-keys` behölls; inga SSH-nycklar lades i
  instansmetadata.
- Teamets OS Login-identiteter fick åtkomst till `primary` via Terraform.
- Rutterna `10.0.2.0/24` och `10.0.0.2/32` verifierades som annonserade,
  godkända och aktiva i Headscale.
- Klientinställningen `accept-routes` aktiverades och åtkomst till `primary`
  verifierades med ping och SSH.
- Standard-SNAT verifierades genom att `primary` såg källan `10.0.2.2`.
- Efter avstängd subnet-router-SNAT såg `primary` klientens riktiga Tailnet-IP
  `100.64.0.3`.
- En begränsad brandväggsregel infördes för ICMP, SSH och workshopens HTTP-test
  från Tailnet till `primary`.
- Spectre-specifik MASQUERADE gjordes persistent och idempotent i Terraform.
- `dnsmasq` konfigurerades på jumphosten som proxy mot GCP DNS
  `169.254.169.254`.
- Headscale Split DNS konfigurerades för `itsx25.chas-lab.dev` via
  `100.64.0.2`.
- Spectre verifierades via `10.0.0.2` och
  `spectre.itsx25.chas-lab.dev`; HTTP svarade med en normal `301`-omdirigering.

### Headscale ACL

- Fajk skapade och aktiverade `policy.hujson` via PR #58.
- Teamet valde medvetet att ge alla registrerade medlemmar adminåtkomst för att
  förenkla det gemensamma kursarbetet. Det är inte en optimal
  least-privilege-modell och ska omprövas utanför labbmiljön.
- Den första policyn använde användarnamn utan avslutande `@`. Headscale
  `0.29.3` avvisade policyn och hamnade i en restart-loop.
- Policyn korrigerades till `fajk@`, `jonny@`, `lasse@`, `tim@` och
  `willibroad@`, validerades mot databasen och aktiverades med backup av den
  felaktiga filen.
- Headscale health svarade HTTP 200 efter korrigeringen. SSH till `primary` och
  åtkomst till Spectre verifierades från Jonny.
- Amin är ännu inte registrerad och läggs till i admin-gruppen när hans
  Headscale-användare finns.

## Pull requests och verifiering

| PR | Resultat |
| --- | --- |
| [#54](https://github.com/itsx25-team2/kurs6-team2-infra/pull/54) | `primary` aktiverad med OS Login; deploy lyckades. |
| [#55](https://github.com/itsx25-team2/kurs6-team2-infra/pull/55) | Begränsad Tailnet-regel till `primary`; deploy lyckades. |
| [#56](https://github.com/itsx25-team2/kurs6-team2-infra/pull/56) | Persistent Spectre-NAT; deploy lyckades. |
| [#58](https://github.com/itsx25-team2/kurs6-team2-infra/pull/58) | Första ACL-policyn mergad; syntaxfel upptäcktes och korrigerades efter livekontroll. |

Terraform-planerna visade inga borttagningar. Format, validering och relevanta
säkerhetskontroller lyckades före merge.

## Medlemsverifiering

Den gemensamma infrastrukturen är verifierad. Varje medlem behöver dessutom
aktivera `accept-routes` på sin egen klient och kontrollera att `10.0.2.3` går
att nå. Den individuella klientkontrollen blockerar inte den gemensamma
leveransen.

## Nästa steg

1. Slutför PB-14/issue #52 genom att dokumentera rollback och testa både
   tillåten och nekad trafik från minst två användare.
2. Följ PB-12/issue #41 så att Headscale-, dnsmasq- och Split DNS-installationen
   blir reproducerbar som kod eller granskad automation.
3. Hjälp Amin med personlig Tailnet-registrering och verifiering.

## Säker dokumentation

Inga auth-id:n, privata nycklar, access tokens, Terraform state eller andra
credentials har lagts till i dokumentationen.
