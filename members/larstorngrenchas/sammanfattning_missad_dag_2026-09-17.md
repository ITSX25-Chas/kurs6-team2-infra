# Sammanfattning för Lars Törngren - missad dag 2026-09-17

## Dagens mål

Teamet färdigställde workshopens steg 7 med privat routing och påbörjade steg
8 med Headscale ACL. Lars var frånvarande men hans befintliga Headscale-användare
`lasse` och nod `recharge` finns kvar.

## Steg 7: primary och routing

- `team2-primary` kör som `e2-micro` på `10.0.2.3` utan extern IP.
- Instansen använder OS Login och blockerar metadatahanterade SSH-nycklar.
- Jumphosten annonserar `10.0.2.0/24` och `10.0.0.2/32` genom Headscale.
- NAT och direkt routing jämfördes. Efter avstängd subnet-router-SNAT såg
  `primary` klientens riktiga Tailnet-IP.
- En begränsad brandväggsregel tillåter ICMP, SSH och workshopens HTTP-test från
  Tailnet till `primary`.
- Spectre-NAT är persistent i Terraform.
- Split DNS går via `dnsmasq` på jumphosten, så
  `spectre.itsx25.chas-lab.dev` löses till `10.0.0.2`.

## Steg 8: Headscale ACL

- Fajks PR #58 lade till `policy.hujson` och aktiverade policyn på Headscale.
- Teamets medvetna kurslabb-beslut är att alla registrerade medlemmar ingår i
  `group:admin` för smidigt samarbete. Det är inte en least-privilege-modell.
- Lasse finns i policyn som `lasse@`.
- Den första versionen saknade `@` och fick Headscale att krascha i en
  restart-loop. Syntaxen korrigerades, policyn validerades och health svarade
  därefter HTTP 200.
- Steg 8 är inte helt klart. Nekad trafik från en andra användare och en
  dokumenterad rollback ska fortfarande testas i issue #52.

## Det här behöver Lars göra

1. Starta Tailscale och kontrollera att noden `recharge` är online.
2. Aktivera annonserade rutter:

```bash
tailscale set --accept-routes=true
```

Använd `sudo` om klienten kräver det.

3. Verifiera privata resurser:

```bash
tailscale status
ping 10.0.2.3
ping spectre.itsx25.chas-lab.dev
```

4. Testa OS Login till `primary` enligt den gemensamma anslutningsguiden.
5. Rapportera resultatet i teamet så att ACL-verifieringen kan dokumenteras.

## Läs vidare

- [Gemensam anslutningsguide](../../docs/gemensam_anslutningsguide.md)
- [Dagens teamsammanfattning](../../docs/team_work_summary_2026-09-17.md)
- [Product Backlog](../../docs/product_backlog.md)
- [PR #58](https://github.com/itsx25-team2/kurs6-team2-infra/pull/58)

## Säkerhet

Dela inte privata SSH-nycklar, auth-id:n, tokens eller Terraform state. Lägg
inte till manuella undantag i ACL-policyn utan branch, granskning och rollback.
