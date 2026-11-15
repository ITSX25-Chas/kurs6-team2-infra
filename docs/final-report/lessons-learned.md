# Lessons Learned & Professional Summary — Team 2

*Three key lessons from the project, followed by a professional summary of results, risks and
recommendations for a non-technical audience. Grounded in evidence from the penetration test and the
defence-log post-mortem.*

---

## Three lessons learned

### Lesson 1 — Logging is not the same as detection
**What happened.** The defence logs captured the *entire* attack: the reconnaissance scan (5139 requests),
the SQL-injection errors (26), all 77 distinct command-injection payloads in cleartext, the internal data
export, the cloud-metadata attempts and the privilege-escalation commands. Yet nothing was stopped or
flagged while it happened.

**Why it matters.** Full visibility gave a false sense of security. Recording an attack after the fact has
little value if no alert turns it into action. The real gap was **detection and response, not visibility.**

**Improvement & follow-up.** Add alert rules on the high-signal events (shell metacharacters on
`/admin/diag`, any egress to the cloud-metadata IP, bursts of database errors, high 404 rates). Validate
each rule by replaying the recorded attack logs. *(Tracked as KPI 3 — attack-detection coverage.)*

### Lesson 2 — Fix root causes, not symptoms
**What happened.** Seven findings looked like separate problems, but almost all traced to **one root cause**:
user input reaching the SQL layer and the OS shell without validation, plus a single mis-configured SUID
binary that turned a low-privileged foothold into root. The attack chained SQL injection → command
injection → SSRF → privilege escalation, each step enabled by the last.

**Why it matters.** Patching individual findings would have left the chain intact. Removing the root causes
(parameterised queries, eliminating the command path, stripping the SUID bit, blocking metadata egress)
collapses most of the chain at once.

**Improvement & follow-up.** Prioritise remediation by **root cause and chain position**, not by finding
count. The command-injection endpoint is the highest-leverage fix because it unlocks the later stages.
*(Tracked as KPI 1 — open critical vulnerabilities.)*

### Lesson 3 — Evidence beats recollection; document while you work
**What happened.** When the written test notes were compared against the defence logs, a discrepancy
surfaced: the notes described light reconnaissance, but the logs showed a full 5139-request wordlist scan.
Details reconstructed from memory did not match the record.

**Why it matters.** Findings are only credible if they are **reproducible and evidence-backed**. A report
that contradicts the logs loses trust. Capturing exact payloads, timestamps and responses *as the work
happens* is what makes a finding defensible.

**Improvement & follow-up.** Record evidence (request, response, timestamp, screenshot) at the moment of each
finding, in the standard per-finding format, and reconcile against logs before submission.

---

## Professional summary (for a non-technical audience)

**What we did.** We tested the security of the application platform by simulating a realistic attack, then
analysed the defence logs to see what the monitoring caught. The test was authorised, scoped and
non-destructive.

**What we found.** The platform could be fully compromised. Starting from the public login page and without
any valid password, an attacker could read other employees' private data (including salaries), run commands
on the server, reach internal-only services, and ultimately gain full (root) control of the host. Four of
these weaknesses remained exploitable in a re-test two weeks later. The monitoring recorded every step of
the attack but raised no alert.

**The risk, in business terms.** Sensitive personal data (a privacy/GDPR concern), full server takeover, and
a path toward the wider cloud environment — all reachable by an unauthenticated attacker, and all currently
undetected in real time. This is a high-severity exposure.

**What we recommend (prioritised).**
1. Fix the input-handling weaknesses that allow command execution and data theft (highest leverage).
2. Remove unnecessary elevated-privilege settings on the server.
3. Restrict the server's access to internal and cloud-management services.
4. Turn existing logs into **active alerts** so an attack is noticed as it happens, not after.
5. Re-test to confirm each fix closes the issue.

**How we will track progress.** Three KPIs — open critical vulnerabilities (target 0), information leaked
through errors (target 0), and attack-detection coverage (target ≥75%) — give leadership a one-glance view of
exposure, hygiene and readiness. *(See `kpi.md`.)*
