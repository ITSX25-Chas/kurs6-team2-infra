# Jonny Nguyen - individuell arbetssammanfattning 2026-10-13

## Omfattning

Jag deltog i och samordnade den kontrollerade flytten av Team 2:s infra- och
applikationsrepo till `ITSX25-Chas`. Fokus var att verifiera varje steg innan
nästa förändring gjordes och att miljön skulle vara grön efter flytten.

## Mitt arbete

1. Jag verifierade åtkomst till primary och kontrollerade den begränsade
   RBAC-lösningen för servicekontot `github-deployer`. Kontot kan hantera
   den nödvändiga image-policyn men kan inte ta bort den.
2. Jag granskade Terraform-planen för WIF-övergången. Den lade till den nya
   repoidentiteten och behöll den gamla utan att förstöra resurser.
3. Jag verifierade att infra-workflowet fungerade både före och efter
   repoflytten. Det visade att WIF var korrekt för den nya adressen.
4. Jag följde appdeployens loggar efter flytten och identifierade två
   separata problem:
   - GHCR-referenser behöver gemener, medan GitHubs organisationsnamn kan
     innehålla versaler.
   - Image-policyn måste matcha exakt det OIDC-subject som GitHub Actions
     lägger i signeringscertifikatet.
5. Jag gjorde, testade och skickade PR:erna #38 och #39. De granskades och
   mergades före den slutliga gröna deployen.
6. Jag uppdaterade min lokala `origin`-remote för både infra och app, och
   deltog i dokumentationsuppdateringen för de nya repo-adresserna.

## Pedagogiska lärdomar

En organisationsflytt är mer än att ändra en GitHub-adress. Flera identiteter
kan vara bundna till den gamla adressen:

- WIF använder repoidentiteten för att avgöra om ett workflow får använda ett
  GCP-servicekonto.
- GHCR kräver gemena image-referenser.
- Cosign och ClusterImagePolicy använder GitHub Actions OIDC-subject för att
  verifiera vem som signerade en image.

Genom att behålla gammal och ny WIF-identitet samtidigt kunde vi verifiera
den nya vägen utan att skapa ett onödigt driftavbrott. Genom att läsa
Actions-loggarna stegvis kunde vi skilja på behörighetsfel, image-namn och
signaturpolicy i stället för att ändra flera saker samtidigt.

## Resultat

- Infra-workflowet är grönt från `ITSX25-Chas/kurs6-team2-infra`.
- Appdeployen är grön från `ITSX25-Chas/team2-company-website`.
- Kubernetes-rollouten är klar och appen svarar med frisk databasanslutning.
- Aktiva dokument använder nu de nya kanoniska repo-adresserna.

Inga hemliga värden skrevs ned i dokumentationen.
