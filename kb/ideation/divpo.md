# DivPO — Diverse Preference Optimization
**Domain:** ideation
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
DivPO (Diverse Preference Optimization) is a post-training technique developed by Meta AI that embeds diversity signals directly into a model's parameters rather than relying on prompting to elicit diverse outputs. Standard RLHF and DPO optimize for output quality relative to a preference signal, but this implicitly penalizes diversity because all "good" responses converge toward the mode of the preference distribution. DivPO modifies the DPO training objective to explicitly reward inter-sample diversity within a training batch, making diverse generation a first-class training goal rather than an accidental by-product. CRPO (Creative Preference Optimization) is a related technique specifically targeting creative writing and ideation tasks.

## Core Mechanism
Standard DPO training uses pairs of preferred and rejected outputs to train the model toward the preferred distribution. DivPO augments this with a diversity term: outputs within a training batch are compared against each other using a semantic distance metric (e.g., embedding cosine distance or n-gram overlap), and the training signal rewards not just preference over the rejected sample but also semantic distance from other accepted samples in the batch. This directly counteracts mode collapse — the tendency of quality-optimized models to produce high-probability, low-variance outputs. The result is a model whose sampling distribution is broader: at equivalent quality levels, DivPO-trained models produce outputs with greater semantic distance from each other across multiple samples. CRPO applies a similar mechanism with task-specific creative diversity metrics.

## Application in Skill Context
For a prompt engineering skill operating on DivPO-trained models, the practical implication is that standard multi-sample generation (temperature sampling with N > 1) will produce meaningfully diverse prompt candidates without requiring special divergent-phase scaffolding. On models not trained with DivPO, the prompt-side workaround is to use the CreativeDC divergent-phase structure (see creative-dc.md) to manually enforce diversity by forbidding evaluation during generation. When DivPO-trained models are available, the skill can simplify: generate N candidates with temperature 0.8–1.0, then apply a convergent evaluation pass. When they are not available, the skill must use explicit divergent-phase prompting, persona diversity (see persona-hub.md), or constraint rotation (see constraint-based-prompting.md) to compensate.

## Key Variants / Parameters
- **DivPO**: general-purpose diverse preference optimization; applies across task types
- **CRPO (Creative Preference Optimization)**: optimized specifically for creative and ideation tasks; uses creative-specific diversity metrics
- **Diversity metric choices**: semantic embedding distance (captures conceptual diversity), n-gram distance (captures surface diversity), task-specific rubric scoring
- **Prompt-side workaround**: CreativeDC divergent phase; effective but adds latency and prompt complexity

## Related KB Entries
- [creative-dc.md](creative-dc.md)
- [multi-agent-debate.md](multi-agent-debate.md)
- [persona-hub.md](persona-hub.md)
- [../theory/synthesis-failure-modes.md](../theory/synthesis-failure-modes.md)
