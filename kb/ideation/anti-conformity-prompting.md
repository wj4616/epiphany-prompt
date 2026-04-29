# Anti-Conformity Prompting
**Domain:** ideation
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — multi-agent-ideation-patterns.md

## Summary
Anti-Conformity Prompting is an explicit instruction strategy for multi-agent debate and iterative refinement systems that directs agents to resist peer influence and maintain intellectual independence across rounds. The core problem it addresses is the sycophancy cascade: in standard multi-round MAD systems, agents progressively converge toward whichever agent expressed the highest initial certainty, regardless of whether that position is correct or optimal. Anti-conformity directives interrupt this dynamic by explicitly framing capitulation to peer pressure as a reasoning failure, not a cooperative virtue. The technique extends into architectural variants — Free-MAD and DMAD — that eliminate structural mechanisms that enable cascade convergence.

## Core Mechanism
Three levels of anti-conformity intervention, applied in combination:

**Level 1 — Explicit directive**: add a standing instruction to every agent's system prompt in any multi-round pipeline:
> "Do NOT simply agree with other agents' positions. If you disagree, maintain your position and explain why. Conformity pressure is not evidence. You must only update your position when presented with a specific argument or piece of evidence you find genuinely compelling — not because other agents sound more confident."

**Level 2 — Free-MAD architecture**: replaces per-round majority-vote consensus with a trajectory-aware scoring function. Rather than asking "who won this round?", Free-MAD scores each agent's full argument trajectory across all rounds simultaneously, rewarding consistency, evidence-backed position changes, and argument quality. This removes the structural incentive to conform in order to be on the winning side of a round vote.

**Level 3 — DMAD (Diverse Multi-Agent Debate)**: assigns agents not just distinct personas but distinct *cognitive strategies* — for example, one agent uses decomposition reasoning, one uses analogical reasoning, one challenges core assumptions. Persona diversity alone is insufficient because agents with different roles but identical reasoning approaches still converge. Strategy-level diversity maintains genuine cognitive independence throughout all debate rounds.

## Application in Skill Context
In a prompt engineering skill that uses any multi-agent evaluation or improvement loop, anti-conformity directives must be applied by default. Without them, a multi-agent prompt review will surface the first agent's dominant opinion restated by all subsequent agents, producing false confidence in a potentially mediocre revision. The directive is included in the system prompt of every non-synthesizer agent. The synthesizer agent (Blue hat, meta-reviewer, aggregator) is explicitly excluded — it needs to integrate all views, not maintain independence. In DMAD configuration for prompt improvement, strategy assignments map naturally to prompt evaluation tasks: one agent decomposes the prompt into clauses and evaluates each; one identifies analogous successful prompts; one directly challenges the core instruction's assumptions.

## Key Variants / Parameters
- **Directive placement**: system prompt (persistent, highest effectiveness) vs. per-round user message (lower effectiveness but usable when system prompt is inaccessible)
- **Free-MAD scoring**: trajectory-aware scoring across all rounds; eliminates round-by-round voting; requires post-hoc evaluation of full debate transcripts
- **DMAD strategy set**: decomposition, analogical reasoning, assumption-challenging, evidence-gathering, constraint-relaxation — choose 3–5 strategies per debate instance
- **Synthesis agent exception**: the final aggregator should NOT carry anti-conformity instructions; it must integrate, not debate
- **Strength calibration**: overly strong anti-conformity directives produce agents that refuse to update on genuinely good arguments; phrase as "update only on evidence/argument, not confidence level"

## Related KB Entries
- [multi-agent-debate.md](multi-agent-debate.md)
- [six-thinking-hats.md](six-thinking-hats.md)
- [../theory/synthesis-failure-modes.md](../theory/synthesis-failure-modes.md)
- [../cross-references/multi-agent-patterns-for-pe.md](../cross-references/multi-agent-patterns-for-pe.md)
