# Synthesis Failure Modes
**Domain:** synthesis
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — synthesis-failure-modes

## Summary
LLM synthesis failures form a documented taxonomy of ways models fail when integrating information from multiple sources, executing multi-step reasoning, or performing complex task completion. Understanding these failure modes is prerequisite to designing prompts that actively guard against them. Failures range from semantic misunderstanding of the task intent, through structural attention biases that cause information loss, to theoretically proven incompleteness results and emergent multi-agent failure cascades.

## Core Mechanism
The taxonomy comprises five categories: (1) **Semantic misunderstanding** — 51.4% of code repair failures use fundamentally incorrect strategies rather than correcting syntax errors, indicating that LLMs frequently pattern-match to surface form rather than modeling semantic intent; (2) **Lost-in-the-Middle** — multi-document synthesis degrades severely when relevant information is positioned in the center of long contexts; the root cause is causal attention masking combined with positional encoding biases that favor recency and primacy; (3) **Hallucination theoretical bounds** — diagonalization arguments from computability theory prove that for any enumerable model class there exists at least one input that causes failure; stronger results show that for certain synthesis targets the failure set is infinite; (4) **Multi-agent sycophancy cascade** — in multi-agent systems, one agent's confident confabulation creates conformity pressure on other agents; false consensus emerges even when no single agent has high confidence, because agents update toward stated claims rather than independent evidence; (5) **15 system-level failure modes** — a broader catalog including: multi-step reasoning drift, latent inconsistency, context-boundary degradation, incorrect tool invocation, version drift, cost-driven performance collapse, stability failures, reproducibility failures, drift phenomena, workflow integration failures, observability limitations, update-induced regressions, context signal dilution, tool use guesstimation, and structured output degradation.

## Application in Skill Context
A prompt engineering skill should treat each failure mode as a design constraint: (1) For semantic misunderstanding — include worked examples of the *semantic* transformation desired, not just the surface output format; (2) For lost-in-the-middle — place the most critical synthesis target at the start or end of the context, not in the middle of a long document list; (3) For hallucination — instruct the model to express uncertainty explicitly and to cite specific source positions; (4) For sycophancy cascade — when using multi-agent patterns, require independent generation before any cross-agent exposure; (5) For system-level failures — include explicit tool invocation examples and structured output format validation steps.

## Key Variants / Parameters
- **Primacy/recency placement:** Mitigates lost-in-the-middle by intentional ordering.
- **Self-Consistency ensembling:** Partially mitigates semantic misunderstanding and hallucination by majority-voting across multiple independent generation paths.
- **Independent generation protocol:** Requires each agent to generate its answer before seeing peer outputs; directly counters sycophancy cascade.
- **Structured output validation:** JSON schema enforcement or output parsers that catch structured output degradation at runtime.

## Related KB Entries
- `theory/context-engineering-paradigm.md`
- `theory/in-context-learning.md`
- `theory/alignment-prompting.md`
- `cross-references/reasoning-scaffold-family.md`
- `cross-references/unified-pe-ideation-synthesis.md`
