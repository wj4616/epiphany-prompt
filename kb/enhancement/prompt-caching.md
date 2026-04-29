# Prompt Caching
**Domain:** enhancement
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — prompt-caching

## Summary
Prompt caching is an API-level optimization where the key-value (KV) computation for static prompt prefixes is cached and reused across multiple requests, avoiding redundant computation. Stable content — system instructions, reference documents, tool schemas — placed at the start of the prompt is cached on first use; subsequent calls with the same prefix pay only for the dynamic suffix. Anthropic's 2024 implementation reports 90% cost reduction and 85% latency reduction for cached tokens. Skills with large fixed instruction sets benefit disproportionately, since the static skill text is computed once and the per-request cost covers only the user's input.

## Core Mechanism
The caching mechanism operates at the KV attention cache layer: when a prompt prefix up to a designated cache point is submitted, the API computes and stores the key-value pairs for every attention head across every layer for those tokens. On subsequent requests that share the same prefix, the stored KV pairs are retrieved rather than recomputed. The cache is keyed by the exact token sequence of the prefix — any modification to the prefix invalidates the cache. The practical consequence is that prompt structure determines caching behavior: static content must precede dynamic content. A well-structured cacheable prompt has three zones: (1) fixed core — full system instructions, KB entries, tool schemas, all identical across requests; (2) dynamic injection zone — per-request context, user-specific state; (3) user input — the actual request content. The fixed core is cached; zones 2 and 3 are computed fresh per request. Prompt compression (LLMLingua) can increase the effective benefit of caching by reducing the token count of the cached prefix, lowering both the cache population cost and the storage overhead.

## Application in Skill Context
Skills with large stable instruction sets — including epiphany-omnipotent and any skill that injects multiple full KB entries — should be structured to maximize cache hit rate. The complete skill instruction text (persona, methodology, output format, all fixed KB entries) should occupy the prompt prefix before any user-specific content appears. Dynamic elements — the specific prompt being improved, session context, per-request KB entries selected for this input — should be placed at the end. This ordering is not merely a best practice: in prompt engineering skill design it is a structural requirement. A skill that interleaves static and dynamic content, or that places the user's input before the full system instructions, will fail to achieve cache hits and incur full computation cost on every request. For multi-turn skill sessions, the static prefix should remain identical across turns; only the conversation history (appended at the end) changes.

## Key Variants / Parameters
- **Cache boundary placement**: end of system prompt vs. end of first large static block vs. explicit cache_control markers (Anthropic API)
- **Cache granularity**: single cache point (all-or-nothing) vs. multi-point (nested cache zones for partially-static prompts)
- **TTL (time to live)**: session-scoped (cache cleared between sessions) vs. persistent (cache survives across sessions, provider-dependent)
- **Interaction with compression**: compress before caching (smaller cache, lower hit cost) vs. cache uncompressed (faster hit retrieval, higher storage)

## Related KB Entries
- enhancement/rag-prompting.md
- enhancement/automatic-prompt-optimization.md
