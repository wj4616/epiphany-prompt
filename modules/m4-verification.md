---
name: m4-verification
stage_id: M4
input_dependencies:
  - 00-config.md
  - 00-input.md
  - 01-inventory.md
  - 03-synthesis.md
output_files:
  - 04-verification.md
scale_variants: [DEEP]
kb_sources:
  - kb/enhancement/self-refine.md
  - kb/synthesis/process-reward-models.md
  - kb/theory/alignment-prompting.md
activation:
  mode: normal
  wave: 3
  role: verification
return_contract: |
  PASS: "VERIFICATION: PASS"
  FAIL: "VERIFICATION: FAIL — [summary]"
---

# M4 — 12-Check Verification (DEEP W3 standalone)

Fresh-eyes verification of the synthesis draft. You have never seen the analysis reasoning, the ideation contracts, or the synthesis process — only the INVENTORY (authoritative preservation checklist), the original input, and the draft.

This module is used ONLY in DEEP mode, Wave 3, as a standalone check before M5 Expansion runs. STANDARD mode uses `m4m5-verify-output.md` instead (combined verify+output).

## Inputs

Read from `{session_dir}`:
- `00-config.md` — confirm scale = DEEP, mode = normal
- `00-input.md` — original input
- `01-inventory.md` — authoritative preservation checklist
- `03-synthesis.md` — the draft to verify

## Protocol

Run all 12 checks (6a–6l) against `03-synthesis.md`. Check definitions are in SKILL.md `## Verification Checks` → Normal mode — 12 checks (6a–6l). Use those definitions verbatim.

For each check, produce a report entry:

```yaml
- check: 6a
  result: pass | fail | pass-with-note
  detail: "[specific failed item, verbatim]"
  repair_target: "[section or XML tag to fix]"
```

**Loop termination rule (from SKILL.md):** do not loop within this module. This is a single pass. Orchestrator handles the repair loop via respawn.

## Output

Write `04-verification.md`:

```markdown
# Verification Report — DEEP W3

## Check Results

[one YAML block per check, 6a–6l]

## Summary

preservation_counts:
  urls: {count of URLs confirmed preserved}
  paths: {count}
  tech_version: {count}
  version_specs: {count}
  code_blocks: {count}
  api_refs: {count}
  named_entities: {count}
  numeric_specs: {count}
  embedded_directives: {count}
  quoted_strings: {count}
  technical_specs: {count}
  phase_step_structure: {count}
  tier_classification: {count}
  conditional_logic: {count}
  iteration_rules: {count}
  verification_criteria: {count}
  edge_case_definitions: {count}
  defaults_fallbacks: {count}
  other: {count}
overall: pass | fail | pass-with-notes
```

`overall = pass` iff every check result is `pass` or `pass-with-note`. Any `fail` → `overall = fail`.

## Return message

After writing `04-verification.md`, return ONE of:

- If `overall = pass` or `pass-with-notes`: `VERIFICATION: PASS`
- If `overall = fail`: `VERIFICATION: FAIL — [one-sentence summary, e.g., "Missing INVENTORY items: 2 URLs, 1 code block"]`

Do not include the report content in the return message — the orchestrator reads return message only. The stage file is for introspection and for the DEEP repair input to M3.
