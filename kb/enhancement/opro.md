# OPRO (Optimization by PROmpting)
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — opro

## Summary
OPRO is a black-box prompt optimization framework in which an LLM acts as its own optimizer. The LLM receives a meta-prompt containing the task description and a scored history of previously evaluated candidate prompts, then proposes a new improved prompt. The proposed prompt is evaluated, its score is appended to the history, and the loop repeats. Because the optimization signal is natural language rather than gradients, OPRO requires no access to model internals and works with any API-accessible LLM, routinely achieving significant accuracy gains over manually written prompts.

## Core Mechanism
At each iteration, the meta-prompt contains three elements: (1) the task description, explaining what the target prompt must accomplish; (2) the scored history, a growing list of prior candidate prompts paired with their evaluation scores, ordered from worst to best so the LLM can detect the direction of improvement; (3) a meta-instruction directing the LLM to produce a new candidate that scores higher than the current best. The proposed candidate is evaluated against the scoring function (exact-match accuracy, LLM-judge score, or task-specific metric), the result is appended to the history, and the next iteration begins. The primary limitation is context growth: as the scored history accumulates, the meta-prompt eventually saturates the context window, causing the optimization to plateau. Mitigation strategies include history truncation (retaining only the top-K and bottom-K candidates), sliding windows, and periodic summarization of the history.

## Application in Skill Context
A prompt engineering skill can implement OPRO as a lightweight iterative refinement loop without any fine-tuning infrastructure. The meta-prompt is constructed once and extended in-place each iteration: append the current prompt's score after evaluation, then call the LLM again with the updated history. For the epiphany-prompt skill, the scoring function should evaluate candidate prompts on the quality dimensions most relevant to the current task — clarity, reasoning scaffold completeness, output format adherence — and produce a numeric score the history can sort by. To prevent context saturation in multi-iteration runs, retain only the top-5 and bottom-2 candidates in the history and summarize the rest into a single descriptive line. OPRO pairs naturally with APE (which generates the initial candidate pool) and ProTeGi (which provides structured failure analysis when OPRO plateaus).

## Key Variants / Parameters
- **History ordering**: worst-to-best ordering is empirically important — LLM infers improvement direction from the trend
- **History retention policy**: full history vs. top-K/bottom-K windowing vs. sliding window
- **Scoring function type**: exact-match accuracy, LLM-judge rubric score, end-to-end pipeline metric
- **Meta-instruction framing**: "produce a prompt that scores higher" vs. "identify what the best prompts have in common and generate a better variant"
- **Iteration budget**: typically 20–50 iterations before plateau; set a minimum improvement threshold as a stopping criterion

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- enhancement/ape.md
- enhancement/protegi.md
- enhancement/gepa-evolutionary.md
