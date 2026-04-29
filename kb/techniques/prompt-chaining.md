# Prompt Chaining
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — prompt-chaining research report

## Summary
Prompt Chaining (also called Workflow Prompting) decomposes a complex task into a sequence of specialized LLM calls where the output of each call feeds as structured input to the next. Each step in the chain is a focused prompt optimized for one sub-task — rather than asking a single prompt to do everything, the chain assigns each stage to a prompt that can be independently tuned and validated. This enables multi-step tasks that exceed single-prompt capability limits and allows each stage to use the optimal technique (Few-Shot, CoT, Structured Output) for its specific sub-task. Common patterns include linear pipelines, conditional branching, parallel fan-out, and saga (event-driven) chains.

## Core Mechanism
In a linear chain, each step transforms its input into a structured intermediate output that becomes the next step's input — for example: (1) extract key claims from documents → (2) evaluate each claim against criteria → (3) synthesize evaluated claims into a final report. In branching chains, the output of one step is inspected to select which downstream prompt to invoke — enabling conditional routing based on content type, quality score, or detected intent. Parallel chains fan out a single input to multiple independent specialized prompts simultaneously, then aggregate their outputs. Saga chains are event-driven: each step emits events that trigger downstream steps asynchronously, suitable for distributed multi-agent workflows. The critical design challenge is error propagation: a factual or formatting error in step 1 can corrupt all downstream steps, so each step boundary should include validation and error handling. Prompt chaining is the structural backbone of frameworks such as LangChain and LangGraph.

## Application in Skill Context
In a prompt engineering skill, prompt chaining is the primary structural pattern for any multi-stage workflow. A skill that takes a user brief and produces an optimized prompt might chain: (1) intent extraction prompt → (2) technique selection prompt → (3) prompt assembly prompt → (4) quality evaluation prompt → (5) revision prompt. Each stage can be independently developed, tested, and replaced without rebuilding the whole skill. The branching pattern is used when inputs require different treatment — for example, routing creative tasks to a role-prompting stage and factual tasks to a RAG-augmented stage. Error propagation is mitigated by inserting structured output validation between stages: if step N's output fails schema validation, the chain halts and reports the specific failure point rather than silently propagating corrupted data.

## Key Variants / Parameters
- **Linear chain**: fixed sequential pipeline; simplest, easiest to debug
- **Branching chain**: conditional routing based on prior output content or quality; requires routing logic
- **Parallel chain**: fan-out to N independent prompts, then aggregation; increases throughput, requires output merging
- **Saga chain**: event-driven distributed workflow; most complex, suitable for long-running or async tasks
- **Error propagation mitigation**: schema validation gates between stages; halt-and-report on validation failure

## Related KB Entries
- [react-framework.md](react-framework.md)
- [meta-prompting.md](meta-prompting.md)
- [structured-output.md](structured-output.md)
- [reflexion.md](reflexion.md)
