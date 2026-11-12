# Work Summary - willibroadngebi-lab - 2026-09-15

## Present
Willi Broad Ngebi (`willibroadngebi-lab`)

## What I did today

### Headscale configuration
- Fixed `server_url` in `/etc/headscale/config.yaml` from raw IP
  to correct domain: `https://team2.itsx25.chas-lab.dev`
- Restarted Headscale service and verified health endpoint returned
  `{"status":"pass"}`

### Tailscale installation and connection
- Installed Tailscale v1.102.4 on team2-jumphost
- Connected jumphost to Headscale server
- Registered jumphost node under `team2` user (node ID 2)

### Subnet advertisement
- Configured jumphost to advertise team subnet:
  `sudo tailscale set --advertise-routes=10.0.2.0/24`
- Approved the route in Headscale:
  `sudo headscale nodes approve-routes --identifier 2 --routes 10.0.2.0/24`
- Verified route serving as primary in Headscale

### Connected WSL to Tailnet
- Ran `sudo tailscale up --login-server https://team2.itsx25.chas-lab.dev`
- Registered node under personal user `willibroad`
- Accepted subnet routes with `--accept-routes` flag
- Tailscale IP assigned: `100.64.0.5`
- Verified connectivity: `tailscale ping 100.64.0.2` — pong via DERP(hel)

### Firewall fixes (Section 6)
- Fixed `allow_headscale` source from `0.0.0.0/0` to `10.0.0.2/32`
  (only instructor proxy needs port 8080)
- Added `allow_instructor_ssh` rule: TCP:22 from `10.0.0.0/24`
- Validated with terraform fmt and terraform validate
- Pushed to branch — colleague had already merged same changes to main

### Primary instance (Section 7)
- Uncommented `google_compute_instance.primary` in `main.tf`
- Changed machine_type from `e2-small` to `e2-micro`
- Validated and pushed to branch

### OS Login
- Uploaded SSH public key to GCP OS Login profile:
  `gcloud compute os-login ssh-keys add --key-file=/home/sudeo/.ssh/id_ed25519.pub`
- Connected to jumphost using `gcloud compute ssh` with OS Login

## Tailnet status at end of day
All 6 team members connected:
- team2-jumphost (100.64.0.2) — Headscale server + Tailscale node
- willibroad/willice8 (100.64.0.5) — my WSL machine
- jonny-workstation (100.64.0.3)
- recharge/lars (100.64.0.4)
- fajk (100.64.0.7)
- macbook-air-tim (100.64.0.8)

## Security principle applied
- Principle of least privilege on firewall rules
- OS Login replaces static SSH keys for better traceability
- Subnet advertisement instead of installing Tailscale on every machine
