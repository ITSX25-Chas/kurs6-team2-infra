# Security KPIs — Team 2

*Three key indicators for tracking the security posture of the application platform, written for a
non-technical decision-maker. Each is defined, measurable, tied to a data source, and given a target.
Baseline figures come from the penetration test and the defence logs (environments A = 10.0.0.5, B = 10.0.0.55).*

---

## KPI 1 — Open critical vulnerabilities

**What it measures:** How many Critical- or High-severity security weaknesses are currently exploitable in
the platform. These are the issues that let an attacker take control or steal data.

**Why it matters (for decisions):** This is the single clearest measure of exposure. It tells leadership how
much real risk is live right now and drives what gets fixed first.

| | |
|---|---|
| **Definition** | Count of findings rated Critical or High that remain exploitable (not yet remediated) |
| **Data source** | Penetration-test report (findings F-01…F-07); re-test logs (environment B) |
| **Baseline (now)** | **4** exploitable: SQL-injection auth bypass, command injection, SSRF/metadata access, privilege escalation — all confirmed still exploitable in the B re-test (2 Nov) |
| **Target** | **0** within 30 days; no Critical older than 14 days |
| **Direction** | ↓ Lower is better |

**Follow-up:** Reviewed each sprint; every open Critical gets an owner and a due date.

**Decision it drives:** If this isn't trending to zero, leadership reprioritises engineering time toward
remediation (and reconsiders whether the platform is safe to expose) before building new features.

---

## KPI 2 — Sensitive information leaked through errors

**What it measures:** How often the system exposes internal technical details (database structure, software
versions, error traces) to an outside user. Every leak makes the next attack easier.

**Why it matters:** Information leakage is a quiet enabler — it costs nothing to fix but hands attackers a map.
Tracking it to zero is a concrete, verifiable hardening win.

| | |
|---|---|
| **Definition** | Number of responses that expose internal errors/schema to the client, per test window |
| **Data source** | Database log (`db.jsonl` — `ERROR: invalid input syntax` lines); HTTP responses |
| **Baseline (A, 16–30 Oct)** | **26** verbose database errors returned during the attack |
| **Re-test (B, 2 Nov)** | **0** such errors observed |
| **Target** | **0** — maintained; verified each release |
| **Direction** | ↓ Lower is better |

**Follow-up:** Confirm the 0 in B is due to a real fix (parameterised queries + generic error handling), not
just quieter payloads; lock it in with a regression test.

**Decision it drives:** A non-zero value flags that a release went out leaking internal detail — it triggers a
fix-and-regression-test before that release is considered done, rather than waiting for an incident.

---

## KPI 3 — Attack-detection coverage

**What it measures:** Of the distinct attacker techniques used against the platform, what share the defence
could **detect and alert on** — not merely record after the fact.

**Why it matters:** The logs showed the defence *recorded* the entire attack but *alerted on none of it*. This
KPI turns "we have logs" into "we can respond," which is the difference between visibility and security.

| | |
|---|---|
| **Definition** | % of observed attack techniques (8 kill-chain stages) covered by an active alert rule |
| **Data source** | Defence logs (`web/internal/db.jsonl`) vs. configured SIEM/Wazuh alert rules |
| **Baseline (now)** | **~0%** — all 8 stages were logged, but no alert rule acted on them in real time |
| **Target** | **≥ 75%** of stages alerting within one sprint; priority rules: `/admin/diag` shell metacharacters, metadata-IP egress, SQL-error bursts, 404-scan rate |
| **Direction** | ↑ Higher is better |

**Follow-up:** Each new alert rule is validated by replaying the A-environment logs and confirming it fires.

**Decision it drives:** A low score justifies investment in monitoring/alerting (SIEM rules, on-call) over
collecting yet more logs — it tells leadership the gap is response capability, not visibility.

---

### How these three work together
KPI 1 tracks **how exposed we are**, KPI 2 tracks **how much we leak**, KPI 3 tracks **whether we'd notice an
attack**. Together they give leadership a one-glance view of risk (1), hygiene (2) and readiness (3) — and
each is measurable from evidence we already hold.
