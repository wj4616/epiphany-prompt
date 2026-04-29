# Mixture of Agents (MoA)
**Domain:** synthesis
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — mixture-of-agents-research.md

## Summary
Mixture-of-Agents (MoA) is a layered multi-agent synthesis architecture in which a pool of proposer agents independently generate candidate responses, and one or more aggregator agents synthesize them into a final output. The key empirical finding is the "collaborativeness phenomenon": LLMs improve output quality when given other models' responses as reference material, even when those reference models are weaker than the aggregator. This non-obvious synergy enables quality gains beyond what any single model achieves independently.

## Core Mechanism
**Standard MoA pipeline:**
1. Layer 1 — Proposers: N agents independently generate responses to the same prompt (parallel, no cross-communication)
2. Layer 2+ — Aggregators: each aggregator receives the prior layer's outputs concatenated as reference context and synthesizes a single improved response
3. Multiple aggregator layers can be stacked; quality typically plateaus after 2–3 layers

**Collaborativeness phenomenon:** Models perform better synthesis when shown other outputs than when working alone, even if those reference outputs are from smaller or weaker models. The reference outputs act as diverse anchors that expose reasoning paths the aggregator would not have generated independently.

**Key variants:**
- **MoA-Lite:** Single proposer layer with a single aggregator; cost-efficient version that captures most quality gain with minimal overhead
- **Self-MoA:** Single model generates N responses sequentially, then aggregates them treating the outputs as if from distinct "other models." Challenges the claim that MoA superiority requires genuinely different models — self-diversity can partially replicate the effect
- **MARS (Author-Reviewer Multi-Agent Synthesis):** Structured pipeline: Author generates initial proposal → Independent Reviewers evaluate without seeing each other's assessments → Meta-Reviewer synthesizes all reviews into final output. Achieves 50% token savings versus standard MoA at equivalent quality
- **LLM-Blender:** Pairwise ranking aggregation — ranks all proposer outputs against each other, then uses the top-ranked output or a synthesis of top-ranked outputs

## Application in Skill Context
Apply MoA to prompt enhancement pipelines to generate N independently reasoned prompt improvement proposals, then aggregate them via a synthesis prompt.

**Recommended pattern for prompt engineering skills (MARS):**
1. Author step: prompt the model to generate one improved version of the input prompt, with rationale
2. Reviewer step (2–3 independent calls, same model or different): each reviewer evaluates the Author's proposal on specific axes (clarity, specificity, reasoning scaffold quality, edge case coverage) without seeing other reviewers' feedback
3. Meta-Reviewer step: synthesizes all reviewer feedback into a final improved prompt, accepting valid critiques and rejecting contradictory or low-quality ones

**Self-MoA for single-model contexts:** When only one model is available, generate 3–5 independent prompt improvement proposals by varying the improvement instruction (e.g., "focus on reasoning structure," "focus on output schema," "focus on example quality"), then aggregate. This is cheaper than multi-model MoA and captures meaningful diversity.

**Token budget guidance:** Standard MoA with 3 proposers + 1 aggregator uses approximately 4× the tokens of a single call. MARS with 1 author + 2 reviewers + 1 meta-reviewer uses approximately 4× tokens but delivers higher quality than flat 4-proposer MoA due to the structured critique dynamic.

## Key Variants / Parameters
- **Number of proposer agents (N):** Quality gains are typically logarithmic in N; 3–5 proposers captures most benefit; beyond 7 the aggregator context becomes unwieldy
- **Proposer diversity strategy:** Different models, different temperature settings, or different framing of the same prompt all increase useful diversity in outputs
- **Aggregator instruction specificity:** Generic "synthesize the best response" aggregation underperforms compared to explicit criteria ("adopt the clearest structure, the most specific examples, and the most conservative claims")
- **Layer depth:** Single aggregator layer is sufficient for most tasks; stacking 2 layers is warranted for complex multi-criteria synthesis

## Related KB Entries
- [synthesis/self-consistency-synthesis.md](self-consistency-synthesis.md)
- [synthesis/cot-synthesis.md](cot-synthesis.md)
- [synthesis/process-reward-models.md](process-reward-models.md)
- [synthesis/structured-output-decoding.md](structured-output-decoding.md)
