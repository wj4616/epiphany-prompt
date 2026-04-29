# Role Prompting
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** medium
**Source:** Wave 1 — role-prompting research report

## Summary
Role Prompting (also called Persona Assignment) assigns the model an expert identity at the start of the prompt to shift its output register, activate domain-specific knowledge, and calibrate the level of technical precision in its responses. A prompt beginning with "You are a senior software architect reviewing this code" consistently produces more structured, terminology-accurate, and critically engaged code reviews than the same prompt without the persona. Role prompting is most effective for code tasks, creative tasks, and domain-specific analysis; it carries risk in accuracy-critical tasks because the model may generate authoritative-sounding but incorrect information when performing a persona.

## Core Mechanism
The model has internalized patterns of language, reasoning style, and knowledge emphasis associated with different professional roles through pretraining on role-labeled text. By specifying a role in the system prompt, the prompt activates those associated patterns — a "senior Python engineer" persona shifts the model toward PEP 8 compliance, performance considerations, and code review idioms. The effect is strongest when the role description is specific and concrete: "senior software architect with 10 years of Python experience" activates different patterns than "expert." Role prompting works alongside, not instead of, explicit task, format, and constraint specifications — the role sets the voice and knowledge register; explicit instructions set the task parameters. Persona Hub (a research artifact sampling 500k synthetic personas) demonstrates that persona diversity can be systematically extended far beyond common professional archetypes, covering rare domain experts, cultural perspectives, and specialized roles not well-represented in standard prompting.

## Application in Skill Context
In a prompt engineering skill, role prompting is applied in the system prompt to establish the model's analytical stance for the session. For a skill that evaluates prompt quality, the role might be "You are a prompt engineering researcher with deep expertise in Chain-of-Thought and structured output techniques." For a skill that synthesizes creative briefs, the role might be "You are a creative director who prioritizes conceptual coherence over surface-level polish." The key constraint is that the role must be paired with explicit task instructions — role alone does not specify what to do, only how to do it. Role prompting should be avoided or used with caution when the task requires precise factual accuracy, as the model may confabulate authoritative-sounding claims to maintain persona consistency.

## Key Variants / Parameters
- **Generic role**: "You are an expert in X" — minimal specification; moderate effect
- **Specific role**: "You are a senior X with N years of Y experience who specializes in Z" — stronger activation
- **Persona Hub**: 500k synthetic personas available for systematic persona diversity; useful for multi-perspective analysis
- **Adversarial persona**: assigns a critic or challenger role to produce skeptical evaluation outputs

## Related KB Entries
- [few-shot-prompting.md](few-shot-prompting.md)
- [context-engineering.md](context-engineering.md)
- [structured-output.md](structured-output.md)
