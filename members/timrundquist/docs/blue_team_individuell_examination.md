## Tim Rundquist: individuellt examinationsunderlag

### Mina bidrag

Under Blue Team-fasen arbetade jag tillsammans med gruppen med att etablera, säkra och verifiera vår miljö. Nedan är exempel som kan följas i Git-historiken.

| Område | Spårbart bidrag | Förklaring |
|--------|----------------|------------|
| Bootstrap och grundläggande uppsättning | Körde bootstrap-modulen lokalt, fixade syntaxfel i main.tf, importerade befintlig service account. | Hur Terraform hanterar state och varför terraform import behövs när resurser skapats utanför Terraforms kontroll. |
| Least privilege på CI/CD (issue #7) | Ersatte roles/editor med roles/compute.networkAdmin + roles/compute.instanceAdmin.v1 i bootstrap/main.tf. | Varför en bred roll som roles/editor ger onödigt stor attackyta och hur vi identifierade vilka roller som faktiskt behövdes. |
| Bucket-specifik state-åtkomst | Lade till roles/storage.objectAdmin scopat till enbart state-bucketen efter att borttagningen av roles/editor bröt pipelinen. | Skillnaden mellan projektbred och resursspecifik IAM-bindning. |
| Brandväggsanalys (issue #8) | Analyserade befintlig brandväggsregel och föreslog uppdelning i SSH-only för jumphost plus intern trafik för teamets subnät. | Varför en öppen brandväggsregel mot hela internet är en kritisk risk. |
| SSH och OS Login | Registrerade publik SSH-nyckel i GCP OS Login, verifierade SSH-åtkomst till jumphosten. | Hur OS Login kopplar SSH-åtkomst till GCP IAM-identitet istället för statiska nycklar. |
| Tailscale-anslutning | Installerade Tailscale-klient lokalt, anslöt till teamets Headscale-server, aktiverade accept-routes för subnet-routing. | Hur ZTNA via Tailscale/Headscale ersätter öppna brandväggsregler som åtkomstmetod. |

Flytten till Comerit (nytt GCP-projekt itsx25-comerit, IAP-tunneling) ingår i Blue Team-fasens slutliga läge men bör inte förväxlas med den ursprungliga miljön under vecka 4–7.
