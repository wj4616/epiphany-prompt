# Chain-of-Thought for Multi-Document Synthesis
**Domain:** synthesis
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — cot-synthesis

## Summary
Chain-of-Thought (CoT) scaffolding for multi-document synthesis applies structured reasoning steps specifically to the task of integrating information from multiple sources, where the challenge is not just step-by-step logic but handling agreement, contradiction, and incompleteness across documents. The approach inserts explicit intermediate reasoning stages — identify claims, compare sources, reconcile conflicts — before generating a final synthesized output. Extended approaches distribute the synthesis workload across multiple LLM agents, each handling a segment of the source material.

## Core Mechanism
The standard RAG+CoT scaffold follows a three-instruction sequence: "First, identify the key claim from each source. Then, identify agreements and contradictions. Finally, synthesize a coherent response that integrates all sources." This forces the model to explicitly represent inter-source relationships before committing to a synthesis. The three-stage research pipeline formalizes this as: structured preprocessing (normalize and clean each source) → cross-document reasoning (compare, align, and flag conflicts) → instruction-tuned decoding (generate synthesis conditioned on the reasoning trace). The critical extension over standard CoT is explicit contradiction handling: synthesis CoT must produce a resolution strategy for conflicting claims, not merely chain reasoning steps. Chain-of-Agents extends this further by distributing the synthesis across multiple LLM instances — each agent processes a segment and passes a summary chain to the next, with a final agent synthesizing all summaries. This is training-free and applicable to contexts that exceed a single model's effective window.

## Application in Skill Context
In a prompt engineering skill, CoT synthesis is used when the skill must generate reasoned improvements to a prompt by comparing current vs. target prompt quality across multiple criteria. The skill prompt should include an explicit CoT scaffold: (1) list the specific weaknesses in the current prompt for each quality dimension; (2) identify which weakness is most impactful; (3) propose improvements ordered by expected impact. When the skill ingests multiple KB entries, a pre-synthesis CoT step should identify which entries directly support each weakness diagnosis before the improvement proposal stage. For long skill instructions, Chain-of-Agents architecture applies: one agent processes KB entries and produces a synthesis summary; a second agent uses that summary plus the user's prompt to generate improvement proposals.

## Key Variants / Parameters
- **CoT granularity**: coarse (3-step: identify, compare, synthesize) vs. fine (per-document claim extraction before comparison)
- **Contradiction resolution strategy**: latest-wins, source-authority ranking, explicit flag and present-both
- **Chain-of-Agents topology**: linear chain (segment → segment → final) vs. tree (parallel segments → aggregator)
- **Decoding constraint**: free-form synthesis vs. structured output (JSON/XML) forced by CoT scaffold

## Related KB Entries
- synthesis/agentic-rag.md
- synthesis/self-consistency-synthesis.md
- synthesis/lost-in-middle.md
