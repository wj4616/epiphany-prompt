# Transformational Creativity in LLMs: Deep Research Report
*Generated: 2026-04-14 | Sources: 22 | Confidence: High*

## Executive Summary

Research in 2024–2025 consistently confirms that current LLMs achieve combinatorial and exploratory creativity reliably but fall short of transformational creativity — the ability to restructure the conceptual space itself rather than recombine within it. This distinction, drawn from Boden's taxonomy, is now the dominant framework for evaluating AI creative capacity. Structured prompting interventions (two-phase divergent-convergent scaffolding, persona priming, denial prompting, multilingual prompting) measurably increase creativity scores, but primarily push models toward the upper range of exploratory creativity rather than genuinely transformational output. Multi-agent debate architectures and meta-level self-modifying agents represent the current frontier for approaching transformational creativity. Alignment training (RLHF) is a structural suppressor of creativity, reducing output entropy and pushing models toward statistical comfort zones.

---

## 1. Boden's Taxonomy as the Standard Framework

Every major 2024–2025 paper on LLM creativity uses Margaret Boden's three-part taxonomy as its organizing framework:

| Level | Definition | LLM Status |
|-------|-----------|------------|
| **Combinatorial** | Connecting familiar ideas in novel ways | Achievable; LLMs reliably demonstrate this |
| **Exploratory** | Discovering new possibilities within an existing conceptual space by following its rules | Partially achievable; requires structured prompting |
| **Transformational** | Altering the rules of a conceptual space to reach previously inaccessible regions | "Still elusive" — structural barriers exist |

Key finding from the *Large Language Models for Scientific Idea Generation* survey (arXiv:2511.07448): "Current methods tend to remain at the combinatorial or exploratory level, with transformational creativity still elusive." The barrier is architectural — autoregressive training optimizes for statistical likelihood, which biases toward expected rather than disruptive outputs.

---

## 2. Named Techniques and Frameworks

### 2.1 Prompt-Driven Approaches

**Persona & Role Priming**
- Zhao et al. (2025): Role-based prompts ("act as a natural scientist") significantly boost originality on creativity tests.
- Quantified: Instructional prompting raised novelty from 3.78 → 4.05; persona-based (natural scientist) achieved 4.23 novelty and 4.62 valueness. Generic roles underperform specific nuanced ones.
- Caveat (Nature Human Behaviour, 2025, N=9,198 humans + 215,542 LLM observations): Genius persona instructions lifted performance "up to a threshold beyond which the output became opposite real-life patterns." Persona prompting has a ceiling effect.

**Two-Phase Divergent-Convergent Prompting (CreativeDC)**
- Explicit structural separation: Phase 1 explores freely without constraint satisfaction; Phase 2 selects and refines.
- Theoretical basis: Wallas's creativity stages + Guilford's divergent/convergent distinction.
- Results: 8.5% higher semantic diversity, 32.9% higher novelty than Chain-of-Thought baselines; 72% higher Vendi Score at K=100 problems.
- Source: arXiv:2512.23601

**Denial Prompting**
- Systematically denies routine/obvious solutions to force models toward novel regions of idea space.
- Lu et al. developed NeoGauge metric showing constraint-based denial drives creative code generation.
- Source: arXiv:2511.07448 survey

**Bit-Flip-Spark Framework**
- Induces "cognitive conflict" by prompting models to question their own assumptions before generating.
- Cited as enabling higher-order creative reasoning; details in arXiv:2511.07448.

**Multilingual Prompting**
- Wang et al. (2025c): Cross-lingual prompting outperforms traditional diversity techniques including temperature sampling.
- Vatsal et al. (2025): Validated across 250+ languages.
- Mechanism: Different languages activate different concept clusters, expanding effective search space.

**Chain-of-Ideas (CoI)**
- Captures breakthrough dependencies between ideas (unlike CoT which captures reasoning steps).
- Designed for scientific ideation; maps the dependency graph of conceptual innovations.

**Constraint-Based & Adversarial Queries**
- Introducing arbitrary requirements, limitations, and emotional hooks forces models outside statistical habits.
- Prompts that blend semantically distant domains induce conceptual blending but risk Prompt-Induced Hallucination (PIH).

**GPS Framework (Goals, Prompts, Strategies)**
- Guides designers through systematic LLM collaboration for brainstorming.
- Improves creativity of ideas by structuring the human-AI co-ideation interaction.

### 2.2 Inference-Time Scaling for Creativity

**Tree-of-Thoughts (ToT)**
- Branches reasoning into a tree structure; enables exploration of multiple paths.
- Moves toward exploratory creativity by enabling systematic hypothesis traversal.

**Graph of Thoughts (GoT)**
- Extends ToT: thoughts connect in a web, multiple reasoning paths can merge into one new thought.
- Enables more sophisticated recombination operations.

**Monte Carlo Tree Search Variants**
- MC-NEST and Monte Carlo Thought Search apply MCTS to idea space navigation.
- Source: arXiv:2511.07448

**Self-Refine**
- Sequential refinement with self-feedback; iteratively improves creative outputs.
- Risk: Tends toward conservative convergence over multiple rounds.

**PANEL**
- Stepwise critique generation enabling systematic evaluation of creative proposals.

**MOOSE-Chem2**
- Hierarchical search framework for chemical research ideation.

**FlexiVe**
- Solve-detect-verify pipeline for creative problem solving.

### 2.3 Knowledge Augmentation Approaches

**RAG-Based Methods**
- Retrieval-Augmented Generation grounds ideation in literature.
- Risk: "Higher retrieval quality often reduces output diversity as models overfit to retrieved passages."

**Knowledge Graph-Based Methods**
- KG-CoI, SciMON, GoAI: Use structured knowledge graphs for cross-domain concept connections.
- GoAI achieved 3.83 novelty vs. 2.44 for vanilla prompting.

**SPARK System** (Sanyal et al., 2025 — ICCC25)
- Components: Xplor (literature retrieval with MMR re-ranking), Spark Idea Generator, Spark Filter (Judge model).
- Judge model: Fine-tuned on 600K OpenReview reviews; provides idea-focused critique independent of empirical results.
- Grounding in Maximal Marginal Relevance ensures source diversity to prevent retrieval-induced conservatism.

**Ideasynth, Scideator, Nova, ResearchAgent**
- Specialized scientific ideation tools; primarily operate at combinatorial level.

### 2.4 Multi-Agent Architectures

**Multi-Agent Debate (MAD)**
- Agents propose, critique, and select; promotes divergent thinking through disagreement.
- Survey (arXiv:2505.21116): Multi-agent systems enable "emergent collaboration and richer exploration of open-ended creative spaces."
- Diversity + parallelism + depth are key configuration parameters.

**VirSci (Virtual Scientists)**
- Ensemble of LLM agents with different scientific personas collaborating on ideation.

**IRIS Framework**
- Multi-agent framework with peer review simulation for research idea generation.

**Robin**
- Lab-in-the-loop design system; integrates experimental feedback into creative generation cycle.

**Darwin Gödel Machine**
- Self-modifying agents that update their own code/architecture.
- Represents shift "from idea-level search to agent-level search" — closest current approach to transformational creativity.

### 2.5 Training-Level Approaches

**Creative Preference Optimization (CRPO)**
- Training method that directly optimizes for creative output preferences.

**Diverse Preference Optimization (DivPO)**
- Explicitly trains for output diversity rather than convergence on a single best answer.

**Domain-Specific Reinforcement Learning**
- RL applied within specific creative domains.

### 2.6 Structured Recombination Methods

**DishCover Framework**
- Text-to-Tree conversion → Tree Blending (Zhang-Shasha edit-distance algorithm) → Evaluation & Ranking → Tree-to-Text generation.
- Outperforms direct GPT-4o prompting: 3.53 vs. 3.146 novelty score.
- GPT-4o exhibited fixation bias (56% used smoked paprika); DishCover overcomes this through structural manipulation.
- Source: arXiv:2504.20643

**Combinatorial Creativity Agent Framework**
- Generalization-Level Retrieval (L1–L4 abstraction levels from domain-specific to universal principles).
- Two-Stage Process: parallel component analysis + integration agent.
- 7–10% improvement over baseline on OAG-Bench.
- Source: arXiv:2412.14141

### 2.7 Evaluation Frameworks

**CreativityPrism**
- Three dimensions: quality, novelty, diversity.
- Nine tasks across three domains: divergent thinking (AUT, DAT, TTCT), creative writing (TTCW, Creative Short Story, CS4), logical reasoning.
- Twenty evaluation metrics with validated automatic judges.
- Key finding: Proprietary LLMs lead creative writing by 15%; no advantage in divergent thinking. Novelty weakly correlated with quality/diversity — they are orthogonal dimensions.
- Source: arXiv:2510.20091

**NeoGauge**
- Metric for evaluating novelty in creative code generation.

**IDF-Inspired Surprise Metric**
- Ranks candidates by inverse document frequency of ingredient/concept combinations.

---

## 3. Key Research Findings

### 3.1 The Combinatorial Ceiling

Multiple 2025 studies confirm LLMs reliably produce combinatorial creativity but face a structural ceiling:
- Nature Human Behaviour large-scale study (N=9,198 humans, 215,542 LLM observations): "Human creativity on average is slightly higher than that of LLMs" with "creativity differences pronounced at the extremes of the distribution" — humans have greater right-tail variability.
- The "outlier problem": humans still produce the exceptional ideas; LLMs generate statistically central ones.
- LLMs "consistently outperform humans on coherence... however, humans score significantly higher on emergence."

### 3.2 Alignment Training as Creativity Suppressor

A critical and underappreciated finding: RLHF reduces output entropy and semantic variety, pushing models toward safer responses. This creates a systematic bias against transformational creativity at the training level, not just the inference level.

### 3.3 The Homogenization Paradox

CHI 2025 study (N=1,100 randomized experiment):
- LLM assistance improved performance *during* assisted tasks.
- But significantly undermined *independent* performance afterward (strategy guidance: -10.6 percentage points on convergent thinking; reduced originality on divergent thinking).
- Group-level homogenization: participants exposed to LLM strategies generated more similar ideas, reducing collective creative diversity.
- Implication: Heavy LLM dependency may reduce the human creative diversity that humans currently still exceed LLMs on.

### 3.4 Prompt-Induced Conceptual Transitions (PITs and PIHs)

arXiv:2505.10948 introduces two phenomena from Conceptual Blending Theory applied to LLMs:
- **Prompt-Induced Transitions (PIT)**: Discrete shifts in tone or meaning triggered by blending distant concepts (e.g., mathematical aperiodicity + traditional craft).
- **Prompt-Induced Hallucination (PIH)**: Plausible but ungrounded outputs from fusing incompatible domains (e.g., periodic table + tarot divination).
- Implication: Conceptual blending prompts can push LLMs into genuinely new conceptual territory, but at the cost of grounding and factual reliability.

### 3.5 Scientific Idea Generation Quality vs. Novelty

Stanford/NLP large-scale study with 100+ NLP researchers (arXiv:2409.04109, published ICLR 2025):
- LLM-generated ideas judged **more novel** (p < 0.05) than human expert ideas.
- Judged **slightly weaker on feasibility**.
- Confirms LLMs can exceed human novelty at the combinatorial level but trade off implementation quality.

---

## 4. What Prompting Approaches Enable Higher-Order Creativity

Ordered from most to least evidenced for pushing toward transformational creativity:

1. **Two-Phase Divergent-Convergent Prompting (CreativeDC)**: Explicit structural separation prevents premature convergence. Best quantified gains (+32.9% novelty).

2. **Denial Prompting**: Systematic exclusion of obvious solutions forces search into non-statistical regions. Directly combats the "expected output" bias from autoregressive training.

3. **Multi-Agent Debate with Diverse Personas**: Disagreement between agents with opposed objectives expands the explored idea space and can challenge domain assumptions.

4. **Nuanced Persona Priming**: Specific role-based prompts (e.g., "natural scientist in field X") outperform generic roles. But has ceiling effect — extreme genius personas degrade performance.

5. **Multilingual Prompting**: Cross-lingual concept activation outperforms temperature sampling for diversity. Underutilized technique.

6. **Conceptual Blending Prompts**: Deliberately bridging semantically distant domains induces PITs. Requires tolerance for PIH risk; best used with verification layer.

7. **Constraint-Based Adversarial Queries**: Artificial limitations force conceptual link-forging. Effective for exploratory creativity.

8. **Knowledge Graph + MMR Retrieval**: Ensures diverse source material, combating retrieval-induced conservatism.

9. **DivPO / CRPO Training**: Training-level interventions that directly optimize for diversity and creativity — more fundamental than prompting alone.

---

## 5. Structural Barriers to Transformational Creativity

1. **Autoregressive Architecture**: Next-token prediction inherently biases toward statistically likely outputs.
2. **RLHF Alignment**: Directly suppresses entropy/diversity in pursuit of human preference scores.
3. **Retrieval Overfitting**: High-quality RAG can paradoxically reduce novelty by anchoring to existing ideas.
4. **Self-Evaluation Miscalibration**: LLM confidence signals don't reliably track creative quality.
5. **No True Conceptual Space Mutation**: Current methods recombine or explore within spaces defined by training data; genuinely altering the space requires architectural innovation.

---

## Key Takeaways

- Boden's three-level taxonomy (combinatorial / exploratory / transformational) is now the standard framework for LLM creativity evaluation. Use it when designing creativity-oriented prompts or systems.
- The most effective prompting-level intervention for pushing toward higher creativity is **two-phase divergent-convergent scaffolding** (separate ideation from evaluation phases explicitly).
- **Denial prompting** (systematically blocking obvious solutions) directly addresses the statistical-comfort-zone problem of autoregressive models.
- **RLHF alignment training suppresses creativity** — this is a structural issue, not fixable by prompting alone; DivPO/CRPO address it at the training level.
- **Multilingual prompting** is an underutilized technique that outperforms temperature sampling for diversity.
- Multi-agent architectures with diverse, disagreeing agents are the current leading approach toward transformational creativity — specifically those with meta-level self-modification capacity (Darwin Gödel Machine model).
- LLMs reliably exceed humans on novelty at the combinatorial level; humans retain superiority at the far right tail (exceptional, outlier ideas).
- Heavy reliance on LLM assistance homogenizes group-level creative diversity — a systemic risk for prompt engineering skill design.

---

## Sources

1. [Large Language Models for Scientific Idea Generation: A Creativity-Centered Survey](https://arxiv.org/html/2511.07448) — Comprehensive survey using Boden's taxonomy; covers all major techniques
2. [Cooking Up Creativity: Enhancing LLM Creativity through Structured Recombination (DishCover)](https://arxiv.org/html/2504.20643) — Structured recombination via tree blending outperforms direct prompting
3. [LLMs Can Realize Combinatorial Creativity (Combinatorial Creativity Agent Framework)](https://arxiv.org/html/2412.14141v1) — Generalization-level retrieval system; 7–10% improvement on OAG-Bench
4. [Combinatorial Creativity: A New Frontier in Generalization Abilities](https://arxiv.org/html/2509.21043v2) — Framework analysis of combinatorial generalization
5. [On the Creativity of Large Language Models](https://arxiv.org/html/2304.00008v5) — Foundational analysis of LLM creativity limits
6. [A Large-Scale Comparison of Divergent Creativity in Humans and LLMs](https://www.nature.com/articles/s41562-025-02331-1) — Nature Human Behaviour; N=9,198 humans, LLMs slightly below human average
7. [Human Creativity in the Age of LLMs: Randomized Experiments](https://arxiv.org/html/2410.03703v2) — CHI 2025; homogenization paradox; strategy guidance harms subsequent independent creativity
8. [Divergent-Convergent Thinking for Creative Problem Generation (CreativeDC)](https://arxiv.org/html/2512.23601) — Two-phase prompting; +32.9% novelty, +8.5% diversity
9. [The Way We Prompt: Conceptual Blending, Neural Dynamics, and Prompt-Induced Transitions](https://arxiv.org/abs/2505.10948) — PIT and PIH phenomena; prompting as cognitive science methodology
10. [Creativity in LLM-based Multi-Agent Systems: A Survey](https://arxiv.org/abs/2505.21116) — ACL 2025 EMNLP; divergent exploration, iterative refinement, collaborative synthesis
11. [Can LLMs Generate Novel Research Ideas?](https://proceedings.iclr.cc/paper_files/paper/2025/file/ea94957d81b1c1caf87ef5319fa6b467-Paper-Conference.pdf) — ICLR 2025; LLM ideas more novel but less feasible than human expert ideas
12. [PopBlends: Strategies for Conceptual Blending with LLMs](https://savvypetridis.github.io/papers/popblends.pdf) — Conceptual blending strategies taxonomy
13. [CreativityPrism: A Holistic Evaluation Framework for LLM Creativity](https://arxiv.org/abs/2510.20091) — 9 tasks, 3 domains, 20 metrics; novelty orthogonal to quality/diversity
14. [SPARK: A System for Scientifically Creative Idea Generation](https://arxiv.org/html/2504.20090v1) — ICCC 2025; Xplor + Spark Generator + Judge model (600K reviews)
15. [Has the Creativity of LLMs Peaked?](https://www.sciencedirect.com/science/article/pii/S2713374525000202) — Inter- and intra-LLM variability analysis
16. [Human vs. LLM Creativity: Task-Dependent Asymmetry](https://pmc.ncbi.nlm.nih.gov/articles/PMC12942112/) — PMC; linguistic mechanisms analysis
17. [Research: When Used Correctly, LLMs Can Unlock More Creative Ideas](https://hbr.org/2025/12/research-when-used-correctly-llms-can-unlock-more-creative-ideas) — HBR; persistence + flexibility as creativity enablers
18. [Can Generative AI Be Creative?](https://web.tecnico.ulisboa.pt/guilherme.marcelo/assets/pdfs/can_genai_be_creative.pdf) — Systematic analysis of Boden's taxonomy applied to generative AI
19. [Scaffolding Creativity: Divergent and Convergent LLM Approaches](https://arxiv.org/pdf/2510.26490) — Scaffolding survey
20. [Generative AI Models Outperform Students on Divergent and Convergent Thinking](https://www.nature.com/articles/s41598-025-21398-4) — Scientific Reports; outperforms average students
21. [Multi-Agent Collaboration Mechanisms: A Survey](https://arxiv.org/html/2501.06322v1) — MAS coordination patterns
22. [A Framework for Collaborating LLM for Brainstorming](https://www.sciencedirect.com/science/article/abs/pii/S1871187125000045) — GPS (Goals, Prompts, Strategies) framework

---

## Methodology

Searched 9 queries across web and news. Analyzed 22 sources. Full content read for 7 sources.

Sub-questions investigated:
1. How do researchers define and distinguish transformational from combinatorial creativity in LLMs?
2. What named frameworks and techniques have been developed for LLM creativity (2024–2025)?
3. What prompting approaches measurably improve creativity, and at which level of Boden's taxonomy?
4. What are the structural barriers to transformational creativity in current LLMs?
5. What multi-agent and training-level approaches show most promise for higher-order creativity?
