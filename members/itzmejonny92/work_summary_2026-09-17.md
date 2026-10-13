# Individuell arbetssammanfattning - Jonny Nguyen - 2026-09-17

## Syfte

Mitt fokus var att färdigställa och verifiera workshopens steg 7 på ett
pedagogiskt och säkert sätt, med spårbara Terraform-ändringar och praktiska
nätverkstester.

## Mitt arbete

- Synkade min branch med senaste `main` efter varje mergad ändring.
- Aktiverade `team2-primary` som `e2-micro` utan extern IP.
- Behöll OS Login och undvek att återinföra SSH-nycklar i metadata.
- Granskade Terraform-planer före PR och verifierade att inget togs bort.
- Verifierade annonserade och godkända Headscale-rutter.
- Aktiverade `accept-routes` på min WSL-klient.
- Testade ping, SSH och HTTP till `primary` på `10.0.2.3`.
- Jämförde SNAT med direkt routing: källan ändrades från `10.0.2.2` till min
  Tailnet-IP `100.64.0.3`.
- Införde en begränsad brandväggsregel för direkt Tailnet-trafik till
  `primary`.
- Gjorde Spectre-NAT persistent och idempotent i jumphostens startup-script.
- Installerade och verifierade `dnsmasq` som DNS-proxy på jumphosten.
- Konfigurerade och validerade Headscale Split DNS efter att en backup skapats.
- Verifierade Spectre via både IP och DNS-namn.
- Dokumenterade medlemskontrollen och dagens resultat.
- Granskade Fajks ACL-policy efter merge och upptäckte att Headscale låg i en
  restart-loop på grund av användarnamn utan avslutande `@`.
- Korrigerade policyn enligt Headscale v2-syntax, validerade den direkt mot
  databasen och verifierade Headscale health samt tillåtna flöden efteråt.
- Dokumenterade teamets medvetna beslut att ge alla registrerade medlemmar
  adminåtkomst under kurslabben.

## Viktiga lärdomar

- En annonserad route måste även godkännas i Headscale och accepteras lokalt av
  varje klient.
- Med SNAT ser den privata servern jumphostens adress. Utan SNAT kan servern se
  den autentiserade klientens Tailnet-adress, men returroute och brandvägg måste
  då stödja `100.64.0.0/10`.
- Routing bör verifieras via IP innan DNS införs. Då går det att skilja
  nätverksfel från namnuppslagningsfel.
- Manuella iptables-regler behöver motsvarande persistent konfiguration.

## Nästa steg

- Arbeta vidare med PB-14 och en Headscale ACL-policy som först testas med
  rollbackmöjlighet.
- Testa nekad trafik från en andra användare innan PB-14 stängs.
- Hjälp övriga medlemmar att verifiera `accept-routes` på sina klienter.
- Följ reproducerbarhetsarbetet för Headscale och DNS i PB-12.

## Säker dokumentation

Jag har inte sparat auth-id:n, privata SSH-nycklar, access tokens, Terraform
state eller andra credentials.
