# Self-Consistency for Synthesis
**Domain:** synthesis
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — self-consistency-synthesis

## Summary
Self-Consistency applied to synthesis tasks generates N independent synthesis outputs using diverse reasoning paths, then selects the most consistent result rather than accepting the first output. Originally developed for math and logical reasoning tasks where majority vote over exact answers is straightforward, the technique requires adaptation for open-ended synthesis: consistent outputs must be identified via semantic similarity clustering rather than exact matching. The CISC variant adds confidence scoring to each path, replacing simple majority vote with a confidence-weighted decision.

## Core Mechanism
The standard procedure: sample N synthesis outputs from the same prompt using either temperature variation, framing variation, or different CoT scaffolds. For closed-form tasks (classification, factual QA), select the answer appearing in the most outputs by exact or near-exact match. For open-ended synthesis, cluster the N outputs by semantic similarity (embedding cosine similarity or LLM-judged paraphrase detection), identify the largest cluster, and return the centroid or the member with highest internal consistency. CISC (Confidence-Improved Self-Consistency) extends this by appending a self-assessment step to each reasoning path: "Rate your confidence in this answer 0–10 and explain why." Outputs are then weighted by their self-assessed confidence before aggregation, reducing the influence of low-confidence paths even when they represent the majority by count. The practical tradeoff is inference cost: N=5–20 is common, multiplying token usage by N.

## Application in Skill Context
In a prompt engineering skill, self-consistency synthesis applies to prompt improvement proposal generation. The skill generates N improvement proposals independently, using different framings or CoT paths (e.g., one pass focused on clarity, one on completeness, one on tone). The improvements that appear consistently across multiple proposals — identified by semantic overlap of the change descriptions — are the most robust enhancement suggestions. This filters out improvements that are artifacts of a single reasoning path. Implementation pattern: run improvement generation N=3–5 times, extract the specific changes proposed in each run, cluster by semantic similarity, and surface only clusters with membership across 2+ runs as high-confidence recommendations. Single-run-only suggestions are flagged as speculative.

## Key Variants / Parameters
- **N (sample count)**: 3 (low cost, reduced robustness) to 20 (high cost, stronger signal)
- **Diversity mechanism**: temperature sampling vs. framing variation (different system prompts) vs. CoT scaffold variation
- **Consistency metric**: exact match (closed tasks only) vs. semantic embedding similarity vs. LLM-judged paraphrase
- **CISC weighting**: binary (confidence > threshold = included) vs. continuous (proportional weight)
- **Aggregation method**: majority vote → centroid selection → best-representative selection

## Related KB Entries
- synthesis/cot-synthesis.md
- enhancement/automatic-prompt-optimization.md
