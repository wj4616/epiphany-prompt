# RAG Prompting
**Domain:** enhancement
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — rag-prompting

## Summary
RAG Prompting covers the design of prompts specifically engineered to work with dynamically retrieved context. The core concern is ensuring the model treats retrieved content as authoritative, cites sources traceably, handles contradictions between sources explicitly, and expresses calibrated uncertainty when retrieval is insufficient. Advanced patterns extend standard RAG with hypothetical document generation for improved retrieval (HyDE), selective retrieval triggered only when needed (Self-RAG), and contrastive quality evaluation of retrieved results (CRAG). Prompt compression via LLMLingua can improve RAG performance by 21.4% at one-quarter the token cost.

## Core Mechanism
Four fundamental design concerns for RAG prompts: (1) Faithfulness instructions — explicit directives to ground the response in retrieved content rather than parametric knowledge ("Answer only using the provided documents"); (2) Traceability — instructions to cite or attribute each claim to a specific source document; (3) Conflict handling — explicit strategy for contradictions between retrieved sources ("When sources disagree, present both positions and identify which is more recent or authoritative"); (4) Confidence calibration — instructions to acknowledge retrieval gaps ("If the provided documents do not contain enough information to answer, say so explicitly"). Advanced patterns: HyDE (Hypothetical Document Embeddings) inverts retrieval order by generating a hypothetical ideal answer first, then using its embedding to retrieve real documents — this narrows semantic distance between query and relevant documents. Self-RAG inserts reflection tokens into the model's output to trigger retrieval only when needed, reducing unnecessary context injection. CRAG (Corrective RAG) adds a contrastive reasoning step that evaluates retrieved result quality before synthesis and discards low-quality retrievals. LLMLingua compresses retrieved context tokens, removing low-value middle content (addressing lost-in-middle effects) while preserving high-value boundary content. RAGAS is the standard framework for evaluating RAG prompt quality across faithfulness, answer relevance, context precision, and context recall dimensions.

## Application in Skill Context
When a prompt engineering skill injects KB entries as retrieved context, it should include all four fundamental RAG prompt design elements in the synthesis instruction. The faithfulness instruction prevents the model from ignoring KB content and defaulting to parametric knowledge. Traceability instructions cause the model to reference specific KB entries by name when justifying improvement proposals, making the reasoning auditable. Conflict handling is essential when KB entries from different research waves make contradictory recommendations — the skill should explicitly surface these conflicts rather than silently resolving them. HyDE is applicable to KB retrieval: before querying the KB, generate a hypothetical KB entry describing the ideal technique, then use that description to retrieve the most relevant real entries. LLMLingua compression applies when multiple long KB entries are injected and the assembled context risks losing key information to the lost-in-middle effect.

## Key Variants / Parameters
- **Faithfulness strictness**: soft ("prefer retrieved content") vs. hard ("use only retrieved content, no outside knowledge")
- **Citation granularity**: document-level (cite source name) vs. passage-level (cite specific claim)
- **Conflict resolution strategy**: present-both, latest-wins, authority-ranked, explicit-flag
- **Retrieval trigger**: always retrieve (standard RAG) vs. conditional (Self-RAG reflection tokens)
- **Context compression**: none, LLMLingua (token-level), extractive summarization (sentence-level)

## Related KB Entries
- synthesis/agentic-rag.md
- synthesis/lost-in-middle.md
- enhancement/automatic-prompt-optimization.md
- enhancement/prompt-caching.md
