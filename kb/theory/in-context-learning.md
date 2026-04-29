# In-Context Learning
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 1 — in-context-learning

## Summary
In-Context Learning (ICL) is the capability of LLMs to adapt to new tasks by learning from examples provided within the context window, without any modification to model weights. It is the theoretical foundation underlying few-shot prompting: the model infers the task structure from the provided input-output pairs and generalizes to new inputs. ICL is not a trained behavior in the traditional sense — it emerges at scale and appears to operate via mechanisms fundamentally distinct from gradient-based learning.

## Core Mechanism
Research suggests ICL performs implicit Bayesian inference over the space of possible task functions — the model computes a posterior over plausible mappings given the examples, rather than executing a learned lookup. Key empirical findings: (1) **Label correctness matters less than format consistency** — models perform well even with randomly shuffled labels if the input-output format is consistent, suggesting ICL is sensitive to structural patterns; (2) **Example ordering significantly affects performance** — examples seen last (closest to the query) have disproportionate influence, consistent with recency bias in causal attention; (3) **ICL capability scales with model size** — the capability emerges reliably at approximately 100B parameters and is weak or absent in smaller models; (4) **ICL is bounded by context window size** — the number of examples is hard-capped by the available token budget. Limitations: sensitive to example selection quality; can fail on out-of-distribution task instances; does not persist knowledge beyond the current context.

## Application in Skill Context
For a prompt engineering skill, ICL means that carefully curated input-output examples embedded in the skill's system prompt directly shape task behavior. The skill should: (1) place examples in a consistent format rather than optimizing for label accuracy alone; (2) order examples so that the most representative or boundary cases appear last; (3) use DSPy or similar tooling when the example set needs automatic optimization. ICL also implies the skill can demonstrate desired output formats through examples rather than verbose declarative instructions, often achieving better results with less token cost.

## Key Variants / Parameters
- **Zero-shot ICL:** No examples; relies on instruction alone. Works when task is well-represented in pretraining.
- **Few-shot ICL:** 3–10 examples; standard production configuration.
- **Many-shot ICL:** Dozens to hundreds of examples; requires large context window; improves performance on complex tasks.
- **DSPy automated ICL:** Uses labeled data to search for optimal example subsets automatically, replacing manual example curation.

## Related KB Entries
- `theory/prompt-engineering-foundations.md`
- `theory/context-engineering-paradigm.md`
- `cross-references/unified-pe-ideation-synthesis.md`
- `cross-references/reasoning-scaffold-family.md`
