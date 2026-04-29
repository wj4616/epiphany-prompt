# DSPy Framework
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** medium
**Source:** Wave 1 — dspy-framework research report

## Summary
DSPy (Declarative Self-Improving Python), released by Stanford in 2023, reframes prompt engineering as a programming problem: the developer declares typed input/output signatures for each LLM call, and DSPy's compilers automatically discover optimal prompts and few-shot demonstrations from labeled data. Instead of writing prompt strings by hand, the developer writes programs composed of typed modules, and DSPy treats the prompts as compiled artifacts that are optimized against a task metric. This abstraction can improve accuracy from approximately 46% to 64% on standard benchmarks without manual prompt iteration.

## Core Mechanism
The developer specifies each LLM call as a signature: a typed declaration of input fields and output fields with short descriptions. DSPy's optimizer then searches the joint space of instruction variants and demonstration examples to find the combination that maximizes the program's score on a development set. Key optimizers: MIPROv2 applies Bayesian Optimization over the instruction and demonstration space simultaneously, using data-awareness (which examples are most informative) and demonstration-awareness (which demonstrations transfer best). COPRO performs coordinate ascent over instruction variants, improving one module at a time. BootstrapFewShot automatically generates labeled demonstrations by running the program on training inputs and bootstrapping from correct outputs. BetterTogether is a meta-optimizer that jointly optimizes prompt instructions and model fine-tuning weights, bridging prompt optimization and training.

## Application in Skill Context
In a prompt engineering skill context, DSPy is most applicable when: (a) a skill has a defined evaluation metric (e.g., structured output schema compliance, human preference score), (b) a labeled dataset of desired input-output pairs exists or can be bootstrapped, and (c) the skill undergoes iterative improvement over time. Rather than manually revising skill prompts based on observed failures, the skill author defines a DSPy program and runs MIPROv2 to generate an optimized prompt automatically. For epiphany-style skills that run across many sessions and accumulate examples of good and poor outputs, DSPy provides a systematic path to compiling improved prompt versions. Without a metric and dataset, DSPy's compilers cannot operate — the technique requires upfront investment in evaluation infrastructure.

## Key Variants / Parameters
- **MIPROv2**: Bayesian Optimization over instructions + demonstrations; highest quality optimizer; requires labeled data
- **COPRO**: coordinate ascent over instruction variants; lower data requirements
- **BootstrapFewShot**: generates demonstrations from labeled training data automatically
- **BetterTogether**: meta-optimizer combining prompt optimization with model fine-tuning; most powerful, most expensive
- **Typed signatures**: input/output type declarations that constrain the search space for optimization

## Related KB Entries
- [few-shot-prompting.md](few-shot-prompting.md)
- [meta-prompting.md](meta-prompting.md)
- [context-engineering.md](context-engineering.md)
- [structured-output.md](structured-output.md)
