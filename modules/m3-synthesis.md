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

1. **Place preservation items first.** Read `01-inventory.md` as YAML (see SKILL.md § Schemas → Inventory schema). Iterate each category list (`inventory.urls`, `inventory.file_paths`, `inventory.tech_version`, etc.) and place every item into the appropriate output XML section. An item is "placed" when it appears verbatim in the draft. No enhancement work happens until every INVENTORY item has a home.

2. **Execute contracts in priority order.** Process `02-ideation.md` contracts by `priority: high → medium → low`. Within a priority level, process in listed order.

3. **Enhance around preservation items.** Add structure, constraints, context AROUND preserved content, never replacing it. Quote when in doubt.

4. **Apply techniques per contract.** Each contract says which T1–T13 technique (or "other:[description]") to apply, in which section. Apply it per the description in SKILL.md `## Techniques`.

5. **Contract conflict rule.** If a contract conflicts with an anti-pattern or directive in the input (e.g., contract says "add persona" but input says "no roles assigned"), SKIP the contract. Log the skipped contract in a header comment at the top of `03-synthesis.md` using this format:

```
<!-- Skipped contracts:
  - technique=T1 target_section=<role> reason="input contains 'do not assign roles'"
-->
```

6. **Output XML structure.** Root element `<prompt>`. First child `<meta source="epiphany-prompt"/>`. Subsequent children are semantic sections — choose the set that applies; prefer canonical order: `<role>` → `<context>` → `<task>` → `<constraints>` → `<output_format>` → `<verification>` → `<edge_cases>`. **Semantic separation rule (load-bearing):** persona/identity content from T4 contracts MUST go in `<role>` ("You are an expert X..."). Background situational facts (platform, domain, consumer context) MUST go in `<context>`. Never merge them — they are different elements serving different purposes. See SKILL.md `## Output Formats` for the full format spec.

7. **DEEP variant — iterative self-critique (after initial draft):**
   a. Draft the full output XML following steps 1–6.
   b. Self-critique internally (in your own context, no file write): for each INVENTORY item, confirm it appears verbatim in the draft. For each high-priority contract, confirm it was applied or documented as skipped.
   c. Targeted revision: fix any issues found in step b. Do not rewrite unaffected sections.
   d. Final — this becomes the content of `03-synthesis.md`.

## Output

**Initial invocation and STANDARD repair:** Write `03-synthesis.md`:
- First lines: optional `<!-- Skipped contracts: ... -->` comment if any contracts were skipped (step 5).
- Remainder: the full output XML (the enhanced prompt), ready for M4 verification.
- Do NOT include a verification section in this file — that is M4/M4M5's job.

**DEEP repair invocation — Edit-based surgical output:**
Use the Edit tool to make targeted changes rather than rewriting the whole file. This physically enforces "preserve passing sections verbatim."

1. Read `03-synthesis-failed.md` (the failed draft).
2. Write `03-synthesis.md` with the exact content of `03-synthesis-failed.md` (character-for-character copy — establish the baseline without changing it).
3. Read `04-verification.md`. For each check entry where `result: fail`, note the `repair_target` (XML tag name) and `detail` (specific failed item or description).
4. Re-Read `03-synthesis.md` to get current file content (required before using Edit — `old_string` must match the file exactly).
5. For each failing check: use Edit on `03-synthesis.md` to replace ONLY the `repair_target` XML element. `old_string` = the full element including its opening and closing tags (e.g., `<constraints>...</constraints>`); `new_string` = the corrected full element with the same tags.
6. Do NOT modify any XML element not listed as a failing `repair_target` in `04-verification.md`.
7. If a `repair_target` element cannot be uniquely identified for Edit (ambiguous match): log this in the Edit return message and include a note in the return message: `<!-- Edit ambiguous: {check_id} {repair_target} — manual review needed -->`. Leave that element unchanged rather than guessing.

## Return message

After writing `03-synthesis.md`, return:

> M3 Synthesis complete. Wrote: 03-synthesis.md.

No synthesis content in the return message. The orchestrator does not read stage files for routing.
