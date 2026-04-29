# Constitutional AI (CAI)
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — constitutional-ai

## Summary
Constitutional AI (Anthropic, 2022) is a two-phase alignment pipeline that makes the model's values reasoning explicit and editable through a written "constitution" — a set of natural language principles. Phase 1 uses supervised critique-and-revision cycles to generate a safe response dataset; Phase 2 uses AI-generated preference labels (RLAIF) to train a reward model without human annotators. The key innovation is that alignment criteria are expressed as inspectable, modifiable NL principles rather than implicit human annotation patterns. A "constitutional prompt" adapts this approach to inference time: embedding explicit evaluation principles causes the model to critique and revise its own outputs in a single session, with no fine-tuning required.

## Core Mechanism
Phase 1 — SL-CAI (Supervised Constitutional AI): for each potentially harmful or low-quality response, the model is prompted to (a) critique the response against a specific constitutional principle (e.g., "Is this response helpful, honest, and harmless? Identify any ways it fails to satisfy these criteria"), then (b) revise the response to comply with the critique. Multiple sequential critique-revise cycles on diverse examples produce a supervised dataset of improved responses, which is used for SFT. Phase 2 — RLAIF: the SL-CAI model scores preference pairs (original vs. revised response) using the constitutional principles as an evaluation rubric, producing synthetic preference labels. These labels train a preference model without any human annotation. The reward model trained on these AI-generated preferences matches human-preference-trained models on harmlessness while preserving helpfulness. C3AI (ACM 2025) adds an engineering methodology for constitution design: principle framing matters significantly — positive framing ("respond in a way that is supportive") yields 27% better adherence than equivalent negatively-framed principles ("do not respond in a way that is harmful"). Domain-specific CAI adapts the constitution for specialized contexts (healthcare, legal, financial) by replacing generic principles with domain-appropriate constraints and obligations.

## Application in Skill Context
The constitutional prompt pattern is the most directly applicable CAI technique for prompt engineering skills that run at inference time without fine-tuning access. A constitutional prompt embeds explicit evaluation principles inline, then instructs the model to apply a self-critique pass before producing the final output: "Before finalizing your response, evaluate it against these principles: [principle list]. If any principle is violated, revise accordingly." In the epiphany-prompt skill, the constitution should encode the specific quality dimensions being optimized — reasoning completeness, output format compliance, citation fidelity — as positively framed principles (per C3AI findings). The critique-revise cycle can be run as a single two-turn exchange or as an explicit multi-step chain within a single prompt. For domain-specific skill variants (e.g., a JUCE DSP prompt optimization skill), the constitution should include domain constraints such as audio thread safety rules or parameter boundary validation requirements.

## Key Variants / Parameters
- **Deployment mode**: inference-time constitutional prompt (no fine-tuning) vs. SL-CAI fine-tuning vs. RLAIF full pipeline
- **Principle framing**: positive ("respond in a way that...") vs. negative ("do not...") — positive yields +27% adherence (C3AI)
- **Critique-revise cycle count**: single pass vs. multi-pass (each additional pass adds cost with diminishing returns beyond 2–3 cycles)
- **Constitution scope**: general-purpose vs. domain-specific (healthcare, legal, financial, audio DSP)
- **Evaluation rubric integration**: principles as inline critique prompts vs. as separate judge LLM call

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- theory/alignment-prompting.md
- techniques/self-refine.md
- techniques/reflexion.md
