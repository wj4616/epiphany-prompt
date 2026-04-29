# Test-Time Compute Scaling
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 2 — test-time-compute-scaling

## Summary
Test-Time Compute (TTC) Scaling allocates additional inference compute to improve output quality at generation time rather than at training time. Two fundamental strategies exist: Sequential (longer reasoning traces, iterative self-refinement, Reflexion loops) and Parallel (Best-of-N sampling, Self-Consistency majority voting, tree/graph search). Empirical scaling laws show TTC scales like training compute — more inference budget improves quality with diminishing returns. These strategies are complementary but face distinct failure modes.

## Core Mechanism
Sequential strategies extend reasoning depth per generation: the model produces longer thinking traces, refines its own outputs iteratively, or runs Reflexion loops that critique and retry. Parallel strategies generate multiple candidate outputs and aggregate them: Best-of-N picks the highest-scored candidate; Self-Consistency takes majority vote across N samples; tree/graph search (ToT, MCTS, FoT) explores branching solution paths.

Compute-Optimal Scaling allocates TTC budget proportionally to estimated problem difficulty — easy problems get fewer tokens, hard problems get more. TOPS (Thinking-Optimal Scaling Strategy) operationalizes this as a 3-stage pipeline: format imitation → effort-conditioned generation → self-improvement.

Key failure mode for sequential strategies: "overthinking" — on easy tasks, more tokens can decrease accuracy. Mitigations include Thought Pruning (filters low-confidence traces before aggregation) and DeepConf (applies early termination on local confidence drop).

Advanced search variants: Forest-of-Thought (FoT, ICML 2025) runs multiple parallel reasoning trees with cross-tree consensus via sparse activation. AB-MCTS (Adaptive Branching Monte Carlo Tree Search) is a Bayesian tree search that adaptively balances width vs. depth per node using uncertainty estimates; variants include AB-MCTS-M (hierarchical mixed model) and AB-MCTS-A (node aggregation with conjugate priors).

Commercial budget controls: Thinking Budget (Gemini 2.5) — explicit 0–24,576 token cap; Thinking Level (Gemini 3) — relative parameter (minimal/low/medium/high); Budget Forcing — decoding-time cap on thinking token generation.

## Application in Skill Context
When designing prompt engineering workflows, TTC Scaling theory informs how much reasoning budget to allocate per task phase. For complex prompt analysis or synthesis tasks, instruct the model to use extended thinking (sequential strategy). For quality-sensitive single outputs, use Best-of-N or Self-Consistency across prompt variants (parallel strategy). Apply Compute-Optimal Scaling by classifying task difficulty upfront: routine enhancement tasks use minimal thinking budget; novel synthesis or contradiction-resolution tasks use high budget. Avoid activating extended thinking for trivial formatting or extraction subtasks where overthinking degrades accuracy.

## Key Variants / Parameters
- **Sequential:** extended thinking traces, Reflexion loops, iterative self-refinement
- **Parallel:** Best-of-N, Self-Consistency majority vote, Tree of Thoughts, Forest of Thought, AB-MCTS
- **Budget controls:** Thinking Budget (token cap), Thinking Level (relative), Budget Forcing (decoding-time cap)
- **Overthinking mitigations:** Thought Pruning, DeepConf early termination
- **Compute-Optimal Scaling:** difficulty-proportional budget allocation
- **TOPS pipeline:** format imitation → effort-conditioned generation → self-improvement

## Related KB Entries
- techniques/forest-of-thought.md
- theory/thinking-intervention.md
