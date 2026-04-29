# Context Engineering
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — context-engineering research report

## Summary
Context Engineering, emerging as the dominant paradigm in 2026, is the discipline of strategically constructing and placing all information in an LLM's context window — system instructions, retrieved documents, tool schemas, memory, conversation history, and metadata. It supersedes "prompt engineering" as a framing because it recognizes that the full context window, not just the instruction text, determines model behavior. A critical empirical finding is that information placement within the context window has a large impact on accuracy: content at the beginning and end is recalled most accurately, while information buried in the middle suffers accuracy drops of 30% or more ("lost in the middle" effect).

## Core Mechanism
The context window is treated as a structured document with defined regions, each with different retrieval salience. High-priority information (core instructions, key constraints) must be anchored at the start or end of the context. Retrieved knowledge (RAG content) must be positioned relative to the question it answers, not arbitrarily inserted. Tool schemas must be compact enough not to crowd out task content. A four-level maturity pyramid defines increasingly sophisticated practice: (1) Prompt Engineering — single instruction crafting; (2) Context Engineering — full-window strategic construction; (3) Intent Engineering — modeling the user's underlying goal to construct appropriate context; (4) Specification Engineering — formal declarative specifications that generate context programmatically. Practical calibration: core instructions perform best at 150–300 words; performance degrades measurably beyond approximately 3,000 tokens in reasoning-heavy prompts due to attention dilution.

## Application in Skill Context
A prompt engineering skill must apply context engineering discipline to every prompt it constructs. This means: placing the most critical task instructions at the beginning of the system prompt (not buried after background text), placing examples and supporting material in the middle, and ending with the strongest behavioral constraint or output format specification. When a skill retrieves KB entries for a task, those entries are positioned immediately before the user query that requires them. For multi-stage skill pipelines, each stage's context is constructed fresh — prior-stage outputs are summarized and re-anchored rather than appended verbatim to avoid center-burial. The 150–300 word instruction budget is a design constraint for skill system prompts: beyond this, instructions should be restructured into examples or tool schemas rather than extended prose.

## Key Variants / Parameters
- **Information placement**: beginning and end for highest salience; middle for lower-priority background
- **Instruction budget**: 150–300 words for core instructions; hard cap around 3,000 tokens for reasoning-heavy contexts
- **Maturity levels**: Prompt Engineering → Context Engineering → Intent Engineering → Specification Engineering
- **"Lost in the middle" mitigation**: repeat critical constraints at both start and end of long contexts

## Related KB Entries
- [meta-prompting.md](meta-prompting.md)
- [dspy-framework.md](dspy-framework.md)
- [structured-output.md](structured-output.md)
- [prompt-chaining.md](prompt-chaining.md)
