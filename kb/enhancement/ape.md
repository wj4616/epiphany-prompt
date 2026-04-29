# APE (Automatic Prompt Engineer)
**Domain:** enhancement
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — ape

## Summary
APE (Zhou et al., 2022) is the foundational automatic prompt optimization technique, establishing that LLMs can generate their own instructions by observing input-output examples. Given a task description and a small set of demonstrations, an LLM produces a large pool of candidate instruction variants; each variant is evaluated on a held-out set; the highest-scoring candidate is selected. APE initiated the entire APO research field and remains the baseline against which all subsequent methods (OPRO, ProTeGi, DSPy) are compared.

## Core Mechanism
APE operates in three stages. Stage 1 — Candidate generation: the LLM receives the task description and a set of input-output demonstration pairs, with a meta-instruction to produce multiple distinct instructions that would lead a model to map the inputs to the outputs. Two generation strategies are defined: forward mode generates an instruction directly from the examples ("what instruction would cause a model to produce these outputs given these inputs?"); backward mode fills in an instruction template given the task structure. Generating a pool of 50–200 candidate instructions is typical. Stage 2 — Evaluation: each candidate instruction is prepended to a held-out evaluation set and executed; performance is measured by a scoring function (typically exact-match accuracy or ROUGE against reference outputs). Stage 3 — Selection: the highest-scoring candidate is returned as the optimized prompt. An optional iterative refinement stage reseeds the generation step using the top-N candidates as seeds for a second round of generation, partially closing the gap with methods that use structured failure analysis. APE's key limitation relative to successors is that failure analysis is absent — improvement is driven purely by sampling breadth rather than diagnosis of what is wrong with low-scoring candidates.

## Application in Skill Context
APE is the recommended starting point when no prior prompt exists and the goal is to bootstrap a high-quality initial instruction from a small set of examples. In the epiphany-prompt skill context, APE's forward generation mode maps directly to the task of creating a new sub-prompt for a specific reasoning step: provide 3–5 examples of the desired input-output behavior, generate 20–50 candidate instructions, evaluate each against a scoring rubric, and select the top candidate as the working prompt for that step. Because APE requires labeled input-output pairs, it is best applied to well-defined subtasks with verifiable outputs rather than open-ended creative generation steps. The iterative refinement variant should always be used when budget permits — empirically, a second-round seed from the top-5 first-round candidates recovers roughly half the performance gap between APE and ProTeGi for structured tasks.

## Key Variants / Parameters
- **Generation mode**: forward (instruction from examples) vs. backward (fill template from task structure)
- **Pool size**: number of candidate instructions generated; 50–200 typical
- **Scoring function**: exact-match accuracy, ROUGE, LLM-judge rubric
- **Iterative refinement**: single-round (base APE) vs. multi-round with top-N reseeding
- **Demonstration count**: 3–10 examples; more improves generation quality at higher token cost

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- enhancement/opro.md
- enhancement/protegi.md
- enhancement/gepa-evolutionary.md
- techniques/few-shot-prompting.md
