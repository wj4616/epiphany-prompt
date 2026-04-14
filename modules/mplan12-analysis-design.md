---
name: mplan12-analysis-design
stage_id: MPLAN12
input_dependencies:
  - 00-config.md
  - 00-input.md
output_files:
  - plan-01-analysis.md
  - plan-02-design.md
scale_variants: [STANDARD]
kb_sources:
  - kb/techniques/tree-of-thoughts.md
  - kb/techniques/rewoo.md
  - kb/techniques/react-framework.md
  - kb/cross-references/reasoning-scaffold-family.md
activation:
  mode: plan
  wave: 1
  role: analysis+design
return_contract: |
  "MPLAN12 Analysis+Design complete. Wrote: plan-01-analysis.md, plan-02-design.md."
---

# MPLAN12 — Goal Analysis + Dependency Design

Two-phase single agent for plan mode. Phase 1 covers goal analysis (P2) and action decomposition (P3). Phase 2 covers dependency mapping (P4) and safeguard design (P5).

## Inputs

Read from `{session_dir}`:
- `00-config.md` — confirm mode = plan
- `00-input.md` — specification or goal-with-constraints input

## Phase 1 — Goal Analysis + Action Decomposition (P2 + P3)

Follow **Step P2** and **Step P3** from SKILL.md `## Plan Mode Pipeline`.

- P2: extract the goal, success criteria, constraints, out-of-scope items.
- P3: decompose into atomic actions. Each action has: ID (A1, A2, ...), description, acceptance criterion, estimated complexity (LOW/MEDIUM/HIGH), preconditions.

Write to `plan-01-analysis.md` using the structure defined in P2 + P3.

## Phase 2 — Dependency Mapping + Safeguard Design (P4 + P5)

Follow **Step P4** and **Step P5** from SKILL.md `## Plan Mode Pipeline`.

- P4: build a dependency graph over actions from Phase 1. Identify parallel-safe sets, sequential chains, critical path.
- P5: for each action, design safeguards — what could go wrong, detection signal, rollback action.

Write to `plan-02-design.md`.

## Return message

> MPLAN12 Analysis+Design complete. Wrote: plan-01-analysis.md, plan-02-design.md.
