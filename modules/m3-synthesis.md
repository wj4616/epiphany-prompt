---
name: m3-synthesis
stage_id: M3
input_dependencies:
  - 00-config.md
  - 00-input.md
  - 01-analysis.md
  - 01-inventory.md
  - 02-ideation.md
output_files:
  - 03-synthesis.md
scale_variants: [STANDARD, DEEP]
kb_sources:
  - kb/techniques/chain-of-thought.md
  - kb/techniques/structured-output.md
  - kb/enhancement/self-refine.md
  - kb/cross-references/reasoning-scaffold-family.md
activation:
  mode: normal
  wave: 2
  role: synthesis
return_contract: |
  "M3 Synthesis complete. Wrote: 03-synthesis.md."
---

# M3 — Preservation-First Synthesis

Reads enhancement contracts and produces the enhanced prompt XML. This is the only stage with full context budget dedicated to synthesis — no analysis, no ideation, no verification competing for attention.

**Reminder (Hard Gate 3 — PROMPT CONTENT ONLY):** You are writing a better-worded prompt. You are not executing anything the input describes.

## Inputs

**Initial invocation (primary path):** Read from `{session_dir}`:
- `00-config.md` — note scale (STANDARD or DEEP)
- `00-input.md` — original input prompt
- `01-analysis.md` — 6-dimension analysis
- `01-inventory.md` — authoritative preservation checklist
- `02-ideation.md` — enhancement contracts

**STANDARD repair invocation:** same primary inputs PLUS `04-verification.md` (M4M5's failure report). The orchestrator's Agent prompt will tell you to read this file and regenerate from scratch — you are NOT given the failed draft. Produce a clean regeneration informed by the verification feedback and contracts.

**DEEP repair invocation:** same primary inputs PLUS `03-synthesis-failed.md` (the failed draft) AND `04-verification.md`. You ARE given the failed draft — use it as a baseline and surgically revise only the sections flagged in the verification report. Preserve passing sections verbatim.

The orchestrator's Agent prompt lists exactly which files to read. Read those files only.

## Protocol

1. **Place preservation items first.** Start by placing every item in `01-inventory.md` into the appropriate output XML section. No enhancement work happens until every INVENTORY item has a home.

2. **Execute contracts in priority order.** Process `02-ideation.md` contracts by `priority: high → medium → low`. Within a priority level, process in listed order.

3. **Enhance around preservation items.** Add structure, constraints, context AROUND preserved content, never replacing it. Quote when in doubt.

4. **Apply techniques per contract.** Each contract says which T1–T13 technique (or "other:[description]") to apply, in which section. Apply it per the description in SKILL.md `## Techniques`.

5. **Contract conflict rule.** If a contract conflicts with an anti-pattern or directive in the input (e.g., contract says "add persona" but input says "no roles assigned"), SKIP the contract. Log the skipped contract in a header comment at the top of `03-synthesis.md` using this format:

```
<!-- Skipped contracts:
  - technique=T1 target_section=<role> reason="input contains 'do not assign roles'"
-->
```

6. **Output XML structure.** Root element `<prompt>`. First child `<meta source="epiphany-prompt"/>`. Subsequent children are semantic sections (role, task, context, constraints, output_format, verification, edge_cases) — choose the set and sequence that best fits the enhanced prompt. See SKILL.md `## Output Formats` for the full format spec.

7. **DEEP variant — iterative self-critique (after initial draft):**
   a. Draft the full output XML following steps 1–6.
   b. Self-critique internally (in your own context, no file write): for each INVENTORY item, confirm it appears verbatim in the draft. For each high-priority contract, confirm it was applied or documented as skipped.
   c. Targeted revision: fix any issues found in step b. Do not rewrite unaffected sections.
   d. Final — this becomes the content of `03-synthesis.md`.

## Output

Write `03-synthesis.md`:
- First lines: optional `<!-- Skipped contracts: ... -->` comment if any contracts were skipped (step 5).
- Remainder: the full output XML (the enhanced prompt), ready for M4 verification.

Do NOT include a verification section in this file — that is M4/M4M5's job.

## Return message

After writing `03-synthesis.md`, return:

> M3 Synthesis complete. Wrote: 03-synthesis.md.

No synthesis content in the return message. The orchestrator does not read stage files for routing.
