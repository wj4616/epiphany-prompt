# Multi-Agent Patterns for Prompt Engineering
**Domain:** cross-domain
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — multi-agent-ideation-patterns.md

## Summary
Multi-Agent Patterns for Prompt Engineering is a taxonomy of five architectural patterns — drawn from multi-agent systems research — that can be applied specifically to prompt improvement workflows. Each pattern addresses a different prompt engineering need: structured refinement, diverse proposal generation, adversarial hardening, multi-perspective evaluation, and routed specialization. The taxonomy provides selection criteria so a skill designer can choose the most appropriate pattern for a given improvement task rather than defaulting to the highest-complexity option. Cross-cutting orchestration considerations (sycophancy prevention, token cost, convergence mechanism) apply regardless of which pattern is chosen.

## Core Mechanism
**Pattern 1 — Proposer-Critic Loop (Evaluator-Optimizer)**
Generator agent proposes prompt improvements; Evaluator agent critiques against explicit rubrics; loop iterates until a quality threshold is met or a round limit is reached. Best for: refinement tasks with clear, pre-defined evaluation criteria. Lowest complexity; most predictable token budget.

**Pattern 2 — Diverse Proposal Pool (MoA / MARS)**
Multiple proposer agents independently generate improvement candidates without seeing each other's work; an aggregator agent synthesizes the pool. MARS variant: Author generates → independent Reviewers evaluate → Meta-Reviewer synthesizes (50% token savings vs. full MoA). Best for: generating a broad set of diverse enhancement options before selection.

**Pattern 3 — Adversarial Red-Team + Blue-Team**
Red-team agent attacks the prompt — injection attempts, edge case construction, misinterpretation scenarios, ambiguity exploitation; Blue-team agent defends and repairs based on the identified vulnerabilities. Best for: hardening prompts against adversarial inputs and unexpected or pathological usage.

**Pattern 4 — Expert Panel (Six Thinking Hats / MAD / DMAD)**
Multiple agents adopt distinct evaluation perspectives simultaneously rather than sequentially. MAD for factual correctness verification; DMAD for creative diversity; Six Thinking Hats for structured six-dimension coverage. Best for: comprehensive prompt evaluation across multiple independent dimensions in a single pass.

**Pattern 5 — Orchestrator-Subagent with Skill Routing**
Orchestrator agent analyzes the prompt's purpose and routes to specialized subagents — each contributing domain-specific improvements (e.g., a chain-of-thought subagent, a RAG-optimization subagent, a persona-consistency subagent). Subagents operate independently and return structured improvement recommendations; orchestrator integrates. Best for: multi-purpose prompts spanning distinct technical requirements that cannot be addressed by a single generalist evaluator.

## Application in Skill Context
In a prompt engineering skill, pattern selection follows the improvement task type:
- **Iterative polish of a known-good prompt** → Pattern 1 (lowest overhead, most focused)
- **Exploring fundamentally different reformulations** → Pattern 2 (MARS for token efficiency, MoA for maximum diversity)
- **Hardening a prompt for production or adversarial contexts** → Pattern 3
- **Full-spectrum evaluation before finalizing a prompt** → Pattern 4 (Six Thinking Hats for structured coverage; DMAD when creative diversity is also required)
- **Improving a complex multi-function prompt** → Pattern 5

Patterns can be composed: a skill might use Pattern 2 to generate candidates, then Pattern 4 to evaluate them, then Pattern 1 to refine the winner. The cross-cutting orchestration rules below apply at every composition level.

## Key Variants / Parameters
- **Sycophancy prevention**: apply anti-conformity directives to all non-synthesizer agents in Patterns 3 and 4; not required for Pattern 1 (single-critic) or Pattern 2 (no inter-agent visibility before aggregation)
- **Information sharing timing**: agents share outputs only after independent first-pass generation in all patterns; premature visibility collapses diversity
- **Convergence mechanism**: use trajectory-aware scoring (Free-MAD) in Pattern 4 rather than round-by-round majority voting; majority voting enables sycophancy cascade
- **Token cost ranking** (low to high): Pattern 1 < MARS (Pattern 2) < Pattern 3 < MoA (Pattern 2) < Pattern 4 < Pattern 5
- **Quality ceiling ranking** (approximate): Pattern 5 ≥ Pattern 4 > Pattern 2 > Pattern 3 > Pattern 1 (task-dependent)
- **Minimum viable composition**: Pattern 2 (MARS) + anti-conformity + trajectory scoring covers 80% of prompt improvement needs at moderate token cost

## Related KB Entries
- [../ideation/multi-agent-debate.md](../ideation/multi-agent-debate.md)
- [../ideation/six-thinking-hats.md](../ideation/six-thinking-hats.md)
- [../ideation/anti-conformity-prompting.md](../ideation/anti-conformity-prompting.md)
- [alignment-creativity-tradeoff.md](alignment-creativity-tradeoff.md)
- [../ideation/persona-hub.md](../ideation/persona-hub.md)
- [../ideation/divpo.md](../ideation/divpo.md)
