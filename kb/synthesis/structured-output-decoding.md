# Structured Output and Constrained Decoding
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — structured-output-decoding-research.md

## Summary
Structured output / constrained decoding enforces schema conformity at the token generation level, guaranteeing that model output conforms to a specified grammar or JSON schema regardless of the model's probabilistic tendencies. Grammar-based engines intercept token sampling and mask out any token that would violate the current parse state. High-level APIs (Instructor, LMQL, Guidance) provide developer-facing abstractions over these low-level mechanisms. As of 2025, XGrammar and llguidance are the production-standard implementations.

## Core Mechanism
**Grammar-based engines:**
- **XGrammar:** PDA (pushdown automaton)-based constrained decoding. Splits vocabulary into context-independent tokens (always valid) and context-dependent tokens (valid only in certain parse states). Precomputes the context-independent mask, leaving only a small context-dependent lookup per token. Achieves under 40μs per token overhead; default backend in vLLM and SGLang; delivers approximately 2× latency reduction over naive constrained decoding.
- **llguidance:** Earley parser combined with regex-derivative lexer; lazy automata construction defers work until parse states are actually reached; approximately 50μs per token; credited as the implementation underlying OpenAI Structured Outputs.
- **Outlines/outlines-core:** FSM-based token masking with O(1) per-token overhead after preprocessing; widely adopted open-source library.
- **SynCode:** DFA mask store derived from language grammar; generates "accept sequences" that prune the token tree early; achieves 96% reduction in syntactic errors for Python and Go code generation.
- **Compressed FSM (SGLang):** Merges FSM states with identical future behavior and overlaps GPU mask computation with forward pass; approximately 2× latency reduction.
- **GreatGramma (ICML 2025):** Lexer-state-dependent vocabulary-to-CFG terminal mapping; 17.71× preprocessing speedup for new schemas.

**Distribution-preserving constraint:**
- **GAD (Grammar-Aligned Decoding):** Naive grammar masking distorts the model's probability distribution by zeroing out tokens and renormalizing, which can bias outputs. GAD uses importance-weighting to preserve the original LM distribution subject to the grammar constraint — outputs are both schema-valid and faithful to the model's learned distribution.

**High-level APIs:**
- **Instructor:** Pydantic model → JSON Schema → function-calling/tool-use pipeline with automatic retry on validation failure; supports 15+ providers including OpenAI, Anthropic, Gemini, Mistral, Cohere.
- **LMQL:** Query language integrating Python control flow with inline constraint annotations; enables conditional schema branching.
- **Guidance:** Python DSL that interleaves fixed output text with constrained sampling blocks; supports partial schema enforcement.

**Evaluation standard:**
- **JSONSchemaBench:** 10,000 real-world JSON schemas; evaluates six frameworks on efficiency, schema coverage, and output quality.

## Application in Skill Context
Use constrained decoding to guarantee structured JSON output from prompt enhancement pipelines. In practice:
- When the synthesis step must produce a specific schema (e.g., an epiphany output object, a KB entry, a plan structure), Instructor is the highest-leverage tool: define a Pydantic model, pass it to the Instructor-wrapped client, and get schema-validated output with automatic retry.
- For models that persistently resist schema adherence through inference-time constraints, Schema Reinforcement Learning (SRL) trains schema compliance via RL — a training-time solution when inference-time constraint enforcement is insufficient.
- When output distribution fidelity matters (not just validity), prefer GAD or llguidance over naive masking to avoid systematic biases introduced by hard renormalization.

Design principle for constrained output in skill pipelines: define the schema as the ground truth of what the skill must produce, then work backward to construct the prompt that generates valid content for each field. The constraint engine handles format; the prompt handles content quality.

## Key Variants / Parameters
- **PDA vs. FSM vs. Earley parser backend:** PDA (XGrammar) handles the full context-free grammar class; FSM handles regular grammars (sufficient for most JSON schemas); Earley handles ambiguous grammars
- **Preprocessing cost vs. per-token cost tradeoff:** GreatGramma reduces preprocessing (one-time schema compilation) at marginal per-token cost; useful when serving many different schemas
- **Retry strategy in Instructor:** `max_retries` parameter; with `mode=TOOLS` the error message from validation failure is fed back to the model as context for the retry
- **Partial vs. full schema enforcement:** Guidance allows enforcing only certain fields while leaving others unconstrained — useful when some fields benefit from freeform generation

## Related KB Entries
- [synthesis/mixture-of-agents.md](mixture-of-agents.md)
- [synthesis/cot-synthesis.md](cot-synthesis.md)
- [synthesis/knowledge-distillation.md](knowledge-distillation.md)
