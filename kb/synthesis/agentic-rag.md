# Agentic RAG
**Domain:** synthesis
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — agentic-rag-synthesis

## Summary
Agentic RAG extends standard retrieval-augmented generation by giving autonomous agents dynamic control over the retrieval process itself. Instead of a fixed retrieve-once pipeline, agents evaluate retrieved content quality, decompose multi-hop tasks into retrieval plans, select from multiple backends, and collaborate across specialized retrieval and synthesis roles. The strategy adapts to what the task demands rather than executing a predetermined sequence.

## Core Mechanism
Four design patterns define Agentic RAG: (1) Reflection — the agent evaluates whether retrieved content is sufficient and re-retrieves if not, looping until quality thresholds are met; (2) Planning — the agent decomposes complex synthesis tasks into an explicit retrieval plan with ordered sub-queries; (3) Tool Use — the agent selects from multiple retrieval backends at runtime (dense vector search, BM25 keyword search, knowledge graph traversal) based on query type; (4) Multi-Agent Collaboration — separate specialized agents handle retrieval and synthesis, with the synthesis agent receiving pre-processed context. Meta-prompting is a key technique within this pattern: one LLM cleans or summarizes retrieved context before it reaches the synthesis LLM, preventing noise propagation. Hybrid retrieval combining dense + BM25 + KG traversal consistently outperforms any single method in research benchmarks.

## Application in Skill Context
In a prompt engineering skill, Agentic RAG applies when the skill must assemble knowledge from multiple KB domains before generating output. The skill should implement a reflection loop — after an initial KB query, check whether the retrieved entries adequately cover the target concept, and issue follow-up queries if coverage is insufficient. Tool Use pattern applies when the skill has access to both a vector KB and a structured index: select the backend based on whether the query is conceptual (vector) or lookup-style (index). The sycophancy cascade risk is directly relevant: if a multi-agent skill passes retrieved context between sub-agents without independent evaluation, early retrieval errors compound. Each sub-agent should evaluate context independently before synthesis.

## Key Variants / Parameters
- **Reflection depth**: number of re-retrieval iterations before accepting results (typical: 1–3)
- **Backend selection policy**: rule-based (query type determines backend) vs. LLM-routed (router LLM selects backend)
- **Meta-prompt compression level**: full summarization vs. light cleaning before passing context to synthesis LLM
- **Collaboration topology**: sequential pipeline (retriever → cleaner → synthesizer) vs. parallel specialized agents with aggregation

## Related KB Entries
- synthesis/lost-in-middle.md
- synthesis/cot-synthesis.md
- enhancement/rag-prompting.md
