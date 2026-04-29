# Mixture of Experts (MoE) for Synthesis
**Domain:** synthesis
**Type:** theory
**Relevance:** medium
**Source:** Wave 1 — mixture-of-experts-synthesis

## Summary
Mixture of Experts (MoE) replaces dense feed-forward layers in transformer models with sparse gated expert sub-networks, where each token is routed to only the top-K most relevant experts rather than activating all parameters. In synthesis contexts, different expert sub-networks may specialize in distinct synthesis sub-tasks such as summarization, cross-document comparison, or logical inference. All major frontier models as of 2025–2026 use MoE architectures, making this a foundational property of the models prompt engineers are working with.

## Core Mechanism
Each MoE layer contains E expert feed-forward networks and a router. For each token, the router computes a softmax over expert relevance scores and selects the top-K experts (typically K=1 or K=2). Only those expert weights are activated; the rest remain dormant. This creates sparse computation: a model can have 10–100x more total parameters than a dense model of equivalent FLOP cost. Load-balancing losses during training prevent expert collapse (where a few experts handle all tokens while others go unused). Key 2025–2026 systems: DeepSeekMoE uses fine-grained expert segmentation for better specialization; ResMoE achieves space-efficient compression via residual restoration; CMoE converts dense models to MoE post-hoc in minutes; LLMoE uses a separate LLM as the router, enabling semantic routing rather than learned linear routing. For synthesis tasks specifically, expert routing may implicitly specialize by synthesis sub-task — tokens in a comparison clause may route differently than tokens in a summary clause — but this routing is not directly inspectable or controllable by prompt engineers.

## Application in Skill Context
MoE architecture affects synthesis quality indirectly through expert routing. Prompts that clearly signal the synthesis sub-task type — by using task-specific framing words and structured task delineation — may elicit more consistent expert routing and therefore more specialized outputs. Concretely: when a prompt engineering skill constructs a synthesis prompt, it should use explicit task labels ("Compare the following sources:" vs. "Summarize the following sources:") rather than leaving the synthesis type implicit. This is not guaranteed to affect routing, but aligns with the general principle that precise task framing produces more reliable outputs from MoE models. The practitioner implication is awareness: MoE routing means model behavior can be non-monotone with respect to prompt changes, as small framing shifts may cross routing thresholds.

## Key Variants / Parameters
- **K (experts per token)**: K=1 (maximally sparse) to K=8 (denser activation, higher cost)
- **Router type**: learned linear router (standard) vs. LLM-based router (LLMoE, more semantic but higher overhead)
- **Expert count**: fine-grained (many small experts, DeepSeekMoE style) vs. coarse-grained (few large experts)
- **Load balancing**: auxiliary loss during training vs. expert capacity constraints at inference

## Related KB Entries
- synthesis/knowledge-distillation.md
- synthesis/cot-synthesis.md
