# K3s-plattform i Comerits miljö

## Syfte

Detta dokument beskriver första steget för att återställa Team 2:s
applikationsplattform i GCP-projektet `itsx25-comerit`. Målet är en
reproducerbar K3s-server på `team2-primary`; applikationsdeploy, Kubernetes
RBAC och CI/CD-kubeconfig hanteras i efterföljande, separata ändringar.

## Vad Terraform konfigurerar

- `team2-primary` får ett idempotent startup-script som installerar den
  pinnade versionen `v1.37.0+k3s1` av K3s om den saknas.
- K3s konfigureras som en singelnods-server med ett unikt nodnamn och
  root-skyddad administrativ kubeconfig (`0600`).
- Den inbyggda Traefik- och ServiceLB-installationen stängs av. Teamets
  applikationsmanifest använder `ingressClassName: nginx`, så en NGINX
  ingress-controller installeras och dokumenteras separat innan appen
  driftsätts.
- Startup-scriptet väntar på K3s readiness endpoint och skriver bara
  tekniska statusrader till `/var/log/team2-primary-startup.log`.
- Startup-scriptet körs när primary startar. Deploy-workflowet har därför ett
  manuellt valt alternativ, `reset_primary_for_bootstrap`, som efter Terraform
  apply säkerställer att `team2-jumphost` kör, och startar sedan om endast
  `team2-primary`. Primary använder jumphosten som NAT-gateway för att hämta
  K3s. Alternativet är avstängt som standard och körs aldrig vid en vanlig
  push. Det raderar inte VM:erna eller ändrar Terraform-staten, men gör att
  den redan tilldelade bootstrapen körs med nätåtkomst.
- Brandväggen tillåter K3s API från Team 2:s privata subnät och Googles
  IAP-intervall. IAP kräver dessutom en separat IAM-kontroll; regeln gör inte
  API:t publikt.

## Vad ändringen inte gör

- Den skapar inte en kubeconfig eller Kubernetes-secret i GitHub.
- Den ger inte `team2-las` eller app-repot skrivbehörighet.
- Den installerar inte NGINX Ingress, Sigstore policy-controller eller
  applikationen.
- Den ändrar inte gamla Headscale- eller Tailscale-secrets.

## Verifiering efter merge

1. Infra-deployen ska vara grön.
2. Via OS Login och IAP kontrolleras `sudo systemctl is-active k3s`.
3. `sudo k3s kubectl get nodes` ska visa `team2-primary` som `Ready`.
4. K3s API, kubeconfig, RBAC och nästa CI/CD-steg granskas i en ny PR innan
   applikationens workflow ändras.

## Källor

- [K3s Quick-Start Guide](https://docs.k3s.io/quick-start): installationsskript,
  systemd-tjänst och standardplats för kubeconfig.
- [K3s Configuration Options](https://docs.k3s.io/installation/configuration):
  konfigurationsfil i `/etc/rancher/k3s/config.yaml` och persistenta
  serverinställningar.
