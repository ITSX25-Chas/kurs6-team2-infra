Tim Rundquist: individuellt examinationsunderlag
Projektlänkar
Team 2: infrastruktur
Teamets säkerhetsrapport (länka in)
Mina bidrag

Under Blue Team-fasen arbetade jag tillsammans med gruppen med att etablera, säkra och verifiera vår miljö. Nedan är exempel som kan följas i Git-historiken.

Område	Spårbart bidrag	Förklaring
Bootstrap och grundläggande uppsättning	Körde bootstrap-modulen lokalt, fixade syntaxfel i main.tf (saknad closing brace), importerade befintlig service account som redan existerade i GCP.	Hur Terraform hanterar state och varför terraform import behövs när resurser skapats utanför Terraforms kontroll.
Least privilege på CI/CD (issue #7)	Ersatte roles/editor med roles/compute.networkAdmin + roles/compute.instanceAdmin.v1 i bootstrap/main.tf.	Varför en bred roll som roles/editor ger onödigt stor attackyta och hur vi identifierade vilka roller som faktiskt behövdes genom att granska vilka resurstyper team-modulen skapar.
Bucket-specifik state-åtkomst	Lade till roles/storage.objectAdmin scopat till enbart state-bucketen (team2-tfstate-dd541fba) efter att borttagningen av roles/editor bröt Terraform state-åtkomsten i pipelinen.	Skillnaden mellan projektbred och resursspecifik IAM-bindning, och varför bucket-specifik behörighet är att föredra framför att återinföra en bred roll.
Brandväggsanalys (issue #8)	Analyserade befintlig brandväggsregel (protocol=all, source_ranges=0.0.0.0/0) och föreslog uppdelning i SSH-only för jumphost + intern trafik för teamets subnät.	Varför en öppen brandväggsregel mot hela internet är en kritisk risk och hur man begränsar till nödvändiga portar och källadresser.
SSH och OS Login	Registrerade publik SSH-nyckel i GCP OS Login, verifierade SSH-åtkomst till jumphosten via gcloud compute ssh.	Hur OS Login kopplar SSH-åtkomst till GCP IAM-identitet istället för statiska nycklar i metadata, och fördelarna med centraliserad rättighetshantering.
Tailscale-anslutning	Installerade och konfigurerade Tailscale-klient lokalt, anslöt till teamets Headscale-server, aktiverade accept-routes för subnet-routing.	Hur Zero Trust Network Access (ZTNA) via Tailscale/Headscale ersätter öppna brandväggsregler och SOCKS5-proxytunnlar som åtkomstmetod.

Flytten till Comerit (nytt GCP-projekt itsx25-comerit, IAP-tunneling) ingår i Blue Team-fasens slutliga läge men bör inte förväxlas med den ursprungliga miljön under vecka 4–7.
