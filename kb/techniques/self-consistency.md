# Self-Consistency
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — self-consistency research report

## Summary
Self-Consistency (Wang et al.) samples multiple diverse reasoning chains from the same prompt and selects the final answer by majority vote across all sampled paths. Rather than relying on a single greedy decoding pass, the model generates N independent reasoning traces and marginalizes over them to identify the most consistently reached conclusion. This yields a +17.9% improvement on GSM8K over standard greedy Chain-of-Thought decoding. The technique applies to arithmetic, commonsense, and symbolic reasoning tasks.

## Core Mechanism
Standard greedy decoding locks the model into the first reasoning path it begins, which may be suboptimal or incorrect. Self-Consistency breaks this lock by sampling N completions (typically N=20–40) with non-zero temperature, producing diverse chains that may reach the same correct answer by different routes. The final answer is selected by majority vote — whichever conclusion appears most frequently across the N paths wins. This is equivalent to marginalizing over the reasoning path space rather than conditioning on a single path. The Confidence-Improved Self-Consistency (CISC) variant weights each path by the model's self-assessed confidence score rather than treating all votes equally, improving accuracy when the model has calibrated uncertainty.

## Application in Skill Context
In a prompt engineering skill, Self-Consistency is most valuable when the task has a verifiable or convergent correct answer — evaluations, classifications, factual lookups, or reasoning checks. The skill can run the same evaluation prompt N times (or in parallel) and aggregate results before surfacing a conclusion. For epiphany-style synthesis tasks where multiple analytical angles are desirable, sampling diverse reasoning chains before converging on insight recommendations mirrors the Self-Consistency mechanism at the workflow level. The trade-off is inference cost: N=20 means 20x the token budget, so this technique is reserved for high-stakes decisions or validations, not routine generation.

## Key Variants / Parameters
- **Standard Self-Consistency**: N=20–40 samples, majority vote; best accuracy, highest cost
- **CISC (Confidence-Improved Self-Consistency)**: paths weighted by model self-confidence; better calibration
- **Reduced N variants**: N=5–10 for cost-sensitive applications; lower accuracy gain but still positive
- **Sampling temperature**: must be >0 to produce diverse paths; typically 0.5–0.8

## Related KB Entries
- [chain-of-thought.md](chain-of-thought.md)
- [tree-of-thoughts.md](tree-of-thoughts.md)
- [self-refine.md](self-refine.md)
