# Meta-Prompting
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — meta-prompting research report

## Summary
Meta-Prompting uses one LLM call to generate, optimize, or assemble prompts that are then used in a downstream LLM call. Rather than writing prompts by hand, a meta-prompt instructs the model to act as a "prompt engineer" and produce or improve a prompt for a specific task. This approach sits above individual prompts in the context engineering hierarchy — it manages the strategic assembly of prompt components rather than producing the final task output directly. Also called "LLM as prompt engineer," meta-prompting is the foundation of automated prompt optimization systems.

## Core Mechanism
Two primary forms: Dynamic Meta-Prompting adapts prompt strategy at runtime based on detected task type, input characteristics, or prior output quality — the meta-LLM inspects the incoming task and selects or assembles an appropriate prompt strategy. Automated APO meta-prompting uses one model to generate candidate instruction variants and a separate model (or the same model with a different prompt) to evaluate and rank them, forming an optimization loop without human intervention. The Meta-Prompting Protocol introduces adversarial feedback loops where a "critic" model evaluates drafts produced by a "generator" model, driving iterative improvement. Recursive Meta Prompting (RMP) uses categorical and algebraic principles to formally specify self-improvement rules, enabling principled recursive prompt refinement.

## Application in Skill Context
In a prompt engineering skill, meta-prompting is applied to automate the construction of high-quality prompts for downstream skill stages rather than hardcoding them. The skill can include a meta-prompt stage that takes the user's stated goal and generates a task-specific system prompt for the actual reasoning stage. This is especially valuable in skills that handle diverse input types — the meta-prompt step classifies the input and selects the appropriate prompt template. For skills that must self-improve over sessions, a meta-prompting feedback loop can generate revised instruction variants based on observed output failures, enabling the skill to evolve without manual editing. The technique also supports A/B evaluation of prompt variants within a single skill invocation.

## Key Variants / Parameters
- **Dynamic Meta-Prompting**: runtime context-adaptive prompt assembly; suitable for multi-domain skills
- **Automated APO**: generator + evaluator model pair; requires labeled examples for evaluation criterion
- **Meta-Prompting Protocol**: adversarial critic/generator loop; highest quality, highest cost
- **Recursive Meta Prompting (RMP)**: algebraic/categorical self-improvement rules; most principled but most complex

## Related KB Entries
- [dspy-framework.md](dspy-framework.md)
- [context-engineering.md](context-engineering.md)
- [self-refine.md](self-refine.md)
- [prompt-chaining.md](prompt-chaining.md)
