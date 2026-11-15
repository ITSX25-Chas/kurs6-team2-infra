# Individual Final Report — Willibroad Ngebi

**ITSX25 Course 6 · Advanced IT Security · Comerit AB · Team 2**
**GitHub:** `willibroadngebi-lab` · **Branch:** `member/willibroadngebi-lab`
**Repos:** [infra](https://github.com/ITSX25-Chas/kurs6-team2-infra) · [application](https://github.com/ITSX25-Chas/team2-company-website)

---

## 1. Introduction

This report ties together my work across the project: the cloud environment the team built and defended
(Blue Team, weeks 4–7), the penetration test against the target platform (Red Team), and the post-mortem and
follow-up measurements. It follows five questions — what we did, the result, how it can be followed up, what
we learned, and what should happen next.

## 2. My contribution

My work concentrated on **network and identity security of the team's cloud infrastructure** — the layer my
networking/systems-engineering background is strongest in — plus a defined role in the Red Team capstone and
the post-mortem analysis. All items below are evidenced in Git history on my branch `member/willibroadngebi-lab`.

**Network protection — firewall hardening (my flagship contribution).**
I identified a critical misconfiguration in `main.tf`: the firewall rule `allow_traffic` permitted **all
protocols from `0.0.0.0/0`** (the whole internet) to both the jumphost and the primary machine — every port on
every machine reachable from anywhere. I replaced it (PB-05 / Issue #8, PR #29) with two least-privilege rules:
- `allow_ssh` — TCP 22 from the internet to the **jumphost only**;
- `allow_internal` — all protocols restricted to the team subnet `10.0.2.0/24`.
Reviewed by two teammates, merged, and deployed to GCP via the Terraform pipeline. I later tightened
`allow_headscale` from `0.0.0.0/0` to the instructor proxy (`10.0.0.2/32`) and added a scoped instructor-SSH
rule. *(Commits `6b3dc15`, and the Section-6 fixes; cited as PB-05 in the team security report.)*

**Secure network access — mesh VPN.**
I installed and configured **Headscale v0.29.3** (the Tailnet control server) and **Tailscale v1.102.4** on
`team2-jumphost`, advertised the team subnet (`10.0.2.0/24`) rather than installing a client on every machine,
approved the route, and brought all six team members onto the Tailnet. *(Work summaries 2026-09-14 / 09-15.)*

**Identity — OS Login.**
I moved administrative access from static SSH keys to **GCP OS Login** (uploading my key to the OS Login
profile and connecting via `gcloud compute ssh`), improving traceability and key management. *(Commit `8eb88bb`.)*

**Infrastructure — primary instance provisioning.**
I brought up `team2-primary` in Terraform (Section 7 — enabling the instance and setting the machine type),
part of standing up the environment during its creation. *(Commits `b8c4241`, `c37664e`.)*

**DevSecOps — code review.**
I reviewed, approved and validated team pull requests, and my own changes went through reviewed PRs
(#29, #40, #46, #59) before merge — practising the team's pull-request gate.

**Validation — CTF exercise.**
I took part in the flag exercise (team captured 2/2), which validated our findings in practice — the publicly
readable Terraform state bucket (PB-02) was a real exploitable weakness, reinforcing why the hardening mattered.

**Red Team capstone.**
In the offensive phase I presented the environment-variable disclosure (`; env`, revealing the internal
service) and the Perl `IO::Socket` server-side request technique used to reach `internal:8000/export`
(presentation slides 3–4), and set up the SSH SOCKS tunnel / jumphost access used to reach the target.

**Post-mortem & KPIs.**
I analysed the defence-side logs across both target environments to build the detection table and the three
security KPIs (see `post-mortem.md`, `kpi.md`).

## 3. Key results and evidence

- **Reduced the external attack surface from "every port, every machine, whole internet" to SSH-on-jumphost
  only** — a concrete, deployed least-privilege fix (PB-05). *(Infra repo, PR #29.)*
- **Stood up secure team connectivity** (Headscale/Tailscale mesh, subnet-advertised) and identity-based
  access (OS Login) — the network-protection layer of the team's defence.
- **The platform could be fully compromised** in the Red Team phase, from an unauthenticated start to root.
  *(Red Team report.)*
- **The defence had full visibility but zero real-time detection** — every attack step logged, none alerted.
  *(Post-mortem.)*

## 4. Conclusions

Two lessons stand out. First, on the defensive side: **least privilege at the network edge is cheap and
high-impact** — one firewall rule change removed an enormous exposure. Second, from the offensive and
post-mortem work: **logging is not detection.** The target recorded the entire attack and acted on none of it,
which is the gap most organisations actually have. Security value comes from turning visibility into timely
response, and from fixing root causes rather than symptoms.

## 5. Recommendations

1. Keep network rules least-privilege and review them whenever the environment changes.
2. On the application side, remove the command-injection path and parameterise all SQL (the highest-leverage
   fixes — they collapse most of the attack chain).
3. Enforce authentication/authorisation on every data route; strip unnecessary SUID bits; restrict egress to
   internal services and the cloud-metadata endpoint.
4. Convert logs into active alerts (shell metacharacters on `/admin/diag`, metadata-IP egress, SQL-error
   bursts) and re-test after each fix. *(Tracked by the three KPIs.)*

## 6. What I take forward to LIA and the professional role

- **Technically:** I deepened from pure networking into cloud and application security — Terraform/IaC, GCP
  firewall and identity (OS Login, IAP), mesh VPN, and the full web→host→cloud attack chain. My networking
  foundation turned out to be a real advantage: security is built on sound network fundamentals.
- **The mindset I value most:** root-cause thinking, least privilege, and the distinction between *logging* and
  *detection* — I want to carry these into resilience and monitoring work.
- **Methodologically:** evidence-based, reproducible documentation; working to a pull-request and review gate;
  and mapping findings to MITRE ATT&CK.
- **Professionally:** translating a technical result for both engineers and non-technical decision-makers
  (the KPI work), and operating within an authorised scope and ethical frame. These are the consulting-side
  skills I want to grow in during LIA.

## 7. AI-usage account (Mål 11)

**Where AI was used.** I used an AI assistant (Claude) in the documentation and analysis phases: to explain
techniques and commands so I understood *why* each step worked; to structure and draft reports, the
post-mortem and the KPIs; and to analyse the defence logs — parsing ~6,000 JSON log lines, classifying attack
steps, converting UTC to local time, and comparing the two environments — far faster than by hand.

**Where I judged AI appropriate.** For accelerating comprehension, structuring documents for different
audiences, and large-scale log analysis whose output I could **check against the raw data**.

**Where I judged AI inappropriate.** The offensive actions were performed by the team under our signed Rules
of Engagement, not delegated to an AI. Accountability for an intrusion cannot be outsourced to a tool, and
authorisation must be explicit.

**How I verified AI output.** I treated AI text as a draft, not a source of truth. The clearest example: an
AI-drafted report described light reconnaissance, but when I checked the defence logs the record showed a
~5,000-request scan — I corrected it from evidence. AI can produce plausible but wrong detail, so
cross-checking every factual claim against logs, commits or primary sources is the mitigation.

**Conclusion.** AI was a strong accelerator for understanding, documentation and analysis, but not a
substitute for judgement, authorisation or verification. Used with evidence-based checking and clear ethical
boundaries, it improved both the speed and quality of the work.
