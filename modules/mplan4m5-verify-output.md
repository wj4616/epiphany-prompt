---
name: mplan4m5-verify-output
stage_id: MPLAN4M5
input_dependencies:
  - 00-config.md
  - 00-input.md
  - plan-01-analysis.md
  - plan-02-design.md
  - plan-03-synthesis.md
output_files:
  - plan-04-verify.md
scale_variants: [STANDARD]
kb_sources:
  - kb/enhancement/self-refine.md
  - kb/synthesis/process-reward-models.md
  - kb/techniques/react-framework.md
activation:
  mode: plan
  wave: 3
  role: verify+output
return_contract: |
  PASS: "VERIFICATION: PASS\n\n<plan>...</plan>"
  PASS-WITH-NOTES: "VERIFICATION: PASS-WITH-NOTES — [summary]\n\n<plan>...</plan>"
  (Plan mode never returns FAIL.)
---

# MPLAN4M5 — Plan Gap Audit + Verify + Output

Combined gap audit (P8), 9-check verification (P9), and output formatting. Plan mode has no repair loop — always delivers output with a `<note>` block on failed checks.

## Inputs

Read from `{session_dir}`:
- `00-config.md`
- `00-input.md`
- `plan-01-analysis.md`
- `plan-02-design.md`
- `plan-03-synthesis.md`

## Phase 1 — Gap Audit (P8)

Follow **Step P8** from SKILL.md `## Plan Mode Pipeline`. Audit the synthesized plan for missing steps, missing dependencies, under-specified safeguards. Produce an audit list.

## Phase 2 — Verification (P9a–P9i)

Run all 9 checks (P9a–P9i) from SKILL.md `## Verification Checks` → Plan mode. Produce standard report entries.

Compute `overall`:
- `overall = pass` iff every check is `pass` or `pass-with-note`.
- Any `fail` → `overall = pass-with-notes`.

Write `plan-04-verify.md` with audit + check results + summary.

## Phase 3 — Output Formatting

Format `<plan>` XML. On gaps or failed checks, append a `<note>` block as last child.

## Return message

**PASS:**

```
VERIFICATION: PASS

<plan>
  <meta source="epiphany-prompt"/>
  ...
</plan>
```

**PASS-WITH-NOTES:**

```
VERIFICATION: PASS-WITH-NOTES — [summary]

<plan>
  <meta source="epiphany-prompt"/>
  ...
  <note>Verification notes: ...</note>
</plan>
```

Never FAIL.
