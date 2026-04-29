# Prompt Engineering Foundations
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — prompt-engineering-foundations

## Summary
Prompt engineering is the discipline of crafting, structuring, and optimizing inputs to large language models (LLMs) to reliably produce desired outputs. As of 2026, the field has matured to treat prompts as programmable interfaces that can be version-controlled, tested, and optimized through systematic experimentation — no longer an ad-hoc art form but a software engineering subdiscipline. The field spans textual discrete prompts, continuous soft prompts (learnable embedding vectors), and hybrid approaches.

## Core Mechanism
Three levels of prompting exist: (1) Textual/Discrete prompts — human-readable instructions passed as token sequences; (2) Continuous/Soft prompts — learnable embedding vectors prepended to model inputs, optimized by gradient descent rather than human authorship; (3) Hybrid — discrete frames with soft inner components. Historical periodization marks three eras: Emergence 2020–2022 (zero-shot, few-shot, and Chain-of-Thought discovered; iteration was manual); Systematisation 2023–2024 (58+ named techniques catalogued, first formal taxonomies); Mastery Age 2025–2026 (automatic optimization via DSPy, agent orchestration, multimodal prompting). Core terminology: a *prompt* is any model input; a *system prompt* is a persistent instruction preamble; a *user prompt* is a per-turn instruction; the *context window* is the total token budget; *in-context learning (ICL)* is task adaptation via examples without weight updates. OWASP LLM Top 10 lists prompt injection as the #1 vulnerability — adversarial text that hijacks instruction following.

## Application in Skill Context
A prompt engineering skill operates at Level 1 (discrete textual prompts) by default. Knowing the three-era history helps calibrate which techniques are mature vs. experimental. The Mastery Age framing sets the standard: prompts should be version-controlled artifacts with test suites. When building or refining prompts for an AI agent skill, the skill should apply systematic evaluation rather than one-off iteration, and treat prompt injection as a threat model to defend against.

## Key Variants / Parameters
- **Zero-shot prompting:** No examples; relies on instruction alone.
- **Few-shot prompting:** 3–10 in-context examples; bootstraps task understanding.
- **Soft / prefix tuning:** Gradient-optimized continuous vectors; not hand-craftable but maximally expressive.
- **Automatic prompt optimization (APO):** Tools like DSPy search discrete prompt space automatically using labeled data.

## Related KB Entries
- `theory/in-context-learning.md`
- `theory/context-engineering-paradigm.md`
- `cross-references/unified-pe-ideation-synthesis.md`
