# Lost-in-the-Middle Problem
**Domain:** synthesis
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — lost-in-middle-synthesis

## Summary
The Lost-in-the-Middle problem (Liu et al., 2023) describes a systematic failure mode in LLM multi-document synthesis: model performance degrades severely when relevant information is positioned in the middle of a long context window. The effect is driven by causal attention mechanics and positional encodings that create primacy and recency biases — the model attends more reliably to the beginning and end of its input than to the interior. The accuracy drop has been quantified at 30% or more for middle-positioned relevant information.

## Core Mechanism
Causal attention masking means each token only attends to prior tokens, creating asymmetric weighting across positions. Positional encodings (including RoPE) further amplify boundary effects: tokens at low and high position indices receive stronger signal than mid-range positions. The result is that when a synthesis task distributes key facts across many documents, facts appearing in the middle sections of the assembled prompt are systematically underweighted. Mitigation strategies address this at different layers: (1) Key-first placement — restructure the prompt so the most critical information appears at the start or end; (2) Pre-summarization — generate a digest of middle sections and place it at the beginning; (3) Prompt compression — use LLMLingua or similar tools to remove low-value middle tokens before synthesis; (4) Positional encoding fixes at the architecture level, including segment embeddings and noisy positive sampling; (5) Set Encoding — assign multiple texts the same position ID, removing positional bias entirely.

## Application in Skill Context
When building a synthesis prompt that assembles KB entries or retrieved documents, the skill must treat document ordering as a first-class concern. The highest-relevance KB entries should be placed at the start of the context block, followed by supporting entries, with the least critical material last. If the assembled context is long, a pre-summarization step should extract key claims from middle-section entries and prepend them as a digest. Prompt compression via LLMLingua is applicable when token budget is a constraint — it preserves boundary content while removing redundant middle material. Any skill that uses a retrieve-and-synthesize pattern should include an explicit reordering step before the final synthesis call.

## Key Variants / Parameters
- **Placement strategy**: key-first (critical at start) vs. sandwich (critical at start and end) vs. pre-summarized digest
- **Compression method**: LLMLingua (token-level compression) vs. extractive summarization (sentence-level) vs. none
- **Set Encoding**: applicable only when using models or inference frameworks that support configurable position assignment
- **Middle section threshold**: how many documents before middle degradation becomes significant (empirically: >5–7 documents)

## Related KB Entries
- synthesis/agentic-rag.md
- synthesis/cot-synthesis.md
- enhancement/rag-prompting.md
