**Individuell arbetssammanfattning Lars Törngren**

**Genomfört arbete med Team 2 Infrastruktur**

- Jag konstaterade att den stora risken med det ursprungliga repot är blocket som innehåller allAuthenticatedUsers. Därför skapade jag en [”issue” med förslag på åtgärder](https://github.com/ITSX25-Chas/kurs6-team2-infra/issues/13).
- Nästa steg var att samla in alla medlemmarnas publika SSH-nycklar för att lägga in dessa i terraform.tfvars, så att alla får möjlighet att logga in via jumpservern. Jag genomförde i samband med detta [pull request #19](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/19).
- Därefter dokumenterade jag risker med Google Service Account Key om den hamnar på avvägar ([pull request #21](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/21) och [pull request #24](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/24)), exempelvis datastöld, spionage, ransomware eller obehörig kryptoutvinning via Google Cloud ([https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/GSA\_key\_risks.md](https://github.com/ITSX25-Chas/kurs6-team2-infra/blob/main/docs/GSA_key_risks.md)).
- Jag fick slutligen proxy att fungera i Google Chrome via ett terminalkommando, en SOCKS5-proxy med dynamisk port forwarding över SSH och kunde ansluta till jumpservern.
- Den bortglömda filen terraform.tfstate.backup upptäckte jag i den zip-fil vi fick från Dennis. I den låg en Base64-kodad flagga.
- I vår tävling (Challenge) insåg jag att det var något av formulären i Spectre-admin som innebar säkerhetsrisken genom någon slags ”injection”. En grundregel för alla slags formulär som användare på en webbplats kan mata in information i, ska filtreras och saneras på något sätt. Det vill säga att inmatningen kontrolleras och verifieras enligt förutbestämda regler för vad som är giltig inmatning.
- Jag genomförde en kodjustering i bootstrap/main.tf för att ta bort blocket som innehåller allAuthenticatedUsers ([pull request #27](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/27)).
- Därefter gjorde jag justeringar av product backlog ([pull request #35](https://github.com/ITSX25-Chas/kurs6-team2-infra/pull/35)).
- Efter ändringar på Google Cloud, kontrollerade jag att jag kunde ansluta till jumpservern på det nya, uppdaterade sättet.
- Sedan installerade jag Tailscale lokalt på min dator.
- Nästa steg var att skapa mig själv som användare i headscale på jumpserver, samt testade att jag kunde ansluta till [https://team2.itsx25.chas-lab.dev](https://team2.itsx25.chas-lab.dev/).
- Dessutom testade jag att jag kunde pinga team2-jumphost och andra användare på headscale.
- Slutligen [stängde jag issue #16](https://github.com/ITSX25-Chas/kurs6-team2-infra/issues/16) som hade att göra med uniform\_bucket\_level\_access. Jag skrev en förklaring i kommentarsfältet om vad som eventuellt kan ställa till problem med denna inställning.

**Genomfört arbete Company Website**

- Jag genomförde säkerhets-justeringar i github-permissions.yaml.
- Därefter skrev jag en säkerhetsrapport för Company Website ([pull request #14](https://github.com/ITSX25-Chas/team2-company-website/pull/14), [https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report.md](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report.md)).
- Det blev senare även ett tillägg till säkerhetsrapporten ([https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report-addendum.md](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/security-report-addendum.md), [pull request #27](https://github.com/ITSX25-Chas/team2-company-website/pull/27)).
- Jag gjorde också en avgränsad korrigering i profilflödet: roll och interna anteckningar blir serverstyrda, och avstängda konton kan inte läsas via direkt profil-URL. Ändringar i [routes.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/src/company_website/routes.py), [edit\_profile.html](https://github.com/ITSX25-Chas/team2-company-website/blob/main/src/company_website/templates/edit_profile.html), [test\_app.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/tests/test_app.py).
- Flask-debugläge var påslaget som standard i wsgi.py, och containern saknade explicit icke-root-/least-privilege-konfiguration. Volymen används bara för SQLite-data, så en icke-root-process går att införa utan att ändra appens lagringsmodell. I ett första skede ändrade vi till en användare (10001) som inte fanns, vilket ställde till behörighetsproblem. Korrigerade sedan Dockerfile, så att användaren och gruppen skapades. Ändrade filer är wsgi.py, deployment.yaml, deploy.yml och Dockerfile genom [pull request #32](https://github.com/ITSX25-Chas/team2-company-website/pull/32).
- Repot har en separat .dockerignore, så COPY . . drar inte med lokala hemligheter av misstag. Inga kända sårbara Python-beroenden eller Bandit-fynd hittades. Däremot hade .dockerignore en konkret risk för läckage: till skillnad från .gitignore uteslöt den inte .env.\* och kubeconfig-filer, och Docker bygger från just den kontexten. Uppdaterade därför .dockerignore-filen. Ändrad fil är alltså .dockerignore.
- Ett kvarvarande autentiseringsproblem var den fristående legacy-databasen: den kopieras bara första gången, men dess gamla hash accepterades fortsatt efter att primärlösenordet ändrats. Eftersom appen själv inte har någon legitim legacy-import eller lösenordsändringsfunktion tog jag bort den inloggningsvägen. Ett test visade sedan att gamla uppgifter inte längre fungerar. Ändrade filer är auth.py, db.py, config.py, app.py, test\_app.py. Dessutom raderades filen 000\_create\_legacy\_users.sql. Tog också bort en referens till den borttagna legacy-konfigurationen. [Dessa ändringar genomfördes genom pull request #29](https://github.com/ITSX25-Chas/team2-company-website/pull/29/changes), samt vissa kompletterande justeringar i pull request #30 och #31.
- Den gamla autentiseringsvägen är nu borttagen. I seed-datan för migration finns flera lösenords-/backup-/infrastrukturuppgifter. Ett seed-konto hade också en intern anteckning (pwned). Dessa tas bort vid ny installation och lägger till en migration som rensar dessa uppgifter i befintliga databaser. Ändrade filer 004\_seed\_user\_profiles.sql, 007\_remove\_sensitive\_seed\_notes.sql.
- Lade ner en hel del arbete på att hitta flaggorna på Company Website (Challenge).

**Säkerhetsrapport med dokumenterade brister och koppling till MITRE ATT&CK.**

[https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue\_team\_sakerhetsrapport\_2026-10-26.md](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/blue_team_sakerhetsrapport_2026-10-26.md)

**Användning av AI**

Jag har använt både Gemini och Copilot som stöd under Blue Team-arbetet, som ett bollplank och diskussionspartner. Jag har fått hjälp av AI med att strukturera och sammanfatta information, förklara tekniska lösningar eller kod som jag inte förstått samt förslag på kodändringar. Alla ändringar av koden har diskuterats inom gruppen, liksom övriga dokument som jag tagit fram (som säkerhetsrapport och dokumentet om risker med Googles säkerhetsnycklar).

Min bedömning är att AI fungerar bra för att förklara tekniska samband, att strukturera stora mängder information och att ge förslag på analys och på programkod. Däremot kan man inte förlita sig på AI till att fatta egna beslut, eller göra helt egna riskbedömningar. jag är, tillsammans med mina gruppmedlemmar, ansvarig för analys, rekommendationer, och alla kodjusteringar.

**Länkar till repositories på GitHub**

[Team 2 Infrastruktur](https://github.com/ITSX25-Chas/kurs6-team2-infra)

[Team 2 Company Website](https://github.com/ITSX25-Chas/team2-company-website)
