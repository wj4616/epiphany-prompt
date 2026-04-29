# Self-Refine
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — self-refine research report

## Summary
Self-Refine (Madaan et al., 2023) implements a generate → self-feedback → revise loop in which the same model produces an initial output, critiques that output, and then revises it based on the critique, repeating until a stopping criterion is met. This yields approximately 20% absolute improvement on diverse generation tasks. The key theoretical insight is that LLMs have sufficient internalized world knowledge to evaluate the quality of their own outputs without requiring external feedback or labeled data. Self-Refine differs from Self-Consistency — that technique samples multiple outputs and votes; Self-Refine sequentially critiques and revises a single output.

## Core Mechanism
The three-step loop: (1) Generate — the model produces an initial output for the task; (2) Feedback — the model is prompted separately to evaluate the output it just produced, identifying specific flaws, gaps, or improvement opportunities with concrete suggestions ("the second paragraph lacks supporting evidence; add a citation"); (3) Refine — the model is prompted to revise the output using the feedback it generated in step 2. The loop continues until a quality threshold is reached (e.g., feedback states "no further improvements needed") or a maximum iteration count is hit. The feedback prompt is distinct from the generation prompt — it uses an evaluative framing that asks the model to act as a critic rather than a generator. A known risk is self-bias: models tend to rate their own outputs more favorably than human evaluators do, leading to insufficient critique depth. Multi-agent variants address this by using a separate model or persona as the feedback provider, introducing critical distance.

## Application in Skill Context
In a prompt engineering skill, Self-Refine is the default iteration mechanism when external validation is unavailable. After a generation stage, the skill inserts a feedback prompt asking the model to evaluate the output against specific quality criteria relevant to the task (e.g., "Does this synthesis cite all source documents? Is every claim grounded? Is the structure logical?"). The revised output is then generated from the combined original output + feedback. For epiphany-style skills where output quality is partly subjective, the feedback prompt must specify concrete, checkable criteria rather than asking for general impressions — this reduces self-bias by anchoring critique to observable properties. Typically 1–2 refinement iterations are sufficient; additional iterations produce diminishing returns and risk over-editing toward verbose outputs.

## Key Variants / Parameters
- **Standard Self-Refine**: single model generates, critiques, and revises; simplest setup, most self-bias risk
- **Multi-agent Self-Refine**: separate critic model or persona provides feedback; reduces self-bias
- **Stopping criteria**: quality threshold (model judges "no improvements needed") or max iteration count (typically 2–3)
- **Feedback specificity**: open-ended critique vs. criteria-anchored checklist; criteria-anchored produces more actionable revisions

## Related KB Entries
- [self-consistency.md](self-consistency.md)
- [reflexion.md](reflexion.md)
- [meta-prompting.md](meta-prompting.md)
- [chain-of-thought.md](chain-of-thought.md)
