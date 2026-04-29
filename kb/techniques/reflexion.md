# Reflexion
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — reflexion research report

## Summary
Reflexion extends the ReAct framework with self-evaluation and episodic linguistic memory, enabling iterative improvement across task attempts without any model weight updates. After each task attempt, a dedicated Evaluator component scores the outcome, and a Self-Reflection component generates a verbal reflection — a natural language analysis of what went wrong and how to improve. This reflection is stored in a memory buffer and prepended to the prompt on the next attempt, effectively creating a learning loop within the context window. Reflexion is particularly effective for code generation and sequential decision-making tasks.

## Core Mechanism
Reflexion has three interacting components. The Actor generates actions using a standard ReAct or CoT reasoning process. The Evaluator receives the Actor's output and scores it against a success criterion — this can be a heuristic function, a test suite, or a separate LLM judge. The Self-Reflection component takes the Actor's trajectory and the Evaluator's score and generates a verbal analysis: what reasoning steps were flawed, what information was missing, what strategy should be tried instead. This reflection is stored in an episodic memory buffer (a short text store in the context). On the next attempt, the buffer contents are prepended to the system prompt, making prior failure analysis available to the Actor without modifying model weights. Multi-Agent Reflexion (MAR) replaces self-critique with cross-agent critique: multiple agents independently evaluate each other's reasoning, reducing self-bias and generating more diverse improvement signals.

## Application in Skill Context
In a prompt engineering skill, Reflexion is applied to any iterative refinement loop where quality can be evaluated programmatically or via a judge prompt. The skill runs an initial generation, scores the output (schema validation, rubric evaluation, or test execution), generates a verbal reflection on any failures, and reruns the generation with the reflection in context. This is especially valuable for: structured output tasks where validation reveals specific schema violations, code generation where test failures provide precise error signals, and multi-step reasoning tasks where a judge prompt can identify the specific flawed step. The key implementation requirement is a well-defined Evaluator — without a reliable scoring mechanism, the reflection loop has no signal to learn from. Maximum of 2–3 reflection iterations is typically sufficient; beyond this, context length and diminishing returns limit value.

## Key Variants / Parameters
- **Standard Reflexion**: single Actor with Evaluator and Self-Reflection; requires defined success criterion
- **Multi-Agent Reflexion (MAR)**: multiple agents critique each other; reduces self-bias, generates diverse improvement signals
- **Memory buffer size**: typically 1–3 most recent reflections kept in context; older reflections dropped to manage context length
- **Evaluator types**: heuristic function, test suite execution, or LLM-as-judge prompt

## Related KB Entries
- [react-framework.md](react-framework.md)
- [self-refine.md](self-refine.md)
- [tree-of-thoughts.md](tree-of-thoughts.md)
- [chain-of-thought.md](chain-of-thought.md)
