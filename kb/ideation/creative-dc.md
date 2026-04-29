# CreativeDC — Divergent-Convergent Two-Phase Prompting
**Domain:** ideation
**Type:** method
**Relevance:** high
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
CreativeDC is a two-phase prompting method that separates idea generation from idea evaluation to prevent premature convergence. Phase 1 (Divergent) instructs the model to produce many diverse ideas without any evaluation, explicitly suspending judgment. Phase 2 (Convergent) instructs the model to evaluate, rank, and synthesize the ideas generated in Phase 1. The structure is grounded in Guilford's divergent production theory and Osborn's brainstorming model, and research shows it significantly outperforms single-pass generation on creative tasks.

## Core Mechanism
The key mechanism is phase separation: the divergent prompt explicitly forbids evaluation during generation ("Generate 10 different approaches to X, each using a completely different principle — do not evaluate or compare them yet"). This prevents the model from self-censoring via internal quality filtering, which normally collapses the output distribution toward high-probability responses. The convergent prompt then explicitly permits and requires evaluation ("From the ideas above, identify the 3 most promising, explain your reasoning for each, then combine their best elements into a synthesized proposal"). The two-call structure enforces the separation — both phases cannot occur in a single generation without convergent pressure bleeding into the divergent phase.

## Application in Skill Context
In an AI agent prompt engineering skill, CreativeDC is used to generate diverse prompt candidates rather than single-pass prompt drafts. Divergent phase: "Generate 10 structurally different framings of this prompt, each using a different rhetorical structure (instruction, role-play, constraint, exemplar, Socratic, etc.)." Convergent phase: "Evaluate each framing against these criteria: clarity, specificity, and alignment with the target model's behavior — then synthesize the strongest framing." This avoids the common failure of prompt iteration that merely rephrases rather than genuinely diversifies.

## Key Variants / Parameters
- **Standard 2-phase**: separate calls for diverge and converge; most reliable separation
- **Single-call with section headers**: one prompt with labeled DIVERGE / CONVERGE sections; slightly weaker separation but lower latency
- **N-ideas parameter**: 5–10 ideas for most tasks; increase to 15–20 for high-novelty creative work
- **Synthesis depth**: convergent phase can stop at ranking (lightweight) or proceed to full synthesis (thorough)

## Related KB Entries
- [autotriz.md](autotriz.md)
- [persona-hub.md](persona-hub.md)
- [constraint-based-prompting.md](constraint-based-prompting.md)
- [divpo.md](divpo.md)
- [multi-agent-debate.md](multi-agent-debate.md)
