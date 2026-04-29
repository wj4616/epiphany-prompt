# Prompt Compression
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — prompt-compression-research.md

## Summary
Prompt compression encompasses techniques that reduce token count while preserving semantic content, applied at inference time before the synthesis LLM receives input. The family spans token-level learned compression, scoring-based training-free pruning, RAG-specific summarization, and KV-cache compression at the inference infrastructure level. The practical goal is to fit more signal into the context window, reduce latency and cost, and avoid the lost-in-the-middle degradation that afflicts long contexts.

## Core Mechanism
**Token-level compression (soft, training-required):**
- Gist Tokens (gisting): attention-masked fine-tuning compresses prompts into virtual gist tokens that act as compressed representations; achieves 26× compression ratio
- AutoCompressor: iterative recurrent compression into summary vectors passed as soft prefix; 40× compression
- ICAE: LLM-native autoencoder maps input into compact memory slots; 4× compression using approximately 1% additional parameters

**Scoring-based compression (training-free):**
- LLMLingua family: uses a small surrogate LM to compute perplexity-based token importance scores; iteratively removes low-importance tokens (LLMLingua → LongLLMLingua → LLMLingua-2, each improving speed and task-agnosticism)
- Selective Context: prunes low-surprisal (low self-information) tokens — removes tokens the model can predict easily from context
- CompactPrompt: combines self-information scoring with dependency phrase grouping, n-gram abbreviation, and numerical quantization

**RAG-specific compression:**
- RECOMP: learned extractive or abstractive summarization trained end-to-end for the downstream RAG task; not generic compression but task-aligned
- xRAG: projects dense retrieval embeddings into a single LM token via cross-modal projection; 3.53× FLOPs reduction

**KV-cache compression (inference infrastructure level):**
- H2O (Heavy-Hitter Oracle): retains recent tokens plus tokens with highest cumulative attention score; evicts the rest
- StreamingLLM: permanently retains attention-sink initial tokens plus a recent sliding window
- FreqKV: transforms KV states to frequency domain and discards high-frequency (redundant) components
- WindowKV: task-adaptive consecutive semantic window keeping 12% of KV cache
- xKV: cross-layer SVD into shared low-rank KV subspace; 4.23× inference speedup

## Application in Skill Context
In prompt engineering skill pipelines, compression is applied to long reference contexts, retrieved documents, or verbose system instructions before they reach the synthesis LLM.

**Recommended practical approach:** LLMLingua-2 is the best general-purpose choice — it is fast, task-agnostic, requires no access to the target LLM's internal probabilities, and can be run as a preprocessing step on any text. For RAG pipelines, RECOMP provides task-aligned compression with measurable downstream quality improvement over generic compression.

**Compression placement in skill pipeline:**
1. Retrieve or assemble raw context (KB entries, retrieved docs, prior conversation)
2. Apply LLMLingua-2 compression to reduce to target token budget
3. Pass compressed context to synthesis prompt

**Lost-in-middle mitigation:** After compression, reorder retained content so highest-importance chunks appear at the beginning and end of the context window, exploiting primacy and recency bias.

## Key Variants / Parameters
- **Compression ratio target:** Higher ratios risk semantic loss; LLMLingua-2 is empirically robust to 2–6× compression before quality degrades
- **Training-required vs. training-free:** Gist/AutoCompressor/ICAE require fine-tuning the target model; LLMLingua family runs on any model without modification
- **Sentence-level vs. token-level granularity:** Sentence-level (RECOMP extractive) preserves coherence better; token-level (LLMLingua) achieves higher compression ratios
- **KV-cache vs. prompt-level:** KV-cache methods operate at inference infrastructure level and are transparent to prompt authors; prompt-level methods are applicable in API contexts

## Related KB Entries
- [synthesis/lost-in-middle.md](lost-in-middle.md)
- [synthesis/agentic-rag.md](agentic-rag.md)
- [synthesis/knowledge-distillation.md](knowledge-distillation.md)
