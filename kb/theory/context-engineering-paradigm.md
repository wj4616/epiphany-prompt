# Context Engineering Paradigm
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — context-engineering-paradigm

## Summary
Context Engineering is the 2026 paradigm shift that moves beyond crafting individual prompt instructions to designing the entire information assembly system that populates a model's context window. Rather than asking "what instructions should I write?", context engineers ask "what information should be present, where in the window, and how should it be assembled from retrieval, memory, tools, and metadata?" The central problem it addresses is the "lost in the middle" degradation — information buried in the center of long contexts loses 30%+ accuracy due to causal attention mechanics and positional encoding biases.

## Core Mechanism
A four-level maturity pyramid describes the progression of the discipline: (1) **Prompt Engineering** — individual instruction crafting; (2) **Context Engineering** — full information assembly system combining system instructions, RAG-retrieved content, tool schemas, memory summaries, and structured metadata; (3) **Intent Engineering** — encoding organizational goals, value hierarchies, and behavioral contracts into the context rather than per-prompt instructions; (4) **Specification Engineering** — machine-readable corporate policy corpora enabling autonomous multi-agent systems to self-govern. Practical guidelines derived from empirical studies: 150–300 words is optimal for core instruction density; reasoning-heavy prompts degrade beyond approximately 3,000 tokens; critical information must appear at the beginning or end of the context window to avoid positional loss. The Model Context Protocol (MCP), introduced by Anthropic in 2024–2026, is emerging as the standard interface for agent-tool context exchange, defining how tools advertise their schemas to agents.

## Application in Skill Context
When engineering prompts for an AI agent skill, applying context engineering means: (1) placing the most critical behavioral instructions at the very start of the system prompt; (2) keeping total instruction weight under 3,000 tokens before adding retrieved content; (3) structuring RAG-injected material to appear at the end of the context, after instructions; (4) using MCP-compatible tool schema formats for agent skills that invoke tools. For iterative refinement tasks, this means the skill should actively manage what goes into context at each step, not just emit a longer prompt.

## Key Variants / Parameters
- **Retrieval-Augmented Generation (RAG):** Dynamically injects retrieved documents into context; quality depends on retrieval precision and placement position within the window.
- **Sliding window / truncation strategies:** When context budget is exceeded, determines which content is dropped — recency bias or relevance scoring.
- **Memory compression:** Episodic and semantic memories summarized to fit in early context slots.
- **MCP tool schemas:** Structured JSON descriptions of callable tools injected into context; schema verbosity directly consumes token budget.

## Related KB Entries
- `theory/prompt-engineering-foundations.md`
- `theory/in-context-learning.md`
- `theory/synthesis-failure-modes.md`
- `cross-references/unified-pe-ideation-synthesis.md`
