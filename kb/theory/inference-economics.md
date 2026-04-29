# Inference Economics
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 3 — inference-economics-research-2025.md

## Summary
Inference Economics is the empirical study of how allocating additional inference compute — via thinking token depth, sampling width, or aggregation strategy — translates into output quality gains, and at what point returns diminish or invert. The field establishes that aggregation strategy is the dominant variable, outweighing raw compute budget. For repeatable tasks at scale, prompt quality investment yields 40–60× higher ROI than scaling test-time compute (TTC).

## Core Mechanism
Three allocation axes govern the inference compute space:

1. **Depth (sequential)**: Longer thinking traces, iterative self-refinement, Reflexion loops. Increases quality on a single run. Subject to overthinking degradation on easy tasks — additional tokens actively reduce accuracy below a complexity threshold.

2. **Width (parallel)**: Best-of-N sampling, Self-Consistency, Mixture-of-Agents (MoA) aggregation. Increases output diversity and reduces variance. More robust than depth for creative or open-ended tasks.

3. **Strategy**: The aggregation method applied across parallel outputs — majority voting → weighted majority voting → summary aggregation → Rebase. This axis dominates the other two.

**Key empirical laws:**

- **Rebase efficiency**: Summary aggregation (Rebase) achieves 7× compute efficiency over weighted majority voting at identical total compute. This is the single highest-leverage technique in inference resource allocation.
- **Overthinking degradation**: On tasks below a complexity threshold, additional thinking tokens reduce accuracy. Thought Pruning and DeepConf address this by detecting and pruning low-utility reasoning steps.
- **Prompt quality ROI**: For repeatable tasks at scale, investing in prompt structure and context engineering yields 40–60× return per compute dollar compared to TTC scaling.
- **Compute-optimal window**: The best cost/quality operating point is pass@1 in the range 20–70%. Below 20%, model changes, RAG, or fine-tuning are required — TTC scaling alone cannot rescue tasks in this regime.

**Practical taxonomy** (from "Reasoning on a Budget" survey):

- **L1 — Fixed budget controllable**: Budget Forcing (hard token cap with forced generation), CoT-Valve (continuous CoT length control), TokenSkip (skip low-utility reasoning tokens), Elastic Reasoning (budget-aware reasoning compression).
- **L2 — Adaptive difficulty-aware**: DAST (Difficulty-Adaptive Slow-Thinking using TLB metric + contrastive RL), SelfBudgeter (model autonomously estimates its minimal budget), C3oT (compressed chain-of-thought), Adaptive-Consistency (consistency-guided sampling adapts depth), Concise CoT (brevity-rewarded training), Skeleton-of-Thought (parallel branch generation).

## Application in Skill Context
When designing or orchestrating epiphany-* or KB-backed prompt engineering skills:

1. **Audit prompt quality before scaling compute**: Prompt structure deficiencies cannot be compensated by giving the model more tokens. Diagnose with APO (Automated Prompt Optimization) before routing to a reasoning model.

2. **Select aggregation strategy explicitly**: Never default to majority voting. Rebase or summary aggregation should be the default for quality-critical multi-run pipelines.

3. **Use L2 methods for variable-difficulty workloads**: DAST or SelfBudgeter prevent overthinking on trivial components while allocating depth where it is needed. This is especially important for skills that handle inputs of widely varying complexity.

4. **Apply Plan-and-Budget for complex decomposable tasks**: Sub-question decomposition with per-subquestion token budgets yields +70% accuracy at −39% total token cost compared to monolithic prompting.

5. **Apply TALE-EP/TALE-PT for token-constrained output**: When output verbosity is a cost concern, TALE-PT (express-precisely) achieves −67% token reduction with <3% accuracy loss, making it viable for high-frequency skill invocations.

6. **Cost trajectory planning**: Inference cost is falling approximately 10× per year through 2026. Skills designed around current cost constraints will require rework. Design for reasoning approach quality — strategy, aggregation, prompt structure — as these remain durable.

## Key Variants / Parameters
- **Rebase**: Best-in-class aggregation strategy. 7× efficiency gain over weighted majority voting. Parameter: number of parallel samples (N). Recommended N=4–8 for quality-critical tasks.
- **Plan-and-Budget**: Two parameters — decomposition granularity (number of sub-questions) and per-subquestion budget cap. Finer decomposition increases accuracy but raises orchestration overhead.
- **DAST**: Requires a TLB (Task-Level Budget) metric calibrated for the target domain. Out-of-domain calibration degrades difficulty routing accuracy.
- **SelfBudgeter**: No configuration required. Accuracy on budget estimation degrades on tasks where the model has limited self-knowledge (e.g., novel domains, adversarial inputs).
- **TALE-EP/TALE-PT**: Two-phase: EP (extended thinking) → PT (precision compression). The compression ratio is tunable; >67% compression begins to incur measurable accuracy loss.
- **Overthinking mitigation**: Thought Pruning removes low-utility reasoning steps post-hoc; DeepConf uses confidence signals to detect and halt unproductive reasoning chains early.

## Related KB Entries
- [cross-references/inference-economics-unified.md](../cross-references/inference-economics-unified.md)
- [ideation/transformational-creativity.md](../ideation/transformational-creativity.md)
