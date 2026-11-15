## Säkerhetsrapport

**Executive Summary**

Detta projekt har flera allvarliga säkerhetsbrister som tillsammans utgör en hög risk för konfidentialitet, integritet och autentisering. Det mest kritiska problemet är SQL-injection i login-flödet, följt av felaktig lösenordshantering, hårdkodade hemligheter, bristande auktorisation och exponering av känslig intern information i seed-data. Om systemet används i en verklig miljö med användardata eller produktionsdata kan detta leda till obehörig åtkomst, dataläckage och manipulation av användarkonton.

Det rekommenderas att projektet inte publiceras eller används med riktiga användare förrän de viktigaste sårbarheterna är åtgärdade. En genomgripande säkringsprocess krävs innan systemet kan anses vara säkert nog för produktion.

**Sammanfattning**

Detta projekt innehåller flera tydliga och allvarliga säkerhetsbrister i autentisering, auktorisation, datalagring och konfiguration. Den största risken kommer från SQL-injection i login-flödet, felaktig lösenordshantering, hårdkodade hemligheter och brist på åtkomstkontroll i profil- och användardata. Projektet är inte säkert för produktion och bör betraktas som högrisk om det används i en verklig miljö.

**Scope**

Granskningen omfattar den Flask-baserade webbapplikationen i projektet, inklusive:

- autentisering i [src/company\_website/auth.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/auth.py)
- routing och profiloperationer i [src/company\_website/routes.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/routes.py)
- konfiguration i [src/company\_website/config.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/config.py)
- databasinitiering i [src/company\_website/db.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/db.py)
- seed-data i [src/company\_website/migrations/002\_seed\_data.sql](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/migrations/002_seed_data.sql) och [src/company\_website/migrations/004\_seed\_user\_profiles.sql](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/migrations/004_seed_user_profiles.sql)

**Metod**

Granskningen baseras på genomgång av koden och manuell analys av autentiserings- och databasflöden, säkerhetskonfiguration och seed-data i projektet.

**Resultat**

**1. SQL-injection i login-funktionen**

**Sårbarhet:** SQL injection
**Källkod:** [src/company\_website/auth.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/auth.py)
**Risknivå:** Hög

I login-funktionen byggs SQL-frågan med en formatsträng och användarinmatning i SQL-kod:

query = f"SELECT \* FROM users WHERE username = '{username}' AND password\_hash = '{password}'"

cursor.execute(query)

Detta gör att användaren kan injicera SQL-kod i username eller password, vilket kan förändra sökfrågan och ge tillgång till data man inte borde ha.

**Konsekvens:**

- Databasintrång
- Läsning av användardata
- Manipulation av användarkonton
- Potentiellt full kontroll över applikationens databas

**Rekommenderad åtgärd:**

- Använd parametriserade SQL-frågor utan f-string interpolation.
- Exempel:

cursor.execute(

"SELECT \* FROM users WHERE username = ?",

(username,)

)

**2. Felaktig behandling av lösenord och hashes**

**Sårbarhet:** Svag autentisering och felaktig lösenordshantering
**Källkod:** [src/company\_website/auth.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/auth.py)
**Risknivå:** Hög

Koden använder inte ett korrekt lösenordsflöde. Istället för att verifiera lösenordet mot ett säkert hashvärde i databasen, jämförs password\_hash direkt mot användarens inmatning i SQL-frågan. Den enda användningen av check\_password\_hash() är i ett sekundärt villkor, men huvudflödet för login är inte korrekt implementerat.

**Konsekvens:**

- Lösenord kan verifieras felaktigt eller undvikas
- Hashlogiken blir otillförlitlig
- Risk för autentiseringsbypass

**Rekommenderad åtgärd:**

- Hasha alla lösenord med en stark algoritm, exempelvis scrypt eller bcrypt.
- Verifiera med check\_password\_hash() eller motsvarande säker metod.
- Använd en tydlig, korrekt autentiseringsmodell utan att lägga lösenord i SQL-frågor.

**3. Hårdkodad hemlighet i konfiguration**

**Sårbarhet:** Hårdkodad hemlighet/nyckel
**Källkod:** [src/company\_website/config.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/config.py)
**Risknivå:** Hög

SECRET\_KEY = 'dev-secret-key'

Detta är mycket olämpligt för produktionsmiljöer. Flask-sessioner och cookies är otillräckligt skyddade om SECRET\_KEY är välkänd eller statisk i koden.

**Konsekvens:**

- Session hijacking
- Förfalskade cookies
- Känsliga autentiseringsuppgifter kan utnyttjas om nyckeln blir känd

**Rekommenderad åtgärd:**

- Lagra hemligheter i miljövariabler eller en betrodd säkerhetshanterare.
- Använd en lång, slumpmässig nyckel som inte finns i versionskontroll.
- Aktivera säkra cookie-flaggor i Flask.

**4. Brist på auktorisation vid profilredigering**

**Sårbarhet:** Insecure Direct Object Reference (IDOR)
**Källkod:** [src/company\_website/routes.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/routes.py)
**Risknivå:** Hög

edit\_profile(id) hämtar användarprofilen baserat på ett ID i URL:en utan att kontrollera om den inloggade användaren faktiskt har rätt att ändra den profilen.

**Exempel:**

@main\_bp.route('/profiles/<int:id>/edit', methods=\['GET', 'POST'\])

@login\_required

def edit\_profile(id):

...

Det finns ingen check som verifierar current\_user.id == id.

**Konsekvens:**

- En användare kan redigera andras profiler
- Läckage av interna uppgifter
- Manipulation av användardata

**Rekommenderad åtgärd:**

- Kontrollera att current\_user.id matchar den begärda profilen.
- Begränsa redigering till den egna användaren om inte admin-rättigheter finns.
- Implementera rollbaserad åtkomstkontroll för känsliga operationer.

**5. Exponering av känslig intern information**

**Sårbarhet:** Informationsläcka
**Källkod:** [src/company\_website/migrations/004\_seed\_user\_profiles.sql](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/migrations/004_seed_user_profiles.sql)
**Risknivå:** Hög

Seed-data innehåller text som avslöjar:

- staging DB-lösenord
- sökvägar till backups
- interna projektkodnamn
- admin-panelens sökväg

Detta visar att känslig information lagras i versionerad kod och kan exponeras i produktion eller i testmiljöer.

**Konsekvens:**

- Läckage av systemhemligheter
- Förenklad attack mot miljöer
- Ökad risk för insiderattacker och externa attacker

**Rekommenderad åtgärd:**

- Ta bort all intern information från kod (även tidigare versioner).
- Använd separata miljövariabler/säker lösenordshantering för hemligheter.
- Exponera aldrig känsliga uppgifter i seed-data.

**6. Brist på CSRF-skydd**

**Sårbarhet:** Cross-Site Request Forgery (CSRF)
**Källkod:** [src/company\_website/routes.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/routes.py)
**Risknivå:** Hög

Profiluppdatering sker via POST utan CSRF-token eller skydd. Detta gör att en angripare kan försöka få en inloggad användare att skicka en skadlig förfrågan utan att förstå det.

**Konsekvens:**

- Icke autentiserade ändringar i användardata
- Förfalskade uppdateringar
- Potentiell manipulation av användarprofiler

**Rekommenderad åtgärd:**

- Använd Flask-WTF eller en likvärdig CSRF-skyddslösning.
- Inkludera CSRF-token i formulär och verifiera på server-sidan.

**7. Otydligt session- och cookie-säkerhet**

**Sårbarhet:** Svag sessionsäkerhet
**Källkod:** [src/company\_website/app.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/app.py), [src/company\_website/config.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/config.py)
**Risknivå:** Medium till hög

Det finns ingen tydlig konfiguration för säkra cookies, exempelvis:

- SESSION\_COOKIE\_SECURE
- SESSION\_COOKIE\_HTTPONLY
- SESSION\_COOKIE\_SAMESITE

Flask använder standardinställningar om inget specificeras, och det är inte tillräckligt för produktion.

**Konsekvens:**

- Session theft
- Förvärrad risk för ross-site scripting
- Cookies kan exfiltreras i osäkra miljöer

**Rekommenderad åtgärd:**

- Aktivera SESSION\_COOKIE\_SECURE, SESSION\_COOKIE\_HTTPONLY och SESSION\_COOKIE\_SAMESITE='Lax' eller strängare.
- Kontrollera HTTPS i produktion.

**8. Databasdesign och datahantering är inte säkert för produktion**

**Sårbarhet:** Otillräcklig produktionstillförlitlighet
**Källkod:** [src/company\_website/db.py](https://github.com/ITSX25-Chas/team2-company-website/blob/main/docs/src/company_website/db.py)
**Risknivå:** Medium

Projektet använder SQLite med en lokal fil i filsystemet. Det fungerar för demo eller små applikationer, men är inte ersättning för en databas som stöder säkerhet, åtkomstkontroll, säkra autentiseringsmekanismer och drift med production-grade.

**Konsekvens:**

- Mindre säkert i produktionsmiljöer
- Mindre skalbarhet och kontroll
- Högre risk vid filsystemåtkomst

**Rekommenderad åtgärd:**

- Använd en säker databas för produktion, exempelvis PostgreSQL eller MySQL.
- Separera applikations- och databas-sekretess.
- Implementera säker körning, backup och åtkomstkontroll.

**Kritiska fynd**

De mest allvarliga bristerna är:

1. SQL injection i login
2. felaktig lösenordshantering
3. hårdkodad SECRET\_KEY
4. bristande åtkomstkontroll i profilredigering
5. exponering av hemligheter i seed-data

Dessa problem tillsammans gör att applikationen inte bör användas med riktiga användare eller känsliga data.

**Riskbedömning**

| **Kategori** | **Bedömning** |
| --- | --- |
| Konfidentialitet | Hög |
| --- | --- |
| Integritet | Hög |
| Tillgänglighet | Medium |
| Autentisering | Hög |
| Auktorisation | Hög |
| Sårbarhet mot webbförsvar | Hög |

**Rekommenderade nästa steg**

1. Åtgärda SQL injection i login.
2. Implementera korrekt lösenordshashning och verifiering.
3. Flytta alla hemligheter till miljövariabler.
4. Lägg in strikt åtkomstkontroll i profilredigering.
5. Lägg till CSRF-skydd på alla formulär med state-changing.
6. Ta bort känslig data från SQL-migrationer.
7. Använd en produktionstestad databas och säkra cookie-inställningar.
8. Gör en sekundär kodgranskning efter patchning.

**Slutsats**

Projektet innehåller flera tydliga säkerhetsproblem som inte kan ignoreras. Den största riskgruppen är autentisering och auktorisation, men även dataläckage och hemlighetsförvaltning är allvarliga. Om systemet inte genomgår en genomgripande säkringsprocess är det inte lämpligt för produktionsanvändning.

**Dokumentinformation**

- Version: 2.0
- Datum: 2026-09-24
- Status: Öppen – kräver omedelbar säkerhetsåtgärd
