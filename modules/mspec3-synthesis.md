---
name: mspec3-synthesis
stage_id: MSPEC3
input_dependencies:
  - 00-config.md
  - 00-input.md
  - spec-01-domain.md
  - spec-02-requirements.md
output_files:
  - spec-03-synthesis.md
scale_variants: [STANDARD]
kb_sources:
  - kb/techniques/structured-output.md
  - kb/synthesis/structured-output-decoding.md
  - kb/techniques/chain-of-thought.md
activation:
  mode: specification
  wave: 2
  role: specification-synthesis
return_contract: |
  "MSPEC3 Synthesis complete. Wrote: spec-03-synthesis.md."
---

# MSPEC3 — Specification Synthesis

Full context for specification synthesis only — no MSPEC12 reasoning inline, no verification pressure. Fresh eyes on the domain analysis + requirements to produce the formal specification document.

## Inputs

Read from `{session_dir}`:
- `00-config.md`
- `00-input.md` — original concept/problem
- `spec-01-domain.md` — domain analysis + decomposition from MSPEC12
- `spec-02-requirements.md` — extracted requirements from MSPEC12

## Protocol

Follow **Step S5** from SKILL.md `## Specification Mode Pipeline` verbatim. Produce a `<specification>` XML document containing:

1. `<meta source="epiphany-prompt"/>` as first child
2. `<domain>` — from spec-01
3. `<scope>` — what is in scope
4. `<out_of_scope>` — what is explicitly NOT in scope (from S5 rules)
5. `<concept_decomposition>` — structural parts with relationships
6. `<requirements>` — every R1, R2, ... from spec-02, classified MUST/SHOULD/MAY, with rationale
7. `<interfaces>` — boundary-facing parts
8. `<success_criteria>` — measurable outcomes
9. `<assumptions>` and `<constraints>` — explicit
10. `<open_questions>` — anything the input doesn't resolve

## Output

Write `spec-03-synthesis.md` containing the full `<specification>` XML. This is the draft that MSPEC4M5 will audit and verify.

Do NOT add a `<note>` block for failures — that is MSPEC4M5's responsibility.

## Return message

> MSPEC3 Synthesis complete. Wrote: spec-03-synthesis.md.
