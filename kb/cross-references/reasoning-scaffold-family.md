# Reasoning Scaffold Family
**Domain:** cross-domain
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — reasoning-scaffold-family

## Summary
The Reasoning Scaffold Family is the overarching technique family that covers all methods for structuring the reasoning space of an LLM rather than trusting single-pass generation. It spans prompt engineering, ideation, and synthesis domains, and is the single most practically impactful technique family in the 2025–2026 era of LLM deployment. Every member of the family works by the same principle: externalize and control the search process that the model would otherwise perform implicitly and incompletely in a single forward pass.

## Core Mechanism
The family is organized into five structural subfamilies:

**Chain Methods** (linear, no backtracking):
- Chain-of-Thought (CoT) — intermediate reasoning steps before final answer
- Zero-Shot CoT — "Let's think step by step" suffix elicits CoT without examples
- Auto-CoT — automated selection and annotation of CoT examples
- Least-to-Most Prompting — decomposes problem into ordered sub-problems, solves sequentially
- Skeleton-of-Thought — generates outline in parallel then expands each branch independently (reduces latency)

**Tree/Graph Methods** (branching, backtracking):
- Tree of Thoughts (ToT) — explicit branching with BFS or DFS search; evaluates intermediate states
- Tree of Uncertain Thoughts — extends ToT with uncertainty quantification at each node
- Graph of Thoughts (GoT) — arbitrary graph structure; supports merging of reasoning branches
- Adaptive Graph of Thoughts — dynamically selects graph topology based on task structure at runtime

**Iteration Methods** (refinement loops):
- Self-Refine — generate → critique → revise loop using same model
- Reflexion — adds episodic memory of past failures; self-evaluation drives future attempt strategy
- Self-Ask — model generates its own sub-questions and answers them before answering the main question

**Ensemble Methods** (multiple paths, aggregation):
- Self-Consistency — multiple independent generation paths; majority vote over final answers
- CISC (Confidence-weighted Inconsistency-penalized Self-Consistency) — weights votes by expressed confidence and penalizes inconsistent paths
- Multi-Agent Debate — multiple distinct model instances generate and critique each other's outputs; converges via iterative debate

**Cross-Domain Pattern:**
The scaffold family spans all three domains: CoT for prompt engineering and sequential synthesis; ToT for creative ideation requiring backtracking; Self-Consistency for multi-source synthesis and high-stakes prompt evaluation; Multi-Agent Debate for ideation diversity. Selection principle: **Chain** for strictly sequential tasks with no dead ends; **Tree** for tasks requiring backtracking or option pruning; **Graph** for tasks with interdependent sub-problems that merge; **Iteration** for open-ended refinement without a fixed termination criterion; **Ensemble** for tasks where correctness can be verified by agreement.

## Application in Skill Context
A prompt engineering skill uses the scaffold family at two levels: (1) **Externally** — scaffolds are applied within the prompts the skill generates, as the reasoning structure encoded into the target prompt; (2) **Internally** — the skill's own prompt engineering pipeline uses scaffolds (e.g., Self-Refine to iterate its own output, Self-Consistency to evaluate candidate prompts). When choosing a scaffold for a skill's internal pipeline, match the structural choice to the task type: generating diverse prompt candidates calls for Tree or Ensemble methods; refining a single candidate calls for Iteration methods; constructing a multi-part structured prompt calls for Chain methods.

## Key Variants / Parameters
- **BFS vs. DFS in ToT:** BFS (breadth-first) is better for tasks where early pruning is reliable; DFS with backtracking is better for tasks where promising paths can fail late.
- **Number of self-consistency samples:** 10–40 samples is typical; diminishing returns above 40 for most tasks.
- **Reflexion memory scope:** Short-term (within session) vs. long-term (across sessions stored in KB); long-term requires external memory infrastructure.
- **Multi-Agent Debate rounds:** 2–3 debate rounds is typically sufficient; more rounds risk consensus collapse into sycophancy.

## Related KB Entries
- `theory/prompt-engineering-foundations.md`
- `theory/in-context-learning.md`
- `theory/synthesis-failure-modes.md`
- `cross-references/unified-pe-ideation-synthesis.md`
