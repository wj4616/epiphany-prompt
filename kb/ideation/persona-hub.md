# Persona Hub Ideation
**Domain:** ideation
**Type:** technique
**Relevance:** medium
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
Persona Hub Ideation uses large, diverse synthetic persona libraries to generate ideas from multiple human perspectives simultaneously, increasing idea diversity by exploiting the different conceptual framings, values, and expertise levels that different personas bring to a problem. Microsoft's Persona Hub generates 500,000 synthetic personas with diverse backgrounds, expertise levels, professional roles, cognitive styles, and value systems. Research shows that persona-augmented ideation significantly increases idea diversity as measured by semantic distance metrics (DAT — Divergent Association Task scores, ESD — Embedding Semantic Distance). Role-Play Room extends the technique by having multiple personas interact rather than generate in isolation, producing synergistic ideas that emerge from the interaction rather than from any individual persona.

## Core Mechanism
The basic mechanism has three steps: (1) Persona Sampling — select N diverse personas, prioritizing maximum diversity across expertise level, cultural background, professional role, and cognitive style rather than relevance to the problem domain. Cross-domain personas (e.g., a jazz musician evaluating a software architecture problem) produce more novel ideas precisely because they are not anchored to domain conventions. (2) Perspective Generation — prompt the model to generate ideas as each persona in turn, with the persona description provided as context. The model activates different regions of its semantic space depending on the persona framing. (3) Synthesis — aggregate the diverse ideas and apply a convergent evaluation step (see creative-dc.md) to identify the most valuable cross-persona insights. Role-Play Room brainstorming places multiple personas in a shared conversation context, adding interaction dynamics: personas react to and build on each other's ideas, generating emergent concepts through dialogue.

## Application in Skill Context
In a prompt engineering skill, Persona Hub Ideation is applied to evaluate prompt candidates from multiple user-type perspectives and to generate prompt variants that serve diverse audiences. Persona selection for prompt evaluation: sample a novice user (no domain knowledge, needs maximum clarity), an expert user (deep domain knowledge, tolerates ambiguity, needs precision), and an edge-case user (unusual use pattern, tests boundary conditions of the prompt). Each persona generates an independent critique and revision. This surfaces gaps that single-perspective evaluation misses. For prompt variant generation, cross-domain personas generate structurally novel framings: a lawyer persona produces constraint-first prompts; a teacher persona produces pedagogical scaffolding structures; a game designer persona produces challenge-reward framings. Even a small persona set of 3–5 diverse profiles substantially increases prompt variant diversity.

## Key Variants / Parameters
- **Persona count**: 3–5 for most tasks; larger sets increase diversity but add latency
- **Persona diversity axis**: expertise level (novice to expert), professional role, cultural background, cognitive style (analytical, intuitive, creative, systematic)
- **Cross-domain personas**: higher novelty but require explicit framing to connect the persona's domain back to the target problem
- **Role-Play Room**: interactive multi-persona dialogue; higher novelty through emergence, higher complexity and latency
- **Persona Hub source**: Microsoft Persona Hub (500K synthetic personas), custom small persona library, or inline persona descriptions

## Related KB Entries
- [creative-dc.md](creative-dc.md)
- [multi-agent-debate.md](multi-agent-debate.md)
- [constraint-based-prompting.md](constraint-based-prompting.md)
- [divpo.md](divpo.md)
