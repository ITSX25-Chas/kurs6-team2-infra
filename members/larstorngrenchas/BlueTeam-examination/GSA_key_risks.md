Att använda statiska **Google Service Account-nycklar** (de nedladdningsbara .json-filerna) innebär betydande säkerhetsrisker. Eftersom dessa nycklar är kryptografiskt fristående och långlivade (de är giltiga i upp till 10 år om de inte tas bort manuellt), fungerar de i praktiken som ett digitalt huvudlösenord till molnresurser.

**Hur kan nyckeln användas utanför vår pipeline?**

Om en angripare kommer över .json-filen krävs inga speciella behörigheter eller tillgång till vårt nätverk för att använda den. De kan använda den från vilken dator som helst i världen, helt oberoende av vår CI/CD-pipeline.

En angripare kan aktivera nyckeln genom att:

1. **Sätta en lokal miljövariabel** på sin egen maskin: export GOOGLE_APPLICATION_CREDENTIALS="stulen-nyckel.json".
2. **Logga in via Google Cloud CLI** (gcloud) med kommandot:

gcloud auth activate-service-account --key-file=stulen-nyckel.json

3. **Använda färdiga skript eller verktyg** (som automatiskt letar efter läckta nycklar på exempelvis GitHub) för att omedelbart börja scanna och tömma våra projekt.

**Vad kan en potentiell angripare använda den till?**

Vad angriparen kan göra beror helt på vilka IAM-roller (behörigheter) tjänstekontot har. Det absolut farligaste scenariot är om kontot har breda roller som Owner, Editor eller Storage Admin. De vanligaste och mest skadliga sätten en angripare kan utnyttja en stulen nyckel på:

**1. Kryptoutvinning (Cryptojacking)**

Detta är det absolut vanligaste scenariot för stulna moln-nycklar.

- **Metod:** Angriparen startar omedelbart upp de största och dyraste virtuella maskinerna (Compute Engine) eller Kubernetes-kluster (GKE) som våra kvoter tillåter, enbart för att bryta kryptovaluta.
- **Konsekvens:** Det kan kosta företaget tiotusentals eller hundratals tusen kronor på bara några timmar innan det upptäcks.

**2. Datastöld och Spionage (Data Exfiltration)**

Om nyckeln har läsrättigheter till databaser (Cloud SQL, BigQuery) eller storage bucket (Cloud Storage).

- **Metod:** Angriparen laddar ner kundregister, källkod, finansiell data eller personuppgifter (GDPR-känslig data).
- **Konsekvens:** Förlust av immateriella rättigheter, dryga böter för personuppgifts-incidenter och skadat förtroende.

**3. Ransomware och Sabotage**

- **Metod:** Angriparen raderar våra produktionsdatabaser, storage buckets och säkerhetskopior. De kan också kryptera data och kräva en lösensumma för att låsa upp filerna.
- **Konsekvens:** Totalt avbrott i verksamheten där det i värsta fall inte går att återställa systemen (om backuperna raderats).

**4. "Lateral Movement" och Persistence (Säkra bakdörrar)**

Erfarna angripare vill inte bli utslängda om vi upptäcker den stulna nyckeln och raderar den.

- **Metod:** De använder nyckelns behörighet för att skapa _nya_ tjänstekonton, generera _nya_ nycklar, eller bjuda in externa Gmail-adresser som administratörer i vårt GCP-projekt.
- **Konsekvens:** Även om vi hittar och tar bort den ursprungliga läckta nyckeln, har angriparen skapat permanenta bakdörrar in i systemen som är svåra att spåra.

**5. Supply Chain-attacker** 

Om nyckeln har behörighet att bygga eller publicera kod (t.ex. till Artifact Registry eller Cloud Build).

- **Metod:** De injicerar skadlig kod i vår mjukvara eller interna verktyg.
- **Konsekvens:** När kunder uppdaterar sin mjukvara blir även de infekterade, vilket sprider attacken vidare.
