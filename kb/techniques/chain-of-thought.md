# Chain-of-Thought Prompting
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — chain-of-thought research report

## Summary
Chain-of-Thought (CoT) prompting, introduced by Wei et al. (2022), instructs a model to produce explicit intermediate reasoning steps before delivering a final answer. This forces the model to surface its reasoning process rather than jumping directly to a conclusion. Two main forms exist: Few-Shot CoT, which provides fully worked reasoning exemplars, and Zero-Shot CoT, which appends a simple trigger phrase such as "Let's think step by step." The technique is most effective on models with at least 100 billion parameters.

## Core Mechanism
In Few-Shot CoT, each demonstration in the prompt includes not just an input-output pair but a worked reasoning trace — the model learns to imitate the step-by-step pattern. In Zero-Shot CoT, the trigger phrase activates latent multi-step reasoning behavior already present in large models without requiring labeled examples. The reasoning trace externalizes the model's intermediate beliefs, making errors easier to detect and reducing hallucination by anchoring the final answer to a verifiable chain. Auto-CoT automates the generation of CoT demonstrations by clustering questions and sampling representative examples, removing the need for human-authored traces.

## Application in Skill Context
Within an AI agent prompt engineering skill, CoT is applied when outputs require multi-step reasoning — for example, synthesizing multiple documents, evaluating a design against criteria, or debugging a complex problem. The skill inserts a reasoning scaffold in the system or user prompt (e.g., "Work through this step by step before giving your answer") to prevent the model from pattern-matching to a shallow answer. In synthesis tasks specifically, CoT guides the model through evidence accumulation and contradiction resolution before producing the final synthesis. CoT traces also serve as internal audit trails when the skill needs to explain or validate its reasoning to a downstream consumer.

## Key Variants / Parameters
- **Few-Shot CoT**: 2–5 fully worked exemplars in the prompt; highest reliability but requires curated examples
- **Zero-Shot CoT**: trigger phrase appended to prompt; lower setup cost, slightly lower reliability
- **Auto-CoT**: automated demonstration generation from question clusters; removes human authoring effort
- **Self-Consistency + CoT**: sample N reasoning chains and vote on the most consistent answer; +17.9% GSM8K, +11% SVAMP, +12.2% AQuA over greedy CoT decoding

## Related KB Entries
- [self-consistency.md](self-consistency.md)
- [tree-of-thoughts.md](tree-of-thoughts.md)
- [react-framework.md](react-framework.md)
- [few-shot-prompting.md](few-shot-prompting.md)
