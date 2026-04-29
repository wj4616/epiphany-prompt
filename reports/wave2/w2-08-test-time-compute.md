# Test-Time Compute Scaling: Deep Research Report

*Generated: 2026-04-14 | Sources: 24 | Confidence: High*

---

## Executive Summary

Test-time compute (TTC) scaling has emerged as one of the most important paradigm shifts in LLM reasoning as of 2024–2025. Rather than relying solely on larger models trained on more data, TTC scaling allocates more compute *during inference* — through extended reasoning traces, search over multiple candidates, or iterative self-refinement. The field has bifurcated into two main strategies: (1) sequential depth scaling, where a single reasoning trace grows longer (Chain-of-Thought, extended thinking), and (2) parallel width scaling, where multiple candidate solutions are generated and evaluated (Best-of-N, MCTS, self-consistency). The key insight from 2025 research is that optimal TTC allocation is **problem-difficulty-dependent** — more thinking helps hard problems but can *hurt* performance on easy ones, motivating adaptive compute-routing strategies.

---

## 1. Foundational TTC Paradigms

### 1.1 Chain-of-Thought (CoT) Prompting
**Origin:** Wei et al. 2022; widely deployed in o1 (2024), DeepSeek-R1 (2025)

**Mechanism:** The model generates a natural-language reasoning trace ("thinking out loud") before producing a final answer. Intermediate steps allow the model to decompose complex problems into manageable parts.

**Scaling behavior:** o1 and DeepSeek-R1 demonstrate that extending CoT dramatically improves performance:
- DeepSeek-R1: AIME benchmark from 15.6% → 71% accuracy through extended CoT; 86.7% with majority voting
- o1: Performance consistently improves with more RL training time (train-time) AND more tokens generated at inference (test-time)

**Limitation:** Research in 2025 reveals the "Overthinking Problem" — longer CoTs can contain more erroneous reasoning steps, degrading performance on easier tasks (GSM8K shows 40–50% token reduction is *beneficial* for simpler tasks).

---

### 1.2 Extended Thinking / Scratchpad Reasoning
**Deployed in:** OpenAI o1, o3; DeepSeek-R1; Google Gemini 2.5/3 Flash; Kimi K1.5; Qwen3; Grok-4

**Mechanism:** Models generate extensive internal "thinking" tokens before producing the final response. These tokens are often hidden from the user but consume compute. The model explores, backtracks, and self-corrects within this scratchpad.

**Thinking Budget Controls (2025):**
- **Gemini 2.5 Flash Thinking:** Explicit `thinking_budget` parameter, 0–24,576 tokens, with 6× cost difference between off and full mode
- **Gemini 3 Flash:** Replaced with `thinking_level` parameter (minimal/low/medium/high) — relative guidance, not strict token guarantee; default is HIGH with dynamic thinking
- **Sparse MoE Architecture:** Gemini 3 Flash uses transformer-based sparse mixture-of-experts to route tokens to specialized sub-networks, enabling high reasoning performance with low active parameters per inference

---

## 2. Parallel Sampling / Width-Scaling Techniques

### 2.1 Best-of-N (BoN) Sampling
**Mechanism:** Generate N independent solutions, select the best using a verifier or reward model. The simplest form of parallel test-time scaling — pure exploration, no feedback between samples.

**Scaling efficiency:** Best-of-N is the primary baseline against which other TTC methods are measured. Achieves significant gains but plateaus at high N due to sample correlation.

---

### 2.2 Self-Consistency (Majority Voting)
**Source:** [Self-Consistency Prompting — LearnPrompting](https://learnprompting.org/docs/intermediate/self_consistency)

**Mechanism:** Sample T independent Chain-of-Thought reasoning paths, extract the final answer from each, apply majority voting (unweighted) to select the consensus answer. No verifier needed — the diversity of independent reasoning paths provides the signal.

**2025 Enhancement — Ranked Voting Self-Consistency:**
Rather than unweighted majority voting, assigns confidence-based weights to candidate answers using model confidence scores.

**2025 Enhancement — Thought Pruning for Self-Consistency:**
[EMNLP 2025](https://aclanthology.org/2025.emnlp-main.1750.pdf) — Filters low-confidence reasoning traces before majority vote, reducing token usage while maintaining accuracy.

**2025 Enhancement — DeepConf (Deep Confidence):**
Leverages local confidence to improve accuracy: filters low-confidence traces and applies early termination when confidence drops, reducing total token usage.

---

### 2.3 Process Reward Models (PRMs)
**Source:** [Rewarding Progress: Scaling Automated Process Verifiers — ICLR 2025](https://openreview.net/forum?id=A6Y7AqlzLW)

**Mechanism:** Step-level reward signals provided at each intermediate reasoning step, not just the final answer. Used to guide search — at each branching point, the PRM scores each candidate step, and only high-scoring paths are explored further.

**Contrast with Outcome Reward Models (ORMs):** ORMs provide a single sparse correctness signal only at the end. PRMs provide dense step-level credit assignment.

**2025 Advances:**
- **Process Advantage Verifiers (PAVs):** >8% more accurate than ORM, 1.5–5× more compute-efficient; enables 6× sample efficiency gain for RL-trained policies
- **ThinkPRM:** Verbalized step-wise reward model — generates a verification Chain-of-Thought for every step rather than a scalar score; can utilize more verification compute by "thinking longer"
- **R-PRM (Reasoning-Driven PRM):** [EMNLP 2025](https://aclanthology.org/2025.emnlp-main.679.pdf) — Reasoning-aware process reward modeling

---

## 3. Tree / Graph Search Architectures

### 3.1 Tree-of-Thoughts (ToT)
**Origin:** Yao et al. 2023

**Mechanism:** Models the reasoning process as a tree, where each node is a partial solution ("thought"). At each step, the model generates multiple candidate continuations (breadth-first or depth-first), evaluates them (via LLM-as-evaluator or external verifier), and prunes low-value branches. Supports lookahead and backtracking.

---

### 3.2 Forest-of-Thought (FoT)
**Source:** [Forest-of-Thought: Scaling Test-Time Compute — ICML 2025](https://arxiv.org/abs/2412.09078)

**Mechanism:** Integrates *multiple* reasoning trees operating in parallel. Three key components:
1. **Sparse Activation:** Selects the most relevant reasoning paths across all trees (not all branches are followed)
2. **Dynamic Self-Correction:** Real-time error revision within each tree
3. **Consensus-Guided Decision-Making:** Final answer selected by cross-tree consensus

**Performance:**
- GSM8K (4 activated subtrees): 97.33% accuracy — outperforms rStar-Math (95.20%) and GPT-4o (92.90%)
- AIME 2024: 53.33% — vs. rStar-Math at 6.66%

---

### 3.3 Graph-of-Thoughts (GoT)
**Mechanism:** Extends Tree-of-Thoughts by allowing reasoning units to form *arbitrary dependencies* — not just parent-child hierarchical paths, but any directed graph structure. Enables information aggregation from multiple prior reasoning steps simultaneously.

---

### 3.4 Adaptive Graph of Thoughts (AGoT)
**Source:** [Adaptive Graph of Thoughts: Test-Time Adaptive Reasoning — 2025](https://arxiv.org/html/2502.05078)

**Mechanism:** Dynamic, graph-based inference framework that recursively decomposes complex queries into structured subproblems, forming a directed acyclic graph (DAG) of interdependent reasoning steps. The graph structure adapts at inference time based on query complexity — simple queries collapse to chain structure, complex ones expand to full DAG.

**Performance:** Up to +46.2% improvement on scientific reasoning tasks (GPQA) — comparable to gains from computationally intensive RL fine-tuning, achieved purely at test time.

---

### 3.5 Adaptive Branching MCTS (AB-MCTS)
**Source:** [Wider or Deeper? Scaling LLM Inference-Time Compute — 2025](https://arxiv.org/abs/2503.04412)

**Mechanism:** Generalizes repeated sampling with principled multi-turn exploration and exploitation via a Bayesian tree search. Core innovation: dynamically decides at each node whether to "go wider" (generate new candidate responses) or "go deeper" (refine existing ones), using Thompson Sampling over Bayesian posterior distributions.

**Two Implementation Variants:**
- **AB-MCTS-M (Mixed Model):** Hierarchical Bayesian modeling with group-level intercepts for each child node cluster
- **AB-MCTS-A (Node Aggregation):** Explicit GEN (generate new) and CONT (continue/refine) nodes with conjugate priors — Beta variant for bounded scores (most sample-efficient)

**Search Techniques Compared (in paper):**
1. Repeated Sampling (pure width, no refinement)
2. Sequential Refinement (pure depth, no branching)
3. Standard MCTS with fixed branching factor
4. AB-MCTS-M and AB-MCTS-A (adaptive)

**Key Finding:** AB-MCTS consistently outperforms both repeated sampling and standard MCTS, with the performance gap *widening* at larger compute budgets (>64 generations). Effective inference-time scaling requires combining output diversity with multi-turn refinement.

---

## 4. Depth-Scaling / Sequential Refinement

### 4.1 Iterative Self-Refinement
**Mechanism:** A single reasoning trajectory is iteratively revised using external feedback signals (test results, verifier scores, human critiques). Each revision constitutes one "deeper" step in the search. Capitalizes on structured feedback but sacrifices diversity.

---

### 4.2 Beam Search with PRM Guidance
**Mechanism:** Extends sequential reasoning with multiple parallel "beams" (typically 3–5), each scored at every step by a Process Reward Model. Only the top-k beams survive each step. Hybrid between depth and width approaches.

---

### 4.3 rStar-Math (Mutual Reasoning Improvement)
**Source referenced in FoT paper**

**Mechanism:** Self-play-based approach where the model generates reasoning traces and a step-level verifier scores them, iteratively improving both the generator and verifier without external labels.

---

## 5. Adaptive Compute Allocation

### 5.1 Compute-Optimal Scaling Strategy
**Source:** [Scaling LLM Test-Time Compute Optimally — ICLR 2025](https://arxiv.org/abs/2408.03314)

**Mechanism:** Rather than uniformly applying the same TTC strategy to all inputs, adaptively allocates compute based on prompt difficulty. Two primary approaches:
1. **Process-Based Verifier Search:** Use PRM scores to guide search depth/width
2. **Adaptive Distribution Updating:** Update the model's output distribution given the specific prompt at test time

**Key Finding:** "The effectiveness of different approaches to scaling test-time compute critically varies depending on the difficulty of the prompt." Optimal allocation enables a smaller base model to outperform a 14× larger model in FLOPs-matched comparisons on appropriate problem subsets.

---

### 5.2 Thinking-Optimal Scaling Strategy (TOPS)
**Source:** [Towards Thinking-Optimal Scaling of Test-Time Compute — 2025](https://arxiv.org/html/2502.18080v1)

**Mechanism:** Three-stage training + inference framework:
1. **Format Imitation:** Train on seed data with varying response lengths to teach different reasoning effort levels
2. **Reasoning Effort-Conditioned Generation:** A "tag model" generates solutions under multiple reasoning effort conditions (Low/Medium/High) via system prompt conditioning
3. **Self-Improvement:** Select shortest *correct* response per problem for fine-tuning — teaches the model to use minimum necessary tokens

**Performance:** Achieves comparable performance to QwQ-32B-Preview with significantly fewer tokens; 40–50% token reduction on simple tasks with no accuracy loss.

---

### 5.3 Inference Scaling Laws
**Source:** [Inference Scaling Laws: An Empirical Analysis — ICLR 2025](https://proceedings.iclr.cc/paper_files/paper/2025/file/8c3caae2f725c8e2a55ecd600563d172-Paper-Conference.pdf)

**Mechanism:** Empirical analysis of cost-performance trade-offs across inference strategies: greedy search, majority voting, Best-of-N, weighted voting, and two tree search algorithms — across different model sizes and compute budgets.

**Key Finding:** Scaling inference compute with inference strategies can be more computationally efficient than scaling model parameters. Smaller models + advanced inference algorithms achieve Pareto-optimal cost/performance trade-offs.

---

## 6. Training-Time Approaches that Enable TTC

### 6.1 RLHF (Reinforcement Learning from Human Feedback)
**Mechanism:** Traditional approach — reward model trained on human preferences guides RL fine-tuning. Effective for alignment but ill-suited for rigorous multi-step reasoning.

### 6.2 GRPO (Group Relative Policy Optimization)
**Mechanism:** Eliminates the value/critic model from standard PPO-based RLHF. Groups of sampled outputs are compared relatively rather than using an absolute value baseline. Used in DeepSeek-R1.

### 6.3 RLVR (RL with Verifiable Rewards)
**Mechanism:** Eliminates the reward model entirely. Uses verifiable rewards from symbolic tools (math checkers, code executors) — reward is binary (correct/incorrect) rather than learned. Combined with GRPO in DeepSeek-R1's training.

### 6.4 Self-Training for Reasoning (STILL)
**Source:** [Can Large Reasoning Models Self-Train? — 2025](https://arxiv.org/pdf/2505.21444)

**Mechanism:** Reasoning models generate their own training data via extended Chain-of-Thought, filter for correct solutions, and fine-tune on successful traces. Iterative self-improvement loop without human labels.

---

## 7. The Overthinking Problem and Mitigation

**Key 2025 Finding:** Scaling CoT length is not monotonically beneficial.

Evidence:
- Longer CoT on easy tasks leads to more erroneous intermediate steps
- GSM8K benefits from *shorter* reasoning traces
- AIME/complex math benefits from *longer* reasoning traces

**Mitigation Techniques:**
- TOPS: Effort-conditioned generation + self-improvement on shortest correct traces
- Thought Pruning: Filter low-confidence traces before aggregation
- DeepConf: Early termination on confidence drop
- Thinking Level Controls (Gemini 3): Model-level parameter to bound reasoning depth

---

## Key Takeaways

1. **TTC scaling is now competitive with parameter scaling:** For many reasoning tasks, allocating 10-100× more inference compute to a smaller model matches the performance of a much larger model trained with more data. The compute-optimal frontier has shifted.

2. **Optimal strategy is problem-difficulty-dependent:** Hard problems (AIME, GPQA) benefit from deep search and extended CoT; easy problems can be *harmed* by excessive thinking. Adaptive routing (TOPS, compute-optimal scaling) is the key frontier.

3. **The field has converged on two orthogonal axes:** Width (more independent samples, Best-of-N, self-consistency) vs. Depth (longer traces, iterative refinement, beam search). AB-MCTS is the 2025 framework that adaptively balances both axes via Bayesian decision-making.

4. **PRM guidance is the key multiplier:** Step-level reward signals dramatically outperform outcome-only signals for search-based TTC methods. ThinkPRM's "thinking verifier" extends this — verification itself becomes a compute-scaling dimension.

5. **The economic pressure is real:** OpenAI's 2024 inference spend was 15× its GPT-4.5 training cost. Inference demand will exceed training demand by 118× by 2026. Efficient TTC routing is now an economic imperative, not just a research curiosity.

---

## All Named Techniques/Frameworks (Extraction)

| # | Technique / Framework | Mechanism Summary |
|---|---|---|
| 1 | **Chain-of-Thought (CoT)** | Natural-language reasoning trace before final answer |
| 2 | **Extended Thinking / Scratchpad** | Hidden reasoning tokens; explore/backtrack before answer |
| 3 | **Thinking Budget (Gemini 2.5)** | Explicit token cap (0–24,576) for reasoning phase |
| 4 | **Thinking Level (Gemini 3)** | Relative reasoning level parameter (minimal/low/med/high) |
| 5 | **Best-of-N (BoN) Sampling** | Generate N independent solutions, select best via verifier |
| 6 | **Self-Consistency (Majority Voting)** | Sample T CoT paths, select consensus answer by vote |
| 7 | **Ranked Voting Self-Consistency** | Confidence-weighted majority voting |
| 8 | **Thought Pruning** | Filter low-confidence traces before aggregation |
| 9 | **DeepConf** | Early termination on local confidence drop |
| 10 | **Process Reward Model (PRM)** | Step-level reward signal for guided search |
| 11 | **Outcome Reward Model (ORM)** | Final-answer-only reward signal (baseline) |
| 12 | **Process Advantage Verifier (PAV)** | PRM variant, 8% more accurate and 1.5–5× more efficient |
| 13 | **ThinkPRM** | Verbalized PRM — generates verification CoT per step |
| 14 | **R-PRM** | Reasoning-driven process reward modeling |
| 15 | **Tree-of-Thoughts (ToT)** | Tree-structured reasoning with branching and pruning |
| 16 | **Forest-of-Thought (FoT)** | Multiple parallel reasoning trees + cross-tree consensus |
| 17 | **Graph-of-Thoughts (GoT)** | Arbitrary dependency graph for reasoning units |
| 18 | **Adaptive Graph of Thoughts (AGoT)** | Dynamic DAG that adapts complexity to query difficulty |
| 19 | **Adaptive Branching MCTS (AB-MCTS)** | Bayesian tree search adaptively balancing width vs. depth |
| 20 | **AB-MCTS-M** | Hierarchical mixed model variant of AB-MCTS |
| 21 | **AB-MCTS-A** | Node aggregation (GEN/CONT) variant of AB-MCTS |
| 22 | **Beam Search with PRM** | Top-k beams scored at each step by PRM |
| 23 | **rStar-Math** | Self-play reasoning improvement with step-level verifier |
| 24 | **Compute-Optimal Scaling Strategy** | Difficulty-adaptive TTC allocation |
| 25 | **Thinking-Optimal Scaling Strategy (TOPS)** | 3-stage: format imitation → effort-conditioned gen → self-improvement |
| 26 | **Inference Scaling Laws** | Empirical cost-performance trade-off analysis |
| 27 | **RLHF** | Human preference reward model + RL fine-tuning |
| 28 | **GRPO** | Critic-free group relative policy optimization |
| 29 | **RLVR** | Verifiable reward RL (no reward model needed) |
| 30 | **Self-Training (STILL)** | Iterative self-improvement on model's own correct CoT traces |
| 31 | **Sequential Refinement** | Iterative single-trace revision via external feedback |
| 32 | **Sparse Activation (FoT)** | Selects most relevant reasoning paths across trees |
| 33 | **Thompson Sampling (AB-MCTS)** | Bayesian exploration-exploitation balancing in tree search |

---

## Sources

1. [Scaling LLM Test-Time Compute Optimally — ICLR 2025](https://arxiv.org/abs/2408.03314)
2. [Wider or Deeper? Adaptive Branching Tree Search — 2025](https://arxiv.org/abs/2503.04412)
3. [Forest-of-Thought: Scaling Test-Time Compute — ICML 2025](https://arxiv.org/abs/2412.09078)
4. [Adaptive Graph of Thoughts — 2025](https://arxiv.org/html/2502.05078)
5. [Towards Thinking-Optimal Scaling of Test-Time Compute](https://arxiv.org/html/2502.18080v1)
6. [Inference Scaling Laws — ICLR 2025](https://proceedings.iclr.cc/paper_files/paper/2025/file/8c3caae2f725c8e2a55ecd600563d172-Paper-Conference.pdf)
7. [Rewarding Progress: Scaling Automated Process Verifiers — ICLR 2025](https://openreview.net/forum?id=A6Y7AqlzLW)
8. [Process Reward Models That Think (ThinkPRM)](https://arxiv.org/pdf/2504.16828)
9. [R-PRM: Reasoning-Driven Process Reward Modeling](https://aclanthology.org/2025.emnlp-main.679.pdf)
10. [Thought Pruning for Efficient Scaling with Self-Consistency](https://aclanthology.org/2025.emnlp-main.1750.pdf)
11. [Ranked Voting Self-Consistency](https://aclanthology.org/2025.findings-acl.744.pdf)
12. [DeepSeek-R1: Incentivizing Reasoning via Reinforcement Learning](https://arxiv.org/html/2501.12948v1)
13. [Learning to Reason with LLMs — OpenAI](https://openai.com/index/learning-to-reason-with-llms/)
14. [Revisiting the Test-Time Scaling of o1-like Models — ACL 2025](https://aclanthology.org/2025.acl-long.232.pdf)
15. [The State of LLM Reasoning Model Inference — Sebastian Raschka](https://magazine.sebastianraschka.com/p/state-of-llm-reasoning-and-inference-scaling)
16. [How LLMs Reason: The Power of Thinking Longer](https://www.ieai.sot.tum.de/how-do-llms-reason/)
17. [What is Test-Time Compute? — AI Weekly](https://aiweekly.co/learning-ai/deep-learning/what-test-time-compute-how-ai-models-think-they-answer)
18. [What is Test-time Scaling? — Adaline Labs](https://labs.adaline.ai/p/what-is-test-time-scaling)
19. [Inference-Time Scaling and Collective Intelligence — Sakana AI (AB-MCTS)](https://sakana.ai/ab-mcts/)
20. [A Visual Guide to Reasoning LLMs — Maarten Grootendorst](https://newsletter.maartengrootendorst.com/p/a-visual-guide-to-reasoning-llms)
21. [Can Large Reasoning Models Self-Train?](https://arxiv.org/pdf/2505.21444)
22. [A Survey of Adaptive and Controllable Test-Time Compute](https://arxiv.org/pdf/2507.02076)
23. [Gemini 3 Flash — Google DeepMind](https://deepmind.google/models/gemini/flash/)
24. [Understanding Reasoning Models & Test-Time Compute: DeepSeek-R1](https://medium.com/@cch.chichieh/understanding-reasoning-models-test-time-compute-insights-from-deepseek-r1-d30783070827)

---

## Methodology

Searched 7 queries across web. Analyzed 24 sources (4 deep-read, 20 from search snippets).

Sub-questions investigated:
1. What are the core TTC scaling paradigms (CoT, extended thinking, best-of-N)?
2. What tree/graph-based reasoning architectures exist for TTC?
3. How do Process Reward Models enable and guide TTC search?
4. What is the Overthinking Problem and how is it mitigated?
5. How do current commercial models implement thinking budget control?
6. What training-time methods (RLHF, GRPO, RLVR) enable TTC capabilities?
7. What are the inference scaling laws and economic implications?
