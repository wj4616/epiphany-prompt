# RLVR, GRPO, DAPO, and VAPO — Reinforcement Learning for Reasoning
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — rlvr-grpo-dapo-vapo-research.md

## Summary
RLVR (Reinforcement Learning with Verifiable Rewards) trains models using binary automated verifiers — math checkers, code executors, or logic oracles — as reward signals, eliminating human annotators. A key NeurIPS 2025 finding reframes RLVR as "sampling compression, not capability expansion": it raises pass@1 by concentrating probability mass on known-correct reasoning paths rather than unlocking genuinely new capabilities. GRPO, DAPO, and VAPO are the successive RL algorithms powering this paradigm, each improving memory efficiency, training stability, and credit assignment.

## Core Mechanism
**RLVR:** Binary verifier provides reward signal per completion. Model is trained to maximize pass@1 on verifiable tasks (math, code). The compression interpretation means RLVR models are highly effective within their pre-trained knowledge horizon but cannot solve problems for which the base model has never seen correct solutions.

**GRPO (Group Relative Policy Optimization):** Eliminates the critic/value model by sampling G outputs per question. Advantage is computed as A_i = (r_i - mean(r)) / std(r) — group-normalized reward. Approximately 50% less memory and compute than PPO.

**DAPO (Decoupled Clip and Dynamic Sampling Policy Optimization):** 2025 successor from ByteDance/Tsinghua with four improvements over GRPO:
- Clip-Higher: asymmetric clipping prevents entropy collapse and promotes output diversity
- Dynamic Sampling: skips no-signal batches where all G outputs receive identical reward
- Token-Level Policy Gradient: stabilizes training for long chain-of-thought sequences
- Overlong Reward Shaping: soft length penalties replace hard truncation
Achieves score 50 on AIME 2024 benchmark.

**VAPO:** Restores the value model to GRPO-style training, providing per-token credit assignment. First value-model-based approach to outperform value-model-free methods on long chain-of-thought tasks.

## Application in Skill Context
RLVR-trained models (DeepSeek-R1 and successors) internalize deep reasoning as default behavior. Optimal prompting strategy differs fundamentally from base models:
- Omit verbose explicit reasoning instructions — they are redundant and can disrupt internal reasoning chains
- Do not use long few-shot reasoning examples — they consume context without adding signal
- Use Thinking Intervention (mid-stream steering via structured prompts) to guide reasoning direction without overriding it
- Trust the model's reasoning compression; focus prompt design on problem framing and verifiable output format
- When designing evaluation prompts for RLVR models, match the binary verifiable structure the model was trained on

## Key Variants / Parameters
- **GRPO group size G:** Larger G gives more stable advantage estimates but increases compute per update step
- **DAPO Clip-Higher asymmetry:** Upper clip threshold set higher than lower to allow probability mass to flow toward novel correct paths
- **Dynamic Sampling threshold:** Skip batches where reward variance across G samples falls below a minimum signal threshold
- **VAPO value model depth:** Value model size relative to policy model is a key efficiency tradeoff

## Related KB Entries
- [synthesis/process-reward-models.md](process-reward-models.md)
- [synthesis/cot-synthesis.md](cot-synthesis.md)
- [synthesis/self-consistency-synthesis.md](self-consistency-synthesis.md)
