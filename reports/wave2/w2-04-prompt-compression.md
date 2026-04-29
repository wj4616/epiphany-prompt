# Prompt Compression: Deep Research Report
*Generated: 2026-04-14 | Sources: 20+ | Confidence: High*

Search query: "prompt compression LLMLingua LongLLMLingua context compression token reduction LLM 2025"

---

## Executive Summary

Prompt compression has matured into a rich field with two dominant paradigms: **hard prompt methods** (discrete token removal/paraphrase) and **soft prompt methods** (encoding into learned continuous vectors). The LLMLingua series from Microsoft remains the most widely deployed hard-prompt approach, achieving up to 20× compression with minimal quality loss. KV-cache compression has emerged as a parallel track, with FreqKV, WindowKV, xKV, H2O, and OmniKV each targeting different efficiency bottlenecks. Agent-oriented compression (ACON, CompactPrompt) addresses long-horizon multi-step interaction. A NAACL 2025 survey formalises the taxonomy across all categories. The field is converging on adaptive, task-aware, and failure-driven strategies rather than static token scoring.

---

## 1. Hard Prompt Methods (Token-Level Removal)

### LLMLingua (Microsoft Research, EMNLP 2023)
- **Mechanism:** Coarse-to-fine prompt compression. A small surrogate LM (GPT2-small or LLaMA-7B) scores tokens by perplexity. A budget controller preserves semantic integrity under high compression ratios; a token-level iterative algorithm models interdependence between retained tokens; instruction-tuning aligns distribution between small and target LMs.
- **Performance:** Up to 20× compression with minimal performance loss. Reduces RAG costs by ~80% using only 1/4 of tokens, with RAG improvement up to 21.4%.
- **Integrations:** LangChain, LlamaIndex, Microsoft Prompt Flow.
- **Source:** https://arxiv.org/abs/2310.05736 | https://github.com/microsoft/LLMLingua

### LongLLMLingua (Microsoft Research, ACL 2024)
- **Mechanism:** Extension of LLMLingua targeting long-context settings. Conditions token perplexity scoring on the question rather than the passage alone, mitigating the "lost in the middle" problem where relevant information in the middle of long contexts is under-represented.
- **Performance:** Up to 17.1% performance improvement while reducing token count by ~4×.
- **Source:** https://www.llmlingua.com/

### LLMLingua-2 (Microsoft Research, ACL 2024)
- **Mechanism:** Replaces the perplexity-based surrogate with a BERT-level encoder trained via data distillation from GPT-4 for token classification. Task-agnostic compression — does not need a question prompt.
- **Performance:** 3×–6× faster than LLMLingua; surpasses LLMLingua on out-of-domain data.
- **Source:** https://llmlingua.com/llmlingua2.html

### Selective Context
- **Mechanism:** Small LM judges the self-information (surprisal) of each token. Tokens with low self-information (predictable/redundant) are pruned from the original prompt.
- **Performance:** ~36% GPU memory reduction, ~32% inference latency improvement, compression up to 32× with negligible quality loss.
- **Source:** NAACL 2025 survey; https://github.com/ZongqianLi/Prompt-Compression-Survey

### CompactPrompt (2025)
- **Mechanism:** End-to-end pipeline merging hard prompt compression with lightweight file-level data compression. Uses self-information scoring + dependency-based phrase grouping for token pruning; applies n-gram abbreviation to recurrent textual patterns in attached documents; applies uniform quantization to numerical columns.
- **Performance:** Reduces total token usage and inference cost by up to 60% on TAT-QA and FinQA benchmarks, with <5% accuracy drop.
- **Source:** https://arxiv.org/html/2510.18043v1

---

## 2. Soft Prompt Methods (Learned Compression)

### Gist Tokens / Gisting (Mu et al., NeurIPS 2023)
- **Mechanism:** Fine-tunes an LM to compress arbitrary prompts into a small set of "gist" tokens (special virtual tokens). Modified Transformer attention masks are used during training to force the model to encode the full prompt into these tokens. No additional training cost beyond standard instruction fine-tuning. Compressed gist tokens are cached and reused.
- **Performance:** Up to 26× prompt compression on LLaMA-7B and FLAN-T5-XXL; up to 40% FLOPs reduction; 4.2% wall-time speedup; zero-shot generalisation to unseen instructions.
- **Source:** https://arxiv.org/abs/2304.08467 | https://github.com/jayelm/gisting

### AutoCompressor
- **Mechanism:** Fine-tunes an LLM to iteratively compress long contexts into learned "summary vectors" through recurrent compression steps. Each step compresses a segment into a fixed pool of summary tokens, which are fed as prefix to subsequent steps.
- **Performance:** AutoCompressor-Llama-2-7b-6k achieves ~40× compression rate.
- **Source:** NAACL 2025 survey; https://github.com/ZongqianLi/Prompt-Compression-Survey

### ICAE (In-Context Autoencoder)
- **Mechanism:** Leverages a large LM's own weights to compress long contexts into short compact memory slots (~4× shorter). The memory slots are directly conditioned on by the target LM for downstream tasks. Introduces ~1% additional parameters via LoRA-style adaptation.
- **Performance:** ~4× context compression with ~1% parameter overhead.
- **Source:** https://openreview.net/forum?id=uREj4ZuGJE

### ATACompressor (SIGIR-AP 2025)
- **Mechanism:** Adaptive Task-Aware Compression. Three components: (1) a selective encoder compresses only task-relevant portions of long contexts into soft tokens; (2) an adaptive allocation controller infers relevant content length and dynamically adjusts compression rate (fewer tokens for short spans, more for long spans); (3) standard soft-prompt decoding.
- **Performance:** Outperforms existing methods on HotpotQA, MSMARCO, SQUAD.
- **Source:** https://arxiv.org/abs/2602.03226 | https://dl.acm.org/doi/10.1145/3767695.3769499

### xRAG (NeurIPS 2024)
- **Mechanism:** Extreme context compression for RAG. Reinterprets dense retrieval document embeddings as "retrieval modality features" and projects them directly into the LM's representation space using a cross-modal projector — reducing each retrieved document to a single token in the LM context.
- **Performance:** Single document token yields >10% improvement on 6 knowledge-intensive tasks. Reduces total FLOPs by 3.53× compared to uncompressed RAG.
- **Source:** https://arxiv.org/abs/2405.13792 | https://github.com/Hannibal046/xRAG

---

## 3. RAG-Specific Compression

### RECOMP
- **Mechanism:** Prepends learned compressed summaries (extractive or abstractive) to the LM. Two compressor variants: extractive (selects salient sentences) and abstractive (generates a compact summary). Compressors are trained for end-task improvement. May return empty summaries if retrieved context is judged irrelevant.
- **Source:** NAACL 2025 survey; https://github.com/ZongqianLi/Prompt-Compression-Survey

---

## 4. KV-Cache Compression

### H2O: Heavy-Hitter Oracle (NeurIPS 2023)
- **Mechanism:** KV-cache eviction policy exploiting the observation that cumulative attention scores follow a power-law distribution — a small subset of "heavy-hitter" tokens account for most attention weight. Policy: dynamically retain recent tokens + heavy-hitter tokens; evict the rest.
- **Performance:** With 20% heavy hitters retained: up to 29× throughput improvement over HuggingFace Accelerate and DeepSpeed on OPT-6.7B/30B. Attention-based heavy-hitter strategies significantly outperform other methods on reasoning tasks.
- **Source:** https://arxiv.org/abs/2306.14048

### StreamingLLM
- **Mechanism:** Observes that a few initial tokens act as "attention sinks" — the KV of these tokens must be kept permanently. Policy: permanently keep initial attention-sink tokens + sliding window of most recent tokens; evict everything between.
- **Source:** Referenced in H2O comparisons; https://arxiv.org/abs/2309.17453

### FreqKV (2025)
- **Mechanism:** Compresses KV cache states in the frequency domain. KV states exhibit strong energy concentration in low-frequency components; high-frequency parts are largely redundant and can be discarded. Enables context window extension.
- **Performance:** State-of-the-art on most long-context understanding tasks; strong gains on HotpotQA, 2WikiMQA, QMSum.
- **Source:** https://arxiv.org/abs/2505.00570

### WindowKV (2025)
- **Mechanism:** Task-adaptive KV-cache window selection. Dynamically selects local semantic windows (consecutive tokens) based on task-specific characteristics, ensuring the retained KV cache captures continuous, coherent context rather than scattered tokens.
- **Performance:** Maintains performance comparable to full KV cache while using only 12% of the original KV cache.
- **Source:** https://arxiv.org/abs/2503.17922

### xKV (2025)
- **Mechanism:** Cross-layer SVD compression. Applies Singular Value Decomposition to the KV-Cache of grouped layers, consolidating multiple layers' KV-Cache into a shared low-rank subspace.
- **Performance:** xKV-SR (keys+values on GPU): up to 4.23× end-to-end speedup. xKV-SR (keys only, values offloaded): 2.53% higher accuracy than SOTA and up to 3.23× speedup.
- **Source:** https://github.com/abdelfattah-lab/xKV | https://openreview.net/forum?id=CSooB1sE2m

### OmniKV (2025)
- **Mechanism:** Dynamic sparsity method. Selects tokens adaptively for sparse attention computation while retaining the full KV cache in memory (not evicting). Improves performance by recalling necessary tokens when needed.
- **Source:** Referenced in context compression surveys 2025.

### DeltaKV (2025)
- **Mechanism:** Residual-based KV cache compression via long-range similarity. Stores only delta (difference) representations between KV states that share high cosine similarity across long ranges.
- **Source:** https://arxiv.org/html/2602.08005

### HeteroCache (2025)
- **Mechanism:** Dynamic retrieval approach to heterogeneous KV cache compression. Treats KV cache management as a dynamic retrieval problem, enabling different compression policies for different layers.
- **Source:** https://arxiv.org/html/2601.13684

---

## 5. Agent-Oriented and Long-Horizon Compression

### ACON: Agent Context Optimization (2025)
- **Mechanism:** Unified framework for long-horizon LLM agents. Two-stage pipeline: (1) guideline optimization — a gradient-free pipeline uses LLMs as optimizers to iteratively refine natural-language compression guidelines through failure analysis; (2) distillation — compresses the large-LM compressor into a smaller model. Dynamically condenses environment observations and interaction histories.
- **Performance:** Reduces peak memory by 26–54%; small LM achieves 20–46% performance improvement after distillation.
- **Source:** https://arxiv.org/abs/2510.00615

### CCF: Context Compression Framework (2025)
- **Mechanism:** Hierarchical latent representations that preserve global semantics while reducing input redundancy. Integrates segment-wise semantic aggregation with key-value memory encoding for efficient long-sequence modeling.
- **Performance:** Competitive perplexity under high compression ratios; significantly improves throughput and memory efficiency.
- **Source:** https://arxiv.org/abs/2509.09199

### Adaptive Context Compression (2025, general research direction)
- **Mechanism:** Integrates importance-aware memory selection, coherence-sensitive filtering, and dynamic budget allocation to retain essential conversational information while controlling context growth across long-running agent interactions.
- **Source:** https://arxiv.org/html/2603.29193

---

## 6. Survey-Level Taxonomy (NAACL 2025)

The NAACL 2025 oral paper "Prompt Compression for Large Language Models: A Survey" (Li et al.) formally categorises methods into:
1. **Hard prompt methods** — Remove/paraphrase discrete tokens (Selective Context, LLMLingua family)
2. **Soft prompt methods** — Encode into learned continuous representations (Gisting, AutoCompressor, ICAE, ATACompressor)
3. **Hybrid/downstream adaptations** — Task-specific compression, attention optimisation, PEFT integration, synthetic compression languages

The survey also covers multimodal token compression and cross-lingual considerations.
- **Source:** https://aclanthology.org/2025.naacl-long.368/ | https://github.com/ZongqianLi/Prompt-Compression-Survey

---

## Key Takeaways

1. **LLMLingua-2** is the current best practical hard-prompt compressor: task-agnostic, 3–6× faster than v1, excels out-of-domain.
2. **xRAG** achieves the most extreme RAG compression (one token per document) via cross-modal embedding projection — a qualitatively different paradigm.
3. **KV-cache compression** (H2O, WindowKV, xKV, FreqKV) is increasingly the preferred production strategy because it operates transparently at inference time without modifying prompt structure.
4. **Soft prompt methods** (Gisting, ICAE, AutoCompressor) offer the best compression ratios but require fine-tuning and are model-specific.
5. **Agent-specific compression** (ACON) is an emerging area: gradient-free, failure-driven guideline optimisation is a novel mechanism distinct from token scoring.
6. **Dynamic/adaptive approaches** (ATACompressor, OmniKV, WindowKV) are outperforming static compression heuristics in 2025.

---

## Extracted Named Techniques (for Wave 2 index)

| Name | Category | Core Mechanism |
|------|----------|----------------|
| LLMLingua | Hard prompt | Perplexity-based coarse-to-fine token removal |
| LongLLMLingua | Hard prompt | Question-conditioned perplexity for long context |
| LLMLingua-2 | Hard prompt | GPT-4-distilled BERT encoder for task-agnostic token classification |
| Selective Context | Hard prompt | Self-information scoring; low-surprisal token pruning |
| CompactPrompt | Hard prompt + data | Self-info scoring + phrase grouping + n-gram abbreviation + quantisation |
| Gist Tokens (Gisting) | Soft prompt | Attention-masked fine-tuning into virtual gist tokens |
| AutoCompressor | Soft prompt | Iterative recurrent compression into learned summary vectors |
| ICAE | Soft prompt | LLM-native autoencoder into compact memory slots |
| ATACompressor | Soft prompt | Selective encoder + adaptive allocation controller |
| xRAG | Soft/embedding | Cross-modal projection of retrieval embeddings to single LM token |
| RECOMP | RAG-specific | Extractive/abstractive learned summarisation for RAG |
| H2O (Heavy-Hitter Oracle) | KV-cache | Power-law attention; retain recent + heavy-hitter KV entries |
| StreamingLLM | KV-cache | Attention sink tokens + recent sliding window |
| FreqKV | KV-cache | Frequency-domain KV compression; discard high-frequency redundancy |
| WindowKV | KV-cache | Task-adaptive consecutive semantic window selection |
| xKV | KV-cache | Cross-layer SVD into shared low-rank KV subspace |
| OmniKV | KV-cache | Dynamic sparse attention with full KV retention |
| DeltaKV | KV-cache | Residual/delta storage based on long-range similarity |
| HeteroCache | KV-cache | Dynamic retrieval-based heterogeneous per-layer policy |
| ACON | Agent compression | Gradient-free NL guideline optimisation via failure analysis + distillation |
| CCF | Sequence compression | Hierarchical latent representations + KV memory encoding |
| Adaptive Context Compression | Agent/chat | Importance-aware selection + coherence filtering + dynamic budget |

---

## Sources

1. [GitHub - microsoft/LLMLingua](https://github.com/microsoft/LLMLingua) — LLMLingua series source code and papers
2. [LLMLingua Series Homepage](https://www.llmlingua.com/) — LLMLingua, LongLLMLingua, LLMLingua-2 overview
3. [LLMLingua Microsoft Research Blog](https://www.microsoft.com/en-us/research/blog/llmlingua-innovating-llm-efficiency-with-prompt-compression/) — Official research blog
4. [LLMLingua arxiv](https://arxiv.org/abs/2310.05736) — Original EMNLP 2023 paper
5. [LLMLingua-2](https://llmlingua.com/llmlingua2.html) — LLMLingua-2 details
6. [Prompt Compression Survey NAACL 2025](https://aclanthology.org/2025.naacl-long.368/) — Comprehensive taxonomy
7. [Prompt Compression Survey GitHub](https://github.com/ZongqianLi/Prompt-Compression-Survey) — Survey code + reference list
8. [Prompt Compression Survey PDF](https://aclanthology.org/2025.naacl-long.368.pdf) — Full paper
9. [Gist Tokens arxiv](https://arxiv.org/abs/2304.08467) — Mu et al. NeurIPS 2023
10. [GitHub jayelm/gisting](https://github.com/jayelm/gisting) — Gist Tokens code
11. [ICAE OpenReview](https://openreview.net/forum?id=uREj4ZuGJE) — In-Context Autoencoder
12. [xRAG arxiv](https://arxiv.org/abs/2405.13792) — Extreme RAG compression, NeurIPS 2024
13. [xRAG GitHub](https://github.com/Hannibal046/xRAG) — xRAG code
14. [H2O arxiv](https://arxiv.org/abs/2306.14048) — Heavy-Hitter Oracle
15. [FreqKV arxiv](https://arxiv.org/abs/2505.00570) — Frequency-domain KV compression
16. [WindowKV arxiv](https://arxiv.org/abs/2503.17922) — Task-adaptive window selection
17. [xKV OpenReview](https://openreview.net/forum?id=CSooB1sE2m) — Cross-layer SVD KV compression
18. [xKV GitHub](https://github.com/abdelfattah-lab/xKV) — xKV code
19. [ACON arxiv](https://arxiv.org/abs/2510.00615) — Agent context optimisation
20. [CompactPrompt arxiv](https://arxiv.org/html/2510.18043v1) — Unified prompt + data compression
21. [ATACompressor arxiv](https://arxiv.org/abs/2602.03226) — Adaptive task-aware compression
22. [CCF arxiv](https://arxiv.org/abs/2509.09199) — Context compression framework
23. [DeltaKV arxiv](https://arxiv.org/html/2602.08005) — Residual KV compression
24. [HeteroCache arxiv](https://arxiv.org/html/2601.13684) — Heterogeneous KV compression
25. [Awesome LLM Compression GitHub](https://github.com/HuangOwen/Awesome-LLM-Compression) — Curated list
26. [Towards Data Science: Cut RAG Costs 80%](https://towardsdatascience.com/how-to-cut-rag-costs-by-80-using-prompt-compression-877a07c6bedb/) — Practical guide

## Methodology

Searched 6 queries across web. Analyzed 26+ sources.
Sub-questions investigated:
- LLMLingua family: LLMLingua, LongLLMLingua, LLMLingua-2 mechanisms and performance
- Survey taxonomy: hard vs soft prompt compression categories (NAACL 2025)
- Soft prompt methods: Gisting, AutoCompressor, ICAE, ATACompressor
- Embedding-based RAG compression: xRAG, RECOMP
- KV-cache compression: H2O, StreamingLLM, FreqKV, WindowKV, xKV, OmniKV, DeltaKV, HeteroCache
- Agent-oriented compression: ACON, CompactPrompt, CCF, Adaptive Context Compression
