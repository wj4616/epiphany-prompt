# Inference Economics — Unified Cross-Domain Framework
**Domain:** cross-domain
**Type:** framework
**Relevance:** high
**Source:** Wave 3 — inference-economics-research-2025.md

## Summary
Inference Economics is the practical science of allocating inference compute across prompt quality, test-time compute (TTC) depth, and ensemble breadth to maximize output quality per unit cost. The single most impactful finding from 2025 research is that strategy selection dominates raw budget size: summary aggregation over multiple model runs outperforms giving a reasoning model more thinking tokens at 7× greater compute efficiency (Rebase). Prompt quality investment almost always yields higher ROI than TTC scaling for repeatable tasks.

## Core Mechanism
Three orthogonal axes define the inference compute allocation space:
1. **Depth (sequential)**: longer thinking traces, iterative refinement, Reflexion loops — increases single-run quality.
2. **Width (parallel)**: Best-of-N sampling, Self-Consistency, Mixture-of-Agents (MoA) aggregation — increases diversity and coverage.
3. **Strategy**: aggregation method applied to parallel outputs — majority vote → weighted vote → summary aggregation → Rebase. Strategy is the highest-leverage variable.

Key empirical laws:
- **Strategy > budget**: Rebase achieves 7× efficiency over simple weighted majority voting at identical compute.
- **Overthinking degrades easy tasks**: More thinking tokens reduce accuracy on tasks below a complexity threshold. Thought Pruning and DeepConf mitigate this.
- **Prompt quality ROI dominates TTC ROI**: For repeatable tasks at scale, prompt engineering investment yields 40–60× return versus scaling TTC.
- **Compute-optimal window**: Best cost/quality ratio occurs when pass@1 is in the 20–70% range. Below 20%, model changes or RAG/fine-tuning are required; TTC scaling alone cannot rescue hard tasks.

**Decision Framework:**

| Scenario | Best intervention |
|----------|------------------|
| Repeatable task at scale | Invest in prompt quality first (40–60× ROI vs. TTC scaling) |
| Medium-complexity reasoning (pass@1 20–70%) | Reasoning model + aggregation strategy (Best-of-N or Summary) |
| Hard task (pass@1 < 20%) | Change model or add RAG/fine-tuning — TTC alone won't rescue |
| Simple task, hard latency constraint | Standard model + few-shot prompt (80% more efficient than zero-shot) |
| Variable-difficulty workload | Plan-and-Budget decomposition + DAST/SelfBudgeter difficulty routing |

## Application in Skill Context
**For prompt engineering skills**: Better prompts are almost always a higher ROI than more TTC. Invest in prompt structure, context engineering, and Automated Prompt Optimization (APO) before increasing reasoning budget. Use Plan-and-Budget decomposition for complex multi-step tasks to achieve +70% accuracy at −39% token cost.

**For ideation skills**: Use parallel sampling (Best-of-N, aggregation) rather than sequential depth — parallel sampling generates more diverse ideas per compute unit. Self-Consistency aggregation is well-suited to divergent creative output.

**For synthesis skills**: Summary aggregation (MARS pattern) beats serial refinement at the same compute budget. Rebase is the preferred aggregation backend for synthesis pipelines where quality variance across runs is high.

**For skill routing and orchestration**: Route by task difficulty. Use DAST (Difficulty-Adaptive Slow-Thinking) or SelfBudgeter to allocate TTC proportionally — hard subtasks get deep reasoning, easy subtasks get fast shallow pass. This prevents overthinking degradation on trivial components.

**Cost trajectory consideration**: Inference cost is falling approximately 10× per year through 2026. Designs built around current cost constraints will become obsolete. Designs built around reasoning approach quality (strategy, aggregation, prompt structure) are durable investments.

## Key Variants / Parameters
- **Rebase**: Summary-based aggregation; 7× more compute-efficient than weighted majority voting. Best for quality-critical tasks with variable output structure.
- **Plan-and-Budget**: Sub-question decomposition with per-subquestion token budget allocation. +70% accuracy, −39% tokens on complex multi-step tasks.
- **TALE-EP / TALE-PT**: Think-long/express-precisely pipeline. −67% token reduction with <3% accuracy loss. Use for output compression without quality sacrifice.
- **DAST (Difficulty-Adaptive Slow-Thinking)**: Uses TLB metric + contrastive RL to route TTC allocation by detected task difficulty.
- **SelfBudgeter**: Model autonomously estimates its minimal required token budget. Zero configuration; degrades gracefully.
- **BudgetThinker**: Precise thought-length control at inference time. Use when strict token budgets are externally imposed.
- **L1 taxonomy (fixed budget)**: Budget Forcing, CoT-Valve, TokenSkip, Elastic Reasoning.
- **L2 taxonomy (adaptive difficulty-aware)**: Concise CoT, Skeleton-of-Thought, C3oT, Adaptive-Consistency.

## Related KB Entries
- [theory/inference-economics.md](../theory/inference-economics.md)
- [ideation/transformational-creativity.md](../ideation/transformational-creativity.md)
