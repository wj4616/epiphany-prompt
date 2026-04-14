---
name: mplan3-synthesis
stage_id: MPLAN3
input_dependencies:
  - 00-config.md
  - 00-input.md
  - plan-01-analysis.md
  - plan-02-design.md
output_files:
  - plan-03-synthesis.md
scale_variants: [STANDARD]
kb_sources:
  - kb/techniques/rewoo.md
  - kb/techniques/codeact.md
  - kb/techniques/chain-of-thought.md
  - kb/synthesis/cot-synthesis.md
activation:
  mode: plan
  wave: 2
  role: plan-synthesis+simulation
return_contract: |
  "MPLAN3 Synthesis complete. Wrote: plan-03-synthesis.md."
---

# MPLAN3 — Plan Synthesis + Execution Simulation

Full context for plan synthesis only — no MPLAN12 reasoning inline competing. Internal two-pass: first synthesize, then mentally walk through execution to find gaps. Fix gaps in place.

## Inputs

Read from `{session_dir}`:
- `00-config.md`
- `00-input.md`
- `plan-01-analysis.md`
- `plan-02-design.md`

## Protocol

### Phase 1 — Plan Synthesis (P6)

Follow **Step P6** from SKILL.md `## Plan Mode Pipeline`. Produce a `<plan>` XML document:

1. `<meta source="epiphany-prompt"/>` as first child
2. `<goal>` — from P2
3. `<steps>` — numbered, each with description, acceptance criterion, preconditions, dependencies
4. `<dependencies>` — from P4, in graph form
5. `<safeguards>` — from P5
6. `<execution_order>` — the topologically-sorted or critical-path-first ordering
7. `<success_criteria>`, `<out_of_scope>`, `<assumptions>`

### Phase 2 — Execution Simulation (P7, internal)

Mentally walk through the plan step-by-step. At each step, ask:
- Are preconditions actually met by prior steps?
- Does the acceptance criterion have a verification method?
- Could this step be interrupted, and if so, does the safeguard handle it?
- Are parallel-safe steps truly independent?

For each gap found, update the plan in place. Do not append — integrate fixes where they belong.

## Output

Write `plan-03-synthesis.md` containing the fully simulated-and-revised `<plan>` XML.

## Return message

> MPLAN3 Synthesis complete. Wrote: plan-03-synthesis.md.
