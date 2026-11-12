# Individuell arbetssammanfattning - Lars Törngren - 2026-10-01

## Kortfattat

Arbete med härdning av company-website.

## Analys
- Applikationens exponerade ytor: autentisering, routes, databasåtkomst och driftkonfiguration. Jag körde relevanta tester och kontroll av konkreta fynd.

- Appen har två autentiseringskällor (primär och legacy), och sessions-/cookie-säkerheten styrs delvis av miljön. Har dessa vägar säkra begränsningar? Skapar mallar eller deploymentinställningar ytterligare exponering?

- Problem: profilformuläret uppdaterar rollfältet från användarens POST-data, medan login hanterar legacy-konton separat. Är det så att roller påverkar behörigheter? Har templates, migrations-data eller CI exponerade hemligheter?

- Problem: en inloggad användare själv kan skriva över ”role” och ”internal_notes” genom post-formulär vid ändring av profil. Kontroll med befintliga databasfält och ett reproducerbart test.

- Problem: sajten listar alla konton, även avstängda, och profiländringen accepterar serverstyrda fält. Vilka av dessa är faktiska åtkomstproblem och vilka är avsiktliga testdata?

- Problem: Docker-caontainern körs som root.

## Genomförda åtgärder

- Avgränsad korrigering i profilflödet: roll och interna anteckningar blir serverstyrda, och avstängda konton kan inte läsas via katalogen eller direkt profil-URL. Ändringar i routes.py, edit_profile.html, test_app.py.

- Flask-debugläge var påslaget som standard i wsgi.py, och containern saknade explicit icke-root-/least-privilege-konfiguration. Volymen används bara för SQLite-data, så en icke-root-process går att införa utan att ändra appens lagringsmodell. I ett första skede ändrade vi till en användare (10001) som inte fanns, vilket ställde till behörighetsproblem. Korrigerade sedan Dockerfile, så att användaren och gruppen skapades. Ändrade filer är wsgi.py, deployment.yaml, deploy.yml och Dockerfile.

- Repot har en separat .dockerignore, så COPY . . drar inte med lokala hemligheter av misstag. Inga kända sårbara Python-beroenden eller Bandit-fynd hittades. Däremot hade .dockerignore en konkret risk för läckage: till skillnad från .gitignore uteslöt den inte .env.* och kubeconfig-filer, och Docker bygger från just den kontexten. Uppdaterade därför .dockerignore-filen. Ändrad fil är alltså .dockerignore.

- Ett kvarvarande autentiseringsproblem var den fristående legacy-databasen: den kopieras bara första gången, men dess gamla hash accepterades fortsatt efter att primärlösenordet ändrats. Eftersom appen själv inte har någon legitim legacy-import eller lösenordsändringsfunktion tog jag bort den inloggningsvägen. Ett test visade sedan att gamla uppgifter inte längre fungerar. Ändrade filer är auth.py, db.py, config.py, app.py, test_app.py. Dessutom raderades filen 000_create_legacy_users.sql. Tog också bort en referens till den borttagna legacy-konfigurationen.

- Den gamla autentiseringsvägen är nu borttagen. I seed-datan för migration finns flera lösenords-/backup-/infrastrukturuppgifter. Ett seedkonto hade också en intern anteckning (pwned). Dessa tas bort vid ny installation och lägger till en migration som rensar dessa uppgifter i befintliga databaser. Ändrade filer 004_seed_user_profiles.sql, 007_remove_sensitive_seed_notes.sql, 



