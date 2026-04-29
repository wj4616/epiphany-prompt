# ReWOO
**Domain:** synthesis
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — rewoo

## Summary
ReWOO (Reasoning WithOut Observation) decouples planning from observation in ReAct-style agentic reasoning, achieving 5x token efficiency over standard ReAct on multi-step tasks. The core problem it solves is that standard ReAct creates serial bottlenecks by requiring the model to pause and wait for each tool result before planning the next step, wasting tokens re-reading accumulated context. ReWOO generates a complete upfront plan, executes all tool calls in parallel, then synthesizes results.

## Core Mechanism
Three-component pipeline: (1) Planner LLM generates a complete multi-step plan upfront — all anticipated tool calls are laid out in advance with outputs referenced as symbolic variables (#E1, #E2, #E3, etc.) before any tool is called; (2) Worker executes all planned tool calls in parallel, substituting each #En variable with the actual result; (3) Solver LLM receives the completed variable-substituted plan and all results, then synthesizes the final answer.

The symbolic variable referencing system is the enabling mechanism: the Planner can write "#E2 = SearchTool(query derived from #E1)" even before #E1 exists, because the Worker resolves dependencies in topological order during parallel execution. Token efficiency gain comes from eliminating the interleaved observation-rereading cycles of ReAct.

Fundamental limitation: ReWOO cannot handle tasks where step N's plan genuinely depends on step N-1's result in a way that cannot be anticipated — adaptive or exploratory reasoning requires ReAct's interleaved approach instead.

## Application in Skill Context
Use ReWOO for well-structured multi-step prompt engineering workflows where the sequence of operations is predictable in advance. Example pipeline: Planner emits — #E1 = AnalyzeTool(prompt), #E2 = KB_Lookup(issues from #E1), #E3 = BestPracticeSearch(domain from #E1), #E4 = ProposeTool(#E1, #E2, #E3). Worker runs #E1, #E2, #E3 in parallel (where independent), then resolves #E4. Solver synthesizes. This is appropriate when the prompt engineering task is routine enhancement; switch to ReAct-style interleaved reasoning when the task is exploratory or when intermediate results may invalidate the original plan.

## Key Variants / Parameters
- **Planner model:** can be a smaller/cheaper model than Solver; separation enables cost optimization
- **Variable reference syntax:** #E1, #E2, ... (symbolic placeholders resolved by Worker)
- **Parallelism scope:** Worker executes all independent tool calls in parallel; dependent calls execute in topological order
- **Fallback to ReAct:** when step dependencies are not anticipatable upfront

## Related KB Entries
- techniques/codeact.md
