---
name: m4m5-verify-output
stage_id: M4M5
input_dependencies:
  - 00-config.md
  - 00-input.md
  - 01-inventory.md
  - 03-synthesis.md
output_files:
  - 04-verification.md
scale_variants: [STANDARD, DEEP]
kb_sources:
  - kb/enhancement/self-refine.md
  - kb/synthesis/process-reward-models.md
  - kb/techniques/structured-output.md
activation:
  mode: normal
  wave: W3 (STANDARD) | W5 (DEEP)
  role: verify+output
return_contract: |
  PASS: "VERIFICATION: PASS\n\n<prompt>...</prompt>"
  FAIL: "VERIFICATION: FAIL — [summary]"
---

# M4M5 — Verify + Output (STANDARD W3 / DEEP W5)

Combined verification and output formatting. On PASS, the formatted output XML is returned as part of the Agent return message — the orchestrator parses the return message, NOT a stage file, for the output. The stage file written by this module is only the verification report.

The invocation file varies by context — the orchestrator's Agent prompt explicitly names which file to read:
- **STANDARD W3:** input = `03-synthesis.md`; output path in return XML is a `<prompt>` root
- **DEEP W5:** input = `05-expansion.md`; output path is the same `<prompt>` root

For DEEP W5, also update `input_dependencies` handling: the actual file read is `05-expansion.md` as directed by the orchestrator (the frontmatter shows the STANDARD path as the primary declaration; the orchestrator dispatches the correct input per the dependency table).

## Inputs

Read from `{session_dir}`:
- `00-config.md` — confirm mode = normal; note scale
- `00-input.md` — original input
- `01-inventory.md` — preservation checklist
- **Either** `03-synthesis.md` **or** `05-expansion.md` — whichever the orchestrator's Agent prompt names.

## Phase 1 — Verification

Run all 12 checks (6a–6l) from SKILL.md `## Verification Checks` → Normal mode. For each check, produce an entry in the standard report schema (see SKILL.md `## Schemas`).

Write `04-verification.md` with check results + summary (the `04-verification.md` file name is used for STANDARD W3; for DEEP W5 the orchestrator expects this module to write to `06-verification-2.md` — the orchestrator's Agent prompt specifies the exact output file name. Write to whatever filename the orchestrator directs.)

Compute `overall`:
- `overall = pass` iff every check result is `pass` or `pass-with-note`.
- Any `fail` → `overall = fail`.

## Phase 2 — Output Formatting (only if overall = pass)

On FAIL: skip Phase 2. Return `VERIFICATION: FAIL — [one-sentence summary]`. Do not produce output XML.

On PASS: format the output XML.
- Root element: `<prompt>`
- First child: `<meta source="epiphany-prompt"/>`
- Subsequent children: semantic sections from the draft
- See SKILL.md `## Output Formats` for the full format spec

Do NOT write the output XML to a stage file. Instead include it in the Agent return message (see below).

## Return message

**PASS path:**

```
VERIFICATION: PASS

<prompt>
  <meta source="epiphany-prompt"/>
  ...
</prompt>
```

Exact format: `VERIFICATION: PASS` on line 1, blank line, then the full output XML. The orchestrator parses this by splitting on the first blank line.

**FAIL path:**

```
VERIFICATION: FAIL — [one-sentence summary, e.g., "Missing INVENTORY items: 2 URLs, 1 code block"]
```

The orchestrator uses this to trigger the repair loop (see SKILL.md `### STEP 6 — REPAIR LOOPS`). Do not include the verification report in the return message — it lives in the stage file.
