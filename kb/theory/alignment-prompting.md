# Alignment-Aware Prompting
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — alignment-prompting

## Summary
Alignment-aware prompting theory describes how a model's alignment training objectives interact with prompt design and why understanding those objectives is necessary for crafting prompts that achieve creative, high-entropy, or unconventional outputs. All production-deployed instruction-following models have been shaped by alignment training (RLHF, DPO, or CAI), and the resulting behavioral biases are as architecturally real as positional encodings — they must be accounted for, not ignored. The central tension is that alignment makes models more reliably steerable but harder to push toward genuinely novel outputs.

## Core Mechanism
Three alignment paradigms determine the behavioral landscape of modern LLMs: (1) **RLHF (Reinforcement Learning from Human Feedback)** — human raters rank outputs; a reward model learns to predict ratings; the base model is fine-tuned via PPO to maximize predicted reward. The systematic effect on prompting is that RLHF suppresses creative entropy: models learn that safe, expected, hedged outputs receive higher average ratings, so they regress toward the mean of human preference rather than the extremes; (2) **DPO (Direct Preference Optimization)** — a scalable RLHF alternative that replaces the explicit reward model with a binary classification loss trained directly on preferred vs. rejected completion pairs. DPO achieves similar alignment with lower training cost and no separate reward model; from a prompting standpoint the behavioral signature is similar to RLHF but often with softer refusal behavior; (3) **Constitutional AI (CAI)** — the model is trained to critique its own outputs against a written set of constitutional principles, then revise them before feedback is collected. This makes alignment reasoning explicit and traceable in the model's generation process and reduces dependence on human annotation volume. System prompts interact directly with all three alignment regimes: a system prompt can reinforce trained behaviors (e.g., amplifying safety refusals) or create mild tension with them (e.g., requesting outputs that are unconventional but not policy-violating). Recognizing where trained priors are being suppressed allows prompt engineers to scaffold around them.

## Application in Skill Context
When a prompt engineering skill is generating creative or divergent prompts (ideation, brainstorming, TRIZ-style problem reframing), it must account for RLHF-induced conservative entropy suppression. Practical countermeasures: (1) use explicit permission-granting language in the system prompt ("explore unconventional angles without hedging"); (2) use temperature elevation in the API call alongside prompt-level scaffolding; (3) frame creative constraints as explicit instructions rather than relying on the model to infer creative intent; (4) use CAI-style self-critique turns to steer refinement toward the constitutional criteria of the skill rather than the model's trained defaults. Understanding alignment also helps explain why certain phrasings reliably trigger refusals — these are trained preference boundaries, not capability limits.

## Key Variants / Parameters
- **RLHF models:** Strong conservative entropy suppression; require explicit creative permission scaffolding.
- **DPO models:** Similar behavioral signature to RLHF; softer refusal slope; more amenable to boundary exploration with appropriate framing.
- **CAI-trained models (e.g., Claude):** Constitutional reasoning is traceable in outputs; can be leveraged by explicitly invoking the constitutionality of the desired output ("this serves the user's genuine interest by...").
- **Base models (no alignment):** High creative entropy but low instruction fidelity; rarely used in production agent contexts.

## Related KB Entries
- `theory/prompt-engineering-foundations.md`
- `theory/synthesis-failure-modes.md`
- `cross-references/unified-pe-ideation-synthesis.md`
