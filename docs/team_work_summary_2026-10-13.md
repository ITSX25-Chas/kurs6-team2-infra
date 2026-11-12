# Team 2 - arbetssammanfattning 2026-10-13

## Närvaro

- Närvarande: Jonny, Fajk, Tim, Lasse och Wilibroad.
- Frånvarande: Amin.

## Omfattning

Gruppen genomförde en kontrollerad flytt av Team 2:s två kursrepo till
organisationen `ITSX25-Chas`:

- Infrastruktur: `ITSX25-Chas/kurs6-team2-infra`
- Applikation: `ITSX25-Chas/team2-company-website`

Målet var att behålla en fungerande CI/CD-kedja och en frisk körande
applikation under hela flytten.

## Genomfört arbete

1. Miljön kontrollerades före flytten. Appens RBAC för
   `github-deployer` kompletterades med minsta nödvändiga rättigheter för
   `ClusterImagePolicy`: `get`, `create`, `patch` och `update`. Rätten att
   ta bort policyn gavs inte.
2. WIF-konfigurationen för infra-repot planerades på nytt. Terraform visade
   `1 to add, 1 to change, 0 to destroy` och applicerades först efter
   kontroll. Både den gamla och nya repoidentiteten tilläts under
   övergången.
3. Ett manuellt infra-workflow från det gamla repot kördes grönt innan
   flytten. Efter flytten kördes samma workflow grönt från det nya repot,
   vilket verifierade den nya WIF-identiteten.
4. Infra-repot flyttades först. App-repot flyttades därefter till ett unikt
   namn eftersom ett annat repo redan använde namnet `company-website` i
   organisationen.
5. Appdeployen kördes från det nya repot. Två flyttspecifika fel upptäcktes
   och rättades i separata, granskade PR:er:
   - [PR #38](https://github.com/ITSX25-Chas/team2-company-website/pull/38)
     normaliserar GHCR-image-referensen till gemener.
   - [PR #39](https://github.com/ITSX25-Chas/team2-company-website/pull/39)
     rättar OIDC-regexen i image-policyn så att den matchar den nya
     organisationsidentiteten.
6. Aktiva README- och driftdokument uppdaterades till de nya kanoniska
   repo-adresserna via [infra PR #83](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/83)
   och [app PR #40](https://github.com/ITSX25-Chas/team2-company-website/pull/40).

## Verifiering

- Infra-workflowet körde grönt från
  `ITSX25-Chas/kurs6-team2-infra` efter flytten.
- Appens deploy-workflow körde grönt från
  `ITSX25-Chas/team2-company-website` efter de två policyfixarna.
- Kubernetes-rollouten slutfördes.
- Applikationens interna health endpoint svarade:

  ```json
  {"db":"connected","status":"healthy"}
  ```

Det bekräftar att applikationen och databasen fungerade efter flytten.

## Säkerhet och återställning

- Inga tokens, nycklar eller andra hemliga värden dokumenterades.
- Den gamla WIF-identiteten behålls tillfälligt som övergångsskydd medan den
  nya identiteten redan är verifierad i drift.
- GitHub omdirigerar gamla repo-adresser, medan aktiva dokument nu använder
  de nya kanoniska adresserna.
- Daterade arbetssammanfattningar behölls oförändrade för att bevara sin
  historiska kontext.

## Nästa steg

1. Efter en överenskommen stabiliseringsperiod kan den gamla WIF-identiteten
   tas bort i en egen granskad ändring.
2. Samtliga medlemmar bör uppdatera sin lokala `origin`-remote till de nya
   organisationsadresserna om deras Git-klient inte redan följer GitHubs
   omdirigering.
3. Fortsätt använda vanliga PR-granskningar och gröna Actions-körningar som
   kontroll före ändringar i produktion.
