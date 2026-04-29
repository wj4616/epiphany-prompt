# Automatic Prompt Optimization (APO)
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — automatic-prompt-optimization

## Summary
Automatic Prompt Optimization (APO) is the family of methods that use algorithmic search — rather than manual trial-and-error — to discover better prompts for a given task. Two main paradigms exist: discrete APO, where LLMs generate and evaluate candidate prompts in natural language; and soft/continuous APO, where gradient descent optimizes learnable embedding vectors. The field has matured from simple instruction rewriting (APE, 2022) through program-level optimization (DSPy, 2023) to multi-strategy ensemble methods (ELPO, 2025), with demonstrated accuracy improvements from approximately 46% to 64% on standard benchmarks.

## Core Mechanism
All APO methods require three components: an evaluation metric or scoring function (the objective), a search strategy (how to navigate the prompt space), and a candidate generation mechanism (how new prompt candidates are produced). In discrete APO, an LLM generates candidate prompt variants using meta-instructions ("Rewrite this prompt to be clearer"), evaluates each variant against the scoring function (which may itself use an LLM), and iterates. APE (Automatic Prompt Engineer) uses forward generation and scoring. DSPy treats the full LLM program — including all prompts, intermediate steps, and module connections — as the optimization target, with a compiler that tunes prompts end-to-end. ELPO (Ensemble LLM Prompt Optimization, 2025) combines multiple optimization strategies in a single run, selecting the best-performing approach per task. In soft/continuous APO, learnable embedding vectors are prepended to the input and optimized via gradient descent against a differentiable objective, with model weights frozen (see soft-prompt-tuning.md). The 2025 taxonomy organizes all APO into four axes: profile/instruction optimization, knowledge injection, reasoning/planning scaffolding, and reliability enhancement.

## Application in Skill Context
A prompt engineering skill should implement a lightweight APO loop as its core enhancement mechanism. The minimal viable loop: (1) score the current prompt against evaluation criteria using an LLM judge; (2) generate K candidate improvements targeting the lowest-scoring criteria; (3) score each candidate; (4) accept the best-scoring candidate as the new current prompt; (5) repeat until score plateaus or iteration budget is exhausted. The evaluation metric design is the most consequential decision — vague metrics produce unstable optimization. For the epiphany-prompt skill context, evaluation criteria should map to the specific quality dimensions defined in the skill (clarity, coverage, reasoning scaffold completeness, output format precision). DSPy-style program optimization applies when the skill is itself a multi-step LLM pipeline: each step's prompt can be independently optimized against the pipeline's end-to-end output quality.

## Key Variants / Parameters
- **Paradigm**: discrete/textual (LLM-generated candidates) vs. soft/continuous (gradient-optimized embeddings)
- **Optimization axis**: instruction wording, knowledge injection, reasoning scaffold, reliability/robustness
- **Search strategy**: greedy hill-climbing, beam search, evolutionary selection, ensemble (ELPO)
- **Candidate count per iteration K**: 3–10 typical; higher K increases cost and coverage
- **Evaluation metric type**: exact-match, LLM-judge score, task-specific rubric, end-to-end pipeline metric

## Related KB Entries
- synthesis/self-consistency-synthesis.md
- synthesis/knowledge-distillation.md
- enhancement/rag-prompting.md
- enhancement/soft-prompt-tuning.md
