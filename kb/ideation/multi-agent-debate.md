# Multi-Agent Debate (MAD)
**Domain:** ideation
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
Multi-Agent Debate (MAD) is a framework in which multiple LLM agents each generate an independent initial position, then engage in structured rounds of critique and defense until convergence or a synthesis. Originally developed for factual reasoning tasks where majority agreement signals correctness, MAD has been adapted for ideation where diversity of output — not correctness — is the goal, requiring different evaluation criteria and design choices. Research shows MAD significantly outperforms single-agent brainstorming for idea diversity, but requires careful configuration to prevent sycophancy cascade, in which agents converge prematurely by deferring to the most confident-sounding response.

## Core Mechanism
The standard MAD pipeline has four stages: (1) Independent Generation — each agent receives the same prompt and generates an initial response without seeing the others; this independence is critical and must be enforced by separating the calls. (2) Distribution — each agent receives all responses, including its own, as context. (3) Critique Rounds — each agent is prompted to critically evaluate the other agents' responses and defend or update its own position based on the arguments; rounds continue for a fixed count (typically 2–3) or until convergence. (4) Synthesis — a final agent or aggregation step produces the consensus output or a synthesis of the most defensible positions. The Society of Mind / Sibyl Jury variant adds explicit jury-selection logic: agents are assigned different expertise roles before generation, and deliberation follows structured protocols modeled on jury deliberation. The LLM Discussion Framework (3-phase variant): Role-play discussion setup, then structured debate, then synthesis.

## Application in Skill Context
In a prompt engineering skill, MAD is applied to generate and stress-test prompt candidates from multiple evaluative perspectives simultaneously. Three agents are assigned different roles: Agent A evaluates the prompt from a novice user's perspective (will this be understood?); Agent B evaluates from an expert user's perspective (is this specific enough?); Agent C evaluates from a model-behavior perspective (does this trigger known failure modes?). Each agent generates an independent critique and suggested revision, then the debate round surfaces conflicts between the revisions. The synthesis step produces a prompt that resolves the conflicts. Optimal configuration for ideation: 3–5 agents, 2–3 rounds, and an explicit instruction to maintain distinct positions rather than converge — this counteracts sycophancy cascade.

## Key Variants / Parameters
- **Agent count**: 3–5 optimal for ideation; more agents increase diversity but add latency and coordination overhead
- **Round count**: 2–3 rounds; more rounds increase convergence (useful for factuality, counterproductive for diversity)
- **Role assignment**: generic agents vs. expert-persona agents; persona assignment increases diversity for ideation
- **Convergence pressure**: explicit instruction to maintain distinct positions prevents premature consensus
- **Society of Mind / Sibyl Jury**: adds jury selection and structured deliberation; highest quality but highest complexity
- **LLM Discussion Framework**: 3-phase setup, debate, synthesis; balanced overhead and quality

## Related KB Entries
- [creative-dc.md](creative-dc.md)
- [persona-hub.md](persona-hub.md)
- [divpo.md](divpo.md)
- [../theory/synthesis-failure-modes.md](../theory/synthesis-failure-modes.md)
