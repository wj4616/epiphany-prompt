---
name: mspec4m5-verify-output
stage_id: MSPEC4M5
input_dependencies:
  - 00-config.md
  - 00-input.md
  - spec-01-domain.md
  - spec-02-requirements.md
  - spec-03-synthesis.md
output_files:
  - spec-04-verify.md
scale_variants: [STANDARD]
kb_sources:
  - kb/enhancement/self-refine.md
  - kb/synthesis/process-reward-models.md
  - kb/techniques/structured-output.md
activation:
  mode: specification
  wave: 3
  role: verify+output
return_contract: |
  PASS: "VERIFICATION: PASS\n\n<specification>...</specification>"
  PASS-WITH-NOTES: "VERIFICATION: PASS-WITH-NOTES — [summary]\n\n<specification>...</specification>"
  (Spec mode never returns FAIL.)
---

# MSPEC4M5 — Spec Completeness Audit + Verify + Output

Combined completeness audit (S6), 11-check verification (S7), and output formatting. Spec mode has no repair loop — this module always delivers an output. If checks fail, it embeds a `<note>` block inside the `<specification>` XML describing the gaps and returns `PASS-WITH-NOTES`.

## Inputs

Read from `{session_dir}`:
- `00-config.md`
- `00-input.md`
- `spec-01-domain.md`
- `spec-02-requirements.md`
- `spec-03-synthesis.md` — the draft specification

## Phase 1 — Completeness Audit (S6)

Follow **Step S6** from SKILL.md `## Specification Mode Pipeline`. Audit `spec-03-synthesis.md` for gaps: any requirement from spec-02 that isn't reflected, any domain concept that isn't scoped, any open question not surfaced. Produce an audit list.

## Phase 2 — Verification (S7a–S7k)

Run all 11 checks (S7a–S7k) from SKILL.md `## Verification Checks` → Specification mode. For each, produce a standard report entry (see SKILL.md `## Schemas`).

Compute `overall`:
- `overall = pass` iff every check is `pass` or `pass-with-note`.
- Any `fail` → `overall = pass-with-notes` (spec mode never returns FAIL outright — it always delivers).

Write `spec-04-verify.md` with audit list + check results + summary.

## Phase 3 — Output Formatting

Always format output. On any failures, add a `<note>` block as the LAST child of `<specification>` summarizing the failed checks and audit gaps.

- Root: `<specification>`
- First child: `<meta source="epiphany-prompt"/>`
- Last child (only if PASS-WITH-NOTES): `<note>` summarizing gaps

## Return message

**PASS path:**

```
VERIFICATION: PASS

<specification>
  <meta source="epiphany-prompt"/>
  ...
</specification>
```

**PASS-WITH-NOTES path:**

```
VERIFICATION: PASS-WITH-NOTES — [one-sentence summary, e.g., "3 requirements missing rationale, 1 open question unresolved"]

<specification>
  <meta source="epiphany-prompt"/>
  ...
  <note>Verification notes: ...</note>
</specification>
```

Never return `FAIL` — spec mode always delivers.
