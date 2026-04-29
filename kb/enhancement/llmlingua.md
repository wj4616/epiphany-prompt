# LLMLingua (Prompt Compression via Perplexity Scoring)
**Domain:** enhancement
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — llmlingua

## Summary
LLMLingua is a token-level prompt compression system developed by Microsoft that uses a small surrogate language model to score each token's redundancy and removes low-information tokens up to a target compression ratio. It achieves up to 20x compression with minimal quality loss by preserving high-perplexity (surprising, information-dense) tokens while dropping predictable, redundant ones. Extensions address long-context RAG degradation (LongLLMLingua), and a distilled BERT-based variant (LLMLingua-2) removes the need for internal LM probabilities entirely.

## Core Mechanism
LLMLingua operates in a coarse-to-fine pipeline. Coarse stage: the prompt is segmented into units (sentences, clauses, or retrieved document chunks); each segment is scored for overall importance using the surrogate LM's perplexity on the segment given the context. Segments below an importance threshold are dropped or compressed more aggressively. Fine stage: within retained segments, each token's conditional perplexity is computed — how surprising the token is given all preceding tokens. Tokens with low perplexity (easily predicted from context, therefore redundant) are removed up to the target compression ratio. The final compressed prompt is reassembled from surviving tokens. LongLLMLingua adds a question-conditioning step: perplexity is computed not just on the passage in isolation but contrastively — comparing the token's perplexity given the passage versus given the question, so tokens that are relevant to the query are preferentially retained even if they are locally common words. LLMLingua-2 replaces the perplexity-based scorer with a binary token-classification model distilled from GPT-4 annotations; it is 3–6x faster than LLMLingua-1, task-agnostic, and requires no access to internal LM log-probabilities. RAG integration benchmark: 21.4% performance gain over uncompressed RAG at one-quarter the token cost when LLMLingua is applied to retrieved context before synthesis. Beyond LLMLingua: Gist Tokens uses attention-masked fine-tuning to compress prompts into learned virtual token vectors (26x compression but requires model fine-tuning); AutoCompressor performs iterative recurrent compression into summary vectors (40x compression, also requires fine-tuning).

## Application in Skill Context
LLMLingua compression applies directly to the epiphany-prompt skill whenever multiple long KB entries are injected as retrieved context. Long injected contexts cause two problems: token cost and lost-in-middle degradation (the model down-weights information from the middle of a long context window). LLMLingua mitigates both. The practical integration path: before assembling the synthesis prompt, run each retrieved KB entry through LLMLingua-2 at a 0.5–0.7 compression ratio (retaining 50–70% of tokens), then concatenate the compressed entries. Use LongLLMLingua's question-conditioning mode when the user's query is specific — pass the query as the conditioning question so tokens relevant to that query are retained preferentially. Do not apply LLMLingua to the instruction section of the prompt — only to retrieved context blocks. For very long KB entries (over 1000 tokens), apply coarse-stage filtering first (drop the least relevant segments entirely) before fine-grained token compression.

## Key Variants / Parameters
- **Variant**: LLMLingua-1 (perplexity-based, requires surrogate LM access) vs. LLMLingua-2 (distilled classifier, no LM internals needed, 3–6x faster)
- **Compression ratio**: target fraction of tokens to retain (0.3 = aggressive, 0.5–0.7 = typical, 0.8 = light)
- **Question conditioning**: disabled (LLMLingua-1 base) vs. enabled (LongLLMLingua, contrastive perplexity against query)
- **Granularity**: coarse-only (segment-level), fine-only (token-level), or coarse-to-fine (recommended)
- **Scope**: apply to retrieved context only vs. full prompt (apply to context only — instruction sections should not be compressed)

## Related KB Entries
- enhancement/rag-prompting.md
- synthesis/agentic-rag.md
- synthesis/lost-in-middle.md
- enhancement/prompt-caching.md
