# Jonny Nguyen - individuell arbetssammanfattning 2026-10-15

## Omfattning

Jag följde och samordnade Team 2:s byte till Comerits GCP-projekt. Målet var
att få en verifierat fungerande Terraform-deploy utan lokala service account-
nycklar och därefter städa bort en före detta medlems åtkomst.

## Mitt arbete

1. Jag kontrollerade att Terraform-konfigurationen använde projektet
   `itsx25-comerit`, Team 2:s nya state-backend och rätt WIF-variabler i
   GitHub Actions.
2. När deployen först stoppades av en otillgänglig VM-image jämförde jag
   Terraform-loggen med Comerits instruktion. Efter att utbildaren bekräftat
   rätt väg ersatte jag den gamla kursimage-referensen med
   `debian-cloud/debian-12` för både jumphost och primary.
3. Jag validerade Terraform lokalt, skapade [PR #87](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/87)
   och följde den mergade GitHub Actions-körningen tills den var grön.
4. Jag bekräftade via deployloggen att `team2-jumphost` och `team2-primary`
   skapades och att Team 2:s OS Login-behörigheter lades på rätt resurser.
5. Efter Comerits besked anslöt jag till `team2-primary` med OS Login över
   IAP. Det verifierade att åtkomstvägen fungerar utan publik SSH.
6. Jag identifierade Dennis GitHub-konto, tog bort hans direkta åtkomst till
   infra-repot och tog bort hans Chas-identitet ur Terraform-listorna.
7. Jag validerade ändringen, skapade [PR #88](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/88)
   och kontrollerade den gröna deployloggen efter merge.

## Pedagogiska lärdomar

En Terraform-deploy kan vara korrekt konfigurerad för ett nytt GCP-projekt
men ändå stanna på en beroende resurs, som en image. I detta fall fungerade
WIF, state-backend och nätresurser redan. Felet låg i att den gamla privata
image-referensen inte var åtkomlig i den nya miljön. Genom att läsa
Actions-loggen steg för steg gick det att avgränsa felet innan konfigurationen
ändrades.

Jag lärde mig också att åtkomsthantering behöver följas hela vägen. Att bara
ta bort en GitHub-collaborator räcker inte om samma person fortfarande finns
i Terraform-konfigurationen för OS Login. När identiteten togs bort ur
Terraform förstörde nästa deploy båda VM-behörigheterna automatiskt.

## Resultat

- Team 2:s infra-deploy är grön i `itsx25-comerit`.
- `team2-jumphost` och `team2-primary` är skapade med den godkända publika
  Debian 12-imagen.
- Jag har verifierat administrativ åtkomst till `team2-primary` med IAP och
  OS Login.
- Dennis GitHub- och OS Login-åtkomst till Team 2:s infrastruktur är borttagen.

Inga hemliga värden dokumenterades i arbetet.
