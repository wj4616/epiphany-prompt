# GEPA / EvoPrompt (Genetic-Evolutionary Prompt Optimization)
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — gepa-evolutionary

## Summary
GEPA (Genetic-Pareto Evolutionary Prompt Architect) and the foundational EvoPrompt (ICLR 2024) apply genetic algorithm principles to prompt optimization by maintaining a population of prompt candidates and evolving them through LLM-operated mutation and crossover operators. GEPA extends EvoPrompt with multi-objective Pareto-front selection that simultaneously optimizes for accuracy and efficiency. Population-based search escapes local optima that single-trajectory gradient methods (OPRO, ProTeGi) cannot, making evolutionary methods the preferred choice when the prompt search space has many local maxima. PromptBreeder adds self-referential mutation where both the task-prompt and the mutation-prompt itself evolve. GEPA received ICLR 2026 oral recognition and has been integrated into DSPy's optimizer suite.

## Core Mechanism
EvoPrompt initializes a population of N prompt candidates, either randomly generated or seeded from APE. Each generation proceeds as follows: (1) Fitness evaluation — each candidate is scored on a held-out task sample; (2) Parent selection — candidates are selected proportionally to fitness score (roulette selection) or by tournament; (3) Genetic operations — an LLM serves as the evolutionary operator: for mutation, it receives one parent and is instructed to produce a variant that preserves the core intent while changing wording, structure, or specificity; for crossover, it receives two parents and produces an offspring that combines their effective elements; (4) Offspring evaluation — new candidates are scored; (5) Next-generation selection — the new population is formed by retaining the top candidates. GEPA replaces single-objective fitness ranking with Pareto-front selection: candidates are evaluated on both accuracy and token efficiency, and the Pareto front (candidates that cannot be improved on one dimension without worsening another) forms the elite population. PromptBreeder makes mutation self-referential: the mutation-prompt ("here is a prompt, make it better by...") is itself a member of the evolving population, so the evolutionary operator improves itself over generations. CAPO (Cost-Aware Prompt Optimization, AutoML 2025) adds racing protocols that eliminate statistically inferior candidates early in the evaluation process, reducing total evaluation cost by 40–60% with negligible quality loss.

## Application in Skill Context
Evolutionary optimization applies to the epiphany-prompt skill when the optimization budget is large enough to support population-based search (at minimum 10–20 prompt evaluations per generation over 5+ generations) and when prior single-trajectory methods have plateaued. The recommended entry point is EvoPrompt rather than GEPA for initial implementations — its single-objective fitness function is simpler to define and evaluate. Seed the initial population with the top candidates from a prior APE run rather than random initialization to reduce warm-up generations. Set population size N to 5–8 for cost-constrained runs; 10–15 for quality-maximizing runs. For epiphany-prompt skill optimization specifically, the crossover operator is most valuable when two distinct prompt variants each excel on different evaluation criteria — the LLM-crossover step can combine their respective strengths. CAPO's racing protocol should be implemented when running more than 50 total evaluations to avoid wasting budget on clearly inferior branches. DSPy integration: GEPA's population-based search is available as a DSPy optimizer and can be applied to multi-step skill pipelines end-to-end.

## Key Variants / Parameters
- **Population size N**: 5–8 (cost-constrained) vs. 10–15 (quality-maximizing)
- **Selection strategy**: roulette (fitness-proportional) vs. tournament vs. Pareto-front (GEPA multi-objective)
- **Objectives** (GEPA): accuracy vs. token efficiency — Pareto front is the non-dominated set on both dimensions
- **Mutation operator framing**: preserve-intent-vary-form vs. intensify-key-instruction vs. add-specificity
- **Self-referential mutation**: disabled (EvoPrompt) vs. enabled with evolving mutation-prompt (PromptBreeder)
- **Early elimination**: none (base EvoPrompt) vs. racing protocol (CAPO, 40–60% cost reduction)

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- enhancement/ape.md
- enhancement/opro.md
- enhancement/protegi.md
- techniques/dspy-framework.md
