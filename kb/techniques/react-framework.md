# ReAct Framework
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — react-framework research report

## Summary
ReAct (Reasoning + Acting), introduced by Yao et al. (2022), interleaves natural language reasoning with external tool actions in a repeating Thought → Action → Observation cycle. The model reasons in plain language about what to do next (Thought), selects and executes a tool action (Action), receives the result from the tool (Observation), and reasons again. By grounding reasoning steps in real external information, ReAct prevents the compounding hallucination that occurs when a model reasons entirely from memory. It is the architectural foundation of most modern agentic AI systems.

## Core Mechanism
Each ReAct step is a structured exchange: the model emits a Thought that explains its current intent, then emits an Action (a structured tool call such as search, calculate, or look up), and receives an Observation (the tool's return value). The Observation is not model-generated — it is real external data injected into the context, which constrains the next Thought to be grounded. This is the key distinction from pure Chain-of-Thought: CoT reasoning stays inside the model's parametric knowledge; ReAct reasoning is continuously updated by external facts. Common action types include web search, code execution, database lookup, and calculator. Reflexion extends ReAct by adding a self-evaluation and episodic memory layer on top of the action loop — after a task attempt, the model writes a verbal reflection that is prepended to the next attempt's context.

## Application in Skill Context
In a prompt engineering skill, ReAct is applied when the skill needs to use tools mid-generation — for example, retrieving KB entries during synthesis, validating outputs against an external schema, or performing calculations within a reasoning chain. The skill structures its system prompt to elicit Thought/Action/Observation format, then the harness intercepts Action emissions to route them to actual tool calls. For epiphany-style skills that use multi-source KB retrieval, ReAct ensures retrieved evidence is explicitly cited in Thought steps before conclusions are drawn. The Reflexion extension is valuable in iterative skill loops: after generating a first-pass output, the skill runs a self-evaluation prompt and injects that reflection into a refinement pass.

## Key Variants / Parameters
- **Standard ReAct**: Thought/Action/Observation cycle; requires tool-calling infrastructure
- **ReAct with memory**: conversation history or retrieved memories added to context at each step
- **Reflexion**: adds Evaluator and Self-Reflection components on top of Actor; enables learning across attempts without weight updates
- **Multi-Agent Reflexion (MAR)**: multiple agents critique each other instead of self-critiquing; reduces self-bias

## Related KB Entries
- [chain-of-thought.md](chain-of-thought.md)
- [reflexion.md](reflexion.md)
- [tree-of-thoughts.md](tree-of-thoughts.md)
- [prompt-chaining.md](prompt-chaining.md)
