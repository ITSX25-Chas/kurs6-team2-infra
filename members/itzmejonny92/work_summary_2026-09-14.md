# Individuell arbetssammanfattning - Jonny Nguyen - 2026-09-14

## Syfte

Mitt fokus var att slutföra och verifiera Team 2:s WIF-migrering, lösa den
kvarvarande IAM-blockeringen och dokumentera ett säkert, reproducerbart
arbetssätt för gruppen.

## Mitt arbete

- Synkade `member/itzmejonny92` med den senaste versionen av `main`.
- Analyserade misslyckade GitHub Actions-körningar och identifierade saknade
  `compute.firewalls.create`- och `compute.firewalls.delete`-behörigheter.
- Granskade bootstrap-planen innan apply.
- Tog bort den tidigare publika `allAuthenticatedUsers`-bindningen från
  Terraform state-bucketen genom bootstrap-apply.
- Försökte använda en minimal egen brandväggsroll, men konstaterade att mitt
  kurskonto saknar `iam.roles.create`.
- Dokumenterade säkerhetsavvägningen och ersatte lösningen med den tillgängliga
  inbyggda rollen `roles/compute.securityAdmin`.
- Validerade Terraform, pushade ändringen och skapade PR #36.
- Testade deployen från min branch innan merge och verifierade därefter en
  lyckad deploy från `main`.
- Kontrollerade att den breda brandväggsregeln var borta och att de två nya
  reglerna hade rätt källor, portar och mål-taggar.
- Inaktiverade två långlivade service account-nycklar och verifierade WIF medan
  nycklarna inte kunde användas.
- Raderade därefter båda nycklarna permanent och verifierade att inga
  användarhanterade nycklar återstod.
- Körde ett sista lyckat WIF-test från `main` efter raderingen.
- Stängde issue #8 och #9 med verifieringsresultat och länkar.
- Skapade en gemensam säker anslutningsguide och uppdaterade README,
  produktbacklogg och min personliga dokumentationsyta.

## Viktiga beslut

- Teamet ska inte använda lokala service account-nycklar för CI/CD.
- GitHub Actions ska fortsätta använda WIF och kortlivade credentials.
- En bredare inbyggd brandväggsroll accepterades eftersom projektet inte
  tillåter att studentkontot skapar en minimal custom role. Avvägningen är
  dokumenterad och bör följas upp med utbildaren.
- Terraform apply ska normalt ske via granskad PR och GitHub Actions, inte
  direkt från en medlems dator.

## Verifieringsbevis

- [PR #36](https://github.com/itsx25-team2/kurs6-team2-infra/pull/36)
- [Lyckat branchtest](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34824365603)
- [Lyckad deploy efter merge](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34825510839)
- [Lyckat test med inaktiverade nycklar](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34825821057)
- [Lyckat sluttest efter nyckelradering](https://github.com/itsx25-team2/kurs6-team2-infra/actions/runs/34826524653)
- [Issue #8](https://github.com/itsx25-team2/kurs6-team2-infra/issues/8)
- [Issue #9](https://github.com/itsx25-team2/kurs6-team2-infra/issues/9)

## Kvarvarande uppföljning

- Granska `public_access_prevention` och öppna bucket-issues.
- Slutför teamets dokumenterade rutin för GitHub Actions secrets och
  repository variables.
- Be gruppmedlemmarna testa den gemensamma anslutningsguiden.
- Undersök med utbildaren om en smalare brandväggsroll kan tillhandahållas.

## Senare uppföljning av medlemsarbete

- Synkade in Fajks PR #39 och Willis PR #40 från `main`.
- Verifierade att båda efterföljande deployerna från `main` lyckades.
- Kontrollerade live att OS Login är aktiverat och att metadatahanterade
  SSH-nycklar blockeras på jumphosten.
- Identifierade att Tim och Amin saknas i `os_admin_users` och att alla listade
  identiteter har administrativ OS Login. Issue #15 återöppnades för fortsatt
  granskning och minsta möjliga behörighet.
- Kontrollerade att jumphostens service account saknar projektroller.
- Granskade Willis Headscale-anteckningar. Driftstatus kunde inte verifieras
  oberoende eftersom min SSH-nyckel inte var upplåst vid kontrollen.
- Skapade issue #41 för verifiering, säker konfiguration och reproducerbar
  installation av Headscale.
- Uppdaterade README, anslutningsguide, backlogg och teamsammanfattning så att
  de beskriver den nya OS Login-modellen.

## Säker dokumentation

Jag har inte dokumenterat privata nycklar, credentials, känsliga statevärden
eller flaggor. Nyckel-ID:n används inte som autentiseringsuppgifter och har
utelämnats från denna sammanfattning eftersom de raderade resurserna inte
behöver återanvändas.
