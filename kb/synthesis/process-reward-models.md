# Process Reward Models (PRMs)
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — process-reward-models-research.md

## Summary
Process Reward Models (PRMs) score each intermediate reasoning step rather than only the final answer, contrasting with Outcome Reward Models (ORMs) that provide a single terminal reward. Fine-grained step-level credit assignment catches early-step errors before they propagate through a reasoning chain. PRMs are applied in two primary contexts: guided tree or beam search during test-time compute scaling, and as training signal for multi-step reasoning tasks.

## Core Mechanism
A PRM receives a partial reasoning trace ending at step k and outputs a score estimating whether that step is correct and productive toward the solution. During inference-time search, the PRM prunes candidate branches at each step rather than waiting for full completion — this dramatically reduces wasted compute on reasoning paths that diverged early. During training, PRM scores provide dense supervision that ORMs cannot supply.

Key variants:
- **ThinkPRM:** Verbalized PRM — generates an explicit verification chain-of-thought per step, making its scoring rationale transparent and auditable
- **Process Advantage Verifier (PAV):** 8% more accurate than standard PRM scoring, 1.5–5× more computationally efficient
- **R-PRM (Reasoning-Driven, EMNLP 2025):** Decouples error categorization from reward computation, allowing different treatment of logical errors vs. calculation errors vs. relevance failures
- **SP-PRM:** Combines score consistency with preference consistency in process reward modeling
- **PathFinder-PRM:** Separate error categorization module upstream of reward scoring

**Meta-Rewarding extension:** A meta-judge model evaluates and iteratively improves the PRM/judge itself. Recursive judge improvement yielded +16.5% win rate improvement in controlled evaluations.

## Application in Skill Context
PRMs can be simulated in prompt engineering without a trained reward model by inserting explicit step-evaluation checkpoints into multi-step prompts. After each reasoning step in a structured prompt, instruct the model to score the quality and correctness of that step before proceeding to the next. This mimics PRM behavior through in-context evaluation rather than trained scoring.

Practical pattern for prompt skill pipelines:
1. Structure the reasoning task as explicit numbered steps
2. After each step, insert a gated evaluation sub-prompt: "Before continuing, assess whether step N is logically sound and necessary. If not, revise it."
3. Use the final step's self-evaluation as a confidence signal before committing to the output

For agent pipelines with access to external verifiers (code executors, math checkers), integrate verifier output as a hard PRM signal at each tool-use step.

## Key Variants / Parameters
- **Granularity level:** Token-level, sentence-level, or logical-step-level scoring — coarser granularity is faster but misses fine-grained errors
- **Verbalized vs. numeric scoring:** ThinkPRM's explicit rationale improves interpretability at the cost of latency
- **Error categorization depth:** R-PRM's decoupled categorization enables targeted feedback but requires more complex prompt scaffolding when simulated
- **Meta-judge iterations:** One or two rounds of meta-rewarding typically captures most quality gain; additional rounds show diminishing returns

## Related KB Entries
- [synthesis/rlvr-grpo.md](rlvr-grpo.md)
- [synthesis/cot-synthesis.md](cot-synthesis.md)
- [synthesis/self-consistency-synthesis.md](self-consistency-synthesis.md)
- [synthesis/mixture-of-agents.md](mixture-of-agents.md)
