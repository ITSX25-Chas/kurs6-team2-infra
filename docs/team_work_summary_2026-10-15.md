# Team 2 - arbetssammanfattning 2026-10-15

## Omfattning

Team 2 slutförde flytten av infrastrukturdriften till Comerits GCP-projekt
`itsx25-comerit`. Arbetet utgick från Comerit-instruktionen: den färdiga
grundmiljön används som den är, medan Terraform-konfigurationen, WIF och
state-backend pekas om till Team 2:s nya resurser.

## Genomfört arbete

1. Projekt-ID och Terraform-backend var redan uppdaterade till
   `itsx25-comerit` respektive Team 2:s tilldelade state-bucket.
2. GitHub Actions-variablerna för Workload Identity Federation pekar på Team
   2:s provider och CI/CD-servicekonto. Pipelinen använder därför kortlivade
   identiteter i stället för nycklar i klartext.
3. Den första deployen visade att den gamla privata image-referensen inte
   kunde användas från Comerits projekt. Efter besked från utbildaren byttes
   båda VM-resurserna till den godkända publika imagen
   `debian-cloud/debian-12` i [PR #87](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/87).
4. Deploy-workflowet skapade `team2-jumphost` och `team2-primary` i zonen
   `europe-north2-b`. Terraform rapporterade `16 added, 0 changed, 0
   destroyed`.
5. Comerit öppnade SSH via IAP efter den lyckade deployen. OS Login och IAP
   verifierades genom att Team 2 kunde ansluta till `team2-primary` utan att
   öppna SSH mot internet.
6. Dennis, som har lämnat kursen, togs bort från infra-repots direkta
   collaborators. I [PR #88](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/88)
   togs hans identitet också bort från Terraform-konfigurationen.
7. Lasse skickade Team 2:s Rules of Engagement (ROE) till utbildaren för
   granskning. Dokumentet anger ramarna för det kommande Red Team-testet;
   inget test påbörjas innan ROE har godkänts och den tilldelade målmiljön
   har bekräftats.

## Verifiering

- Deploy-workflowet för [PR #87](https://github.com/ITSX25-Chas/kurs6-team2-infra/actions/runs/38710912767)
  avslutades grönt.
- Båda Team 2-VM:erna skapades i `itsx25-comerit`.
- IAP-anslutning och OS Login fungerar för både `team2-primary` och
  `team2-jumphost`. Båda anslutningarna verifierades från en interaktiv
  VS Code-terminal med Team 2:s Chas-konto.
- Deploy-workflowet för [PR #88](https://github.com/ITSX25-Chas/kurs6-team2-infra/actions/runs/38737868779)
  avslutades grönt.
- Terraform förstörde Dennis `compute.osAdminLogin`-behörighet på både
  `team2-jumphost` och `team2-primary`: `0 added, 0 changed, 2 destroyed`.
- Dennis GitHub-konto `dhskymill` finns inte längre i infra-repots
  collaboratorlista.
- ROE är inskickad till utbildaren. Teamet inväntar godkännande och eventuell
  kompletterande information om målmiljö och kontaktväg.

## Säkerhet och arbetssätt

- All förändring av molnresurser gjordes via det federerade CI/CD-kontot.
- IAP används för SSH, vilket innebär att port 22 inte behöver exponeras mot
  internet.
- Endast uppgifter som behövs för spårbarhet dokumenteras. Nycklar, tokens,
  state-innehåll och andra hemliga värden sparas inte i repot.
- Åtkomstborttagningen gjordes i två lager: först GitHub-repoåtkomst, sedan
  OS Login i infrastrukturen. Det förhindrar att behörigheten återkommer vid
  en senare deploy.

## Nästa steg

1. Fortsätt använda IAP och OS Login för administrativ åtkomst till Team 2:s
   VM:er.
2. Håll medlemslistan i Terraform och GitHub-collaborators synkroniserad när
   gruppens deltagare förändras.
3. Dokumentera och granska framtida infrastrukturförändringar i separata
   PR:er med gröna Actions-körningar före merge.
