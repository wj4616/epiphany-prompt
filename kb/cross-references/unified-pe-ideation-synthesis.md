# Unified Prompt Engineering, Ideation, and Synthesis
**Domain:** cross-domain
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — unified-pe-ideation-synthesis

## Summary
Prompt engineering, ideation improvement, and synthesis improvement are not three separate disciplines — they share core mechanisms, and each domain is both a consumer and an enabler of the other two. Understanding this unified structure allows a prompt engineering skill to deliberately borrow ideation techniques to generate diverse prompt candidates, apply synthesis techniques to evaluate and converge on the best candidate, and use prompt engineering fundamentals to structure the final output. The unifying principle across all three domains is that LLM single-pass generation is suboptimal, and the solution in every case is to structure the reasoning space.

## Core Mechanism
**Shared mechanisms across all three domains:**
- **Chain-of-Thought** — simultaneously a prompt engineering structure (eliciting intermediate reasoning), an ideation scaffold (forcing divergent sub-problem decomposition), and a synthesis mechanism (intermediate steps guide multi-source integration)
- **Self-Consistency** — used for prompt engineering evaluation (sampling multiple outputs and voting), for ideation (exploring diverse creative directions), and for synthesis (selecting the most coherent multi-document summary via majority vote)
- **Multi-agent patterns** — appear across all three: Multi-Agent Debate for ideation diversity, Agentic RAG for synthesis retrieval, orchestration pipelines for prompt engineering automation

**Unifying principle:** Every domain responds to the same intervention — replace single-pass generation with structured reasoning space exploration. The specific structure varies: explicit scaffolding (CoT) for sequential tasks, search (ToT) for tasks requiring backtracking, iteration (Self-Refine) for open-ended refinement, ensemble (Self-Consistency) for high-stakes correctness.

**Domain interaction model:**
1. Prompt engineering determines which ideation and synthesis capabilities are activated — a poorly structured prompt suppresses capabilities that are latently available
2. Ideation techniques (CreativeDC, TRIZ-derived constraint mutation) are most naturally expressed as prompt engineering patterns — they are prompts that instantiate a reasoning structure
3. Synthesis quality is doubly gated: first by context construction (prompt engineering layer) and second by the diversity of reasoning paths explored (ideation layer)
4. **Test-Time Compute Scaling** unifies all three domains — allocating more inference compute improves prompt adherence, ideation diversity, and synthesis quality simultaneously and by the same mechanism (more search in reasoning space)

## Application in Skill Context
For an AI agent prompt engineering skill, the unified framework enables a three-stage pipeline: (1) **Generate** — use ideation techniques (CreativeDC, TRIZ mutation, constraint relaxation) to produce a diverse set of prompt candidates; (2) **Evaluate** — use synthesis techniques (Self-Consistency majority vote, Reflexion self-critique, structured rubric scoring) to evaluate and rank candidates; (3) **Structure** — use prompt engineering fundamentals (CO-STAR framework, context engineering guidelines, alignment-aware scaffolding) to finalize the winning candidate. This pipeline is more powerful than either domain applied in isolation because the generate stage produces candidates that single-pass generation would not, and the evaluate stage applies principled selection rather than gut-feel revision.

## Key Variants / Parameters
- **Generate-only pipeline:** Apply ideation techniques without synthesis evaluation; useful when diversity of outputs is itself the goal.
- **Evaluate-only pipeline:** Apply synthesis/Self-Consistency to multiple human-generated candidates; useful when candidates already exist and need ranking.
- **Full three-stage pipeline:** Generate → Evaluate → Structure; maximum quality, highest token cost.
- **Test-Time Compute budget allocation:** More compute in the generate stage (more candidates) vs. the evaluate stage (more evaluation passes) vs. the structure stage (more refinement iterations).

## Related KB Entries
- `theory/prompt-engineering-foundations.md`
- `theory/context-engineering-paradigm.md`
- `theory/in-context-learning.md`
- `theory/synthesis-failure-modes.md`
- `theory/alignment-prompting.md`
- `cross-references/reasoning-scaffold-family.md`
