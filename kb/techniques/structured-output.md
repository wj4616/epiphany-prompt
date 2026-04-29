# Structured Output Prompting
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — structured-output research report

## Summary
Structured Output Prompting constrains LLM generation to machine-parseable formats — JSON, XML, or YAML — making model outputs directly consumable by downstream code without post-hoc parsing or error recovery. A four-layer approach (schema definition, one perfect example, strict formatting rules, self-validation instruction) reliably produces well-formed outputs. At the infrastructure level, Constrained Decoding suppresses schema-violating tokens during generation, guaranteeing format compliance rather than merely encouraging it. As of 2025, XGrammar (the default constrained decoding backend in vLLM and SGLang) achieves up to 2x latency reduction compared to earlier constrained decoding systems.

## Core Mechanism
The four-layer prompting approach operates as follows: (1) The JSON schema (or equivalent) is defined in the prompt, specifying field names, types, and required vs. optional fields; (2) One complete, perfect example output is provided in the prompt, demonstrating the target structure concretely; (3) Strict formatting rules are stated explicitly ("do not add fields not in the schema," "all string values must be non-empty," "output only the JSON object with no surrounding text"); (4) A self-validation instruction asks the model to verify its output before emitting it ("Before outputting, verify that your JSON matches the schema and all required fields are present"). Temperature is set to 0.0–0.1 to maximize determinism in format adherence. At the pipeline level, the flow is: Prompt → Generate → Validate (schema check) → Repair (re-prompt with error context if invalid) → Parse. Constrained Decoding enforces compliance at the token level using formal grammars (EBNF/GBNF), making format violations structurally impossible rather than statistically unlikely. Schema Reinforcement Learning (SRL) trains compliance via reward signals on schema adherence, improving model-level compliance without decoding-time constraints.

## Application in Skill Context
In a prompt engineering skill, structured output is required at every stage boundary in a prompt chain where the output will be consumed programmatically. The skill defines a JSON schema for each stage's output, embeds it in the stage prompt with a worked example, and runs schema validation after each generation before passing output to the next stage. If validation fails, the skill invokes a repair prompt that includes the original output and the specific validation error, asking the model to fix only the structural issue without changing the content. For epiphany-style skills that produce complex multi-field outputs (e.g., technique recommendations with confidence scores and rationale), structured output ensures every downstream consumer receives consistently shaped data. The self-validation instruction layer is especially important for complex nested schemas — without it, models frequently omit required nested fields.

## Key Variants / Parameters
- **Prompt-based structured output**: schema + example + rules + self-validation; works without infrastructure changes
- **Constrained Decoding**: token-level suppression of schema-violating tokens; requires compatible inference backend
- **XGrammar**: default constrained decoding in vLLM/SGLang as of 2025; up to 2x latency reduction
- **EBNF/GBNF grammar-based decoding**: formal grammar specification; most expressive constraint definition
- **Schema Reinforcement Learning (SRL)**: RL-trained schema compliance at model level; most robust, requires training
- **Temperature**: 0.0–0.1 for format-critical outputs; higher temperatures risk format drift

## Related KB Entries
- [few-shot-prompting.md](few-shot-prompting.md)
- [prompt-chaining.md](prompt-chaining.md)
- [context-engineering.md](context-engineering.md)
- [dspy-framework.md](dspy-framework.md)
