# CodeAct
**Domain:** synthesis
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — codeact

## Summary
CodeAct (ICML 2024) uses executable Python code as the unified action space for LLM agents, replacing the fragmented tool-call JSON formats used by ReAct. Every agent action is expressed as executable Python code run in a stateful interpreter, with outputs streaming back as observations. Research shows CodeAct outperforms both text-action and JSON-action agents on agentic benchmarks by enabling complex multi-step operations in a single action and accumulating state across turns.

## Core Mechanism
The model generates Python code for every action — tool invocations, data manipulation, branching logic, loops — rather than emitting structured JSON tool-call payloads. Code executes in a persistent stateful Python interpreter: variables, imported modules, and intermediate results persist across turns without re-transmission. This eliminates the need to define separate tool schemas for each capability; arbitrary Python expressions compose existing tools.

Three key advantages over JSON-action agents: (1) Multi-step operations expressible in a single code block (e.g., load file, parse, filter, transform, call API, format output — all one action); (2) State accumulates in interpreter variables across conversation turns, avoiding context re-injection of prior results; (3) No schema definition overhead — any importable Python library is immediately available as a "tool."

## Application in Skill Context
In a prompt engineering skill, CodeAct enables the agent to treat the entire prompt optimization loop as executable code. Concretely: the agent can write Python scripts that load prompt templates from the KB, run evaluation functions against test cases, apply transformation functions (e.g., add chain-of-thought scaffolding, inject few-shot examples), score outputs, and log results — all within a single stateful interpreter session. This eliminates the round-trip overhead of separate tool calls for each operation and allows the agent to express conditional logic ("if score < threshold, apply variant B") as native Python control flow rather than as meta-instructions to the orchestrator.

## Key Variants / Parameters
- **Interpreter persistence:** stateful across turns (default); stateless (reset per turn, for isolation)
- **Library access:** any installed Python package is available; scope can be restricted for sandboxing
- **Action granularity:** single-line expressions for simple lookups; multi-line scripts for compound operations
- **Output streaming:** interpreter stdout streams back as observations, enabling reactive multi-turn loops
- **Comparison baseline:** ReAct (interleaved JSON tool calls) — CodeAct preferred when operations are composable and stateful; ReAct preferred when tool schemas are externally fixed

## Related KB Entries
- techniques/rewoo.md
