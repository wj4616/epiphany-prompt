---
name: m5-expansion
stage_id: M5
input_dependencies:
  - 00-config.md
  - 00-input.md
  - 01-inventory.md
  - 03-synthesis.md
output_files:
  - 05-expansion.md
scale_variants: [DEEP]
kb_sources:
  - kb/techniques/tree-of-thoughts.md
  - kb/techniques/forest-of-thought.md
  - kb/ideation/creative-dc.md
  - kb/ideation/transformational-creativity.md
activation:
  mode: normal
  wave: 4
  role: expansion
return_contract: |
  "M5 Expansion complete. Wrote: 05-expansion.md."
---

# M5 — Gap Scan + Expansion (DEEP W4)

Fresh eyes on verified synthesis. You have never seen the analysis, ideation, or synthesis process — only the INVENTORY, the original input, and the verified draft. Your job: find thin areas that deserve more depth and expand them WITHOUT removing anything that passed verification.

## Inputs

**Initial invocation (W4 primary path):** Read from `{session_dir}`:
- `00-config.md` — confirm scale = DEEP
- `00-input.md` — original input
- `01-inventory.md` — preservation checklist
- `03-synthesis.md` — verified synthesis (passed M4)

**W5 repair invocation:** same primary inputs PLUS `05-expansion-failed.md` AND `06-verification-2.md` — surgical fix of the failed expansion using verification report feedback. Preserve passing sections verbatim.

The orchestrator's Agent prompt tells you which files to read.

## Protocol

### Phase 1 — Gap Scan (internal)

Scan the verified synthesis for "thin" areas — places where the output is terse, mechanical, or missing depth that the input implies was needed. Candidate thin areas:
- Constraints that could be more specific
- Edge cases that list only one or two scenarios
- Output format sections that show a single example but imply variations
- Verification blocks that are rote rather than tailored
- Role/context sections that don't fully leverage INTENT from the input

**No-op path:** if nothing is thin — the draft is already comprehensive — write `05-expansion.md` as a pass-through of `03-synthesis.md` with a header note:

```markdown
<!-- Expansion: no thin areas found. Pass-through of 03-synthesis.md. -->
```

Then return the standard completion message. M4M5 W5 will still run against this file.

### Phase 2 — Expansion Synthesis (if thin areas found)

For each thin area:
1. **Do not reduce.** Expansion means adding depth, not replacing content. Every sentence in `03-synthesis.md` must appear in `05-expansion.md` (either unchanged or as part of an expanded block).
2. **Respect INVENTORY.** Do not add enhancements that conflict with the input. Preserve every INVENTORY item.
3. **Expand with evidence.** Each expansion should be traceable to something in the input — expanded edge cases from hinted-at situations, expanded constraints from underspecified requirements, etc.
4. **Add anti-conformity depth** in at least one area — the unconventional extension that makes the enhanced prompt distinctive.

## Output

Write `05-expansion.md` containing the full expanded output XML (same root and structure as `03-synthesis.md`).

## Return message

After writing `05-expansion.md`, return:

> M5 Expansion complete. Wrote: 05-expansion.md.

No expansion content in the return message.
