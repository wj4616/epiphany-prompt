# Improving Ideation in Artificial Intelligence LLM: Deep Research Report

*Generated: 2026-04-14 | Sources: 40+ | Confidence: High*

---

## Executive Summary

Improving ideation in large language models (LLMs) is an active, multi-front research area. Current work spans five complementary strategy families: (1) prompt engineering techniques that explicitly scaffold divergent and convergent thinking; (2) multi-agent collaboration frameworks where LLM ensembles debate, critique, and synthesize ideas; (3) knowledge augmentation via RAG and knowledge graphs to ground and extend creative reach; (4) inference-time scaling using tree-search and self-refinement loops; and (5) parameter-level adaptation methods like DivPO and CRPO that embed diversity signals into the model itself. A central challenge is the novelty-feasibility trade-off: LLM-generated ideas often score higher on novelty than human expert ideas but lower on feasibility, and RLHF alignment systematically suppresses creative entropy. The most exciting frontier is transformational creativity — altering the conceptual space itself rather than recombining within it — which remains largely unsolved.

---

## 1. The Ideation Problem: What Makes LLMs Fall Short

### 1.1 Homogeneity and the Artificial Hivemind

Standard LLM prompting produces homogeneous outputs because the model defaults to high-probability, well-represented token sequences. Research on divergent-convergent LLM frameworks describes this as the "Artificial Hivemind" effect — when generating many ideas, successive outputs cluster semantically around the same attractors.

- Semantic diversity does not automatically increase with generation count ([CreativeDC paper, arXiv:2512.23601](https://arxiv.org/html/2512.23601v1))
- Higher temperature does not reliably increase semantic diversity; outputs at elevated temperatures "do not extend much further away from an exemplar story than outputs at lower temperatures" ([Is Temperature the Creativity Parameter of LLMs?, arXiv:2405.00492](https://arxiv.org/html/2405.00492v1))
- Optimal temperature for creativity peaks at moderate values (0.4–0.7) then declines ([IBM LLM Temperature](https://www.ibm.com/think/topics/llm-temperature))

### 1.2 Alignment Tax on Creativity

RLHF-aligned models are penalized in the creativity domain: alignment training reduces output entropy and pushes models toward "safer, less creative responses." Models remain trapped in conservative attractors even when creativity-focused prompts are used ([LLMs for Scientific Idea Generation Survey, arXiv:2511.07448](https://arxiv.org/html/2511.07448))

### 1.3 Novelty vs. Feasibility Trade-off

A landmark 100+ NLP researcher study established that LLM-generated research ideas are rated statistically more novel (p < 0.05) than human expert ideas but are "judged slightly weaker on feasibility." ([Can LLMs Generate Novel Research Ideas?, arXiv:2409.04109](https://arxiv.org/abs/2409.04109))

The LiveIdeaBench benchmark independently confirmed a Pareto trade-off: some models prioritize originality while others optimize for feasibility, with few achieving balance across both dimensions. ([LiveIdeaBench, arXiv:2412.17596](https://arxiv.org/html/2412.17596v1))

### 1.4 Creativity Independence from General Intelligence

Critically, "scientific creative ability shows distinct patterns from general intelligence metrics." LiveIdeaBench found a weak, statistically insignificant correlation (r=0.409, p=0.130) between creative ideation performance and general-purpose intelligence benchmarks. Models like QwQ-32B-preview match o1-preview in creative tasks despite large gaps in general benchmark scores. This means creativity cannot simply be inherited from smarter base models — it requires dedicated cultivation.

### 1.5 Diversity Collapse Under RAG

Higher retrieval quality in RAG pipelines often reduces idea diversity as models overfit to retrieved passages, reinforcing incremental thinking over radical innovation ([Survey, arXiv:2511.07448](https://arxiv.org/html/2511.07448)).

---

## 2. Prompt Engineering Techniques for Ideation

### 2.1 Chain-of-Thought (CoT) Prompting

The foundational technique for intermediate reasoning. CoT scaffolds multi-step thinking by prompting the model to articulate reasoning chains before arriving at answers. Applied to ideation, it helps structure the pathway from problem statement to creative output.

- Source: [Chain-of-Thought Prompting Guide](https://www.promptingguide.ai/techniques/cot); [IBM CoT](https://www.ibm.com/think/topics/chain-of-thoughts)

### 2.2 Tree of Thoughts (ToT)

Extends CoT by maintaining a branching tree of reasoning paths rather than a single chain. The model generates multiple candidate "thoughts" at each step, evaluates them via self-scoring, and uses BFS/DFS search algorithms to explore the solution space with backtracking capability.

- Performance: In "Game of 24" tasks, ToT with b=5 beats CoT by 25 percentage points
- For creative writing and strategic tasks, ToT demonstrates superior performance over standard methods
- Sources: [ToT Prompt Guide](https://www.promptingguide.ai/techniques/tot); [IBM ToT](https://www.ibm.com/think/topics/tree-of-thoughts); [Princeton NeurIPS 2023](https://github.com/princeton-nlp/tree-of-thought-llm)

### 2.3 Graph of Thoughts (GoT)

Advances beyond ToT by representing thoughts as nodes in a directed graph rather than a strict tree, enabling non-linear reasoning paths, merging of thought branches, and looping. GoT achieves higher novelty scores (3.83) and average quality (3.39) compared to Chain-of-Ideas (3.21 novelty).

- Source: [GoT arXiv:2308.09687](https://arxiv.org/abs/2308.09687)

### 2.4 CreativeDC: Divergent-Convergent Two-Phase Prompting

A structured two-phase method inspired by Wallas's creativity theory and Guilford's divergent-convergent framework:

**Phase 1 (Divergent):** "Think about only the given theme and list down wildly different and underexplored elements" — explicitly ignoring constraints to allow broad semantic space exploration.

**Phase 2 (Convergent):** Select the most promising divergent ideas and refine them to satisfy all task requirements, with iterative fallback if selections fail.

Key results:
- 63.5% higher semantic novelty vs. Chain-of-Thought baselines
- 72% higher effective distinct problems at K=100 (scaling advantage)
- Statistically significant diversity and novelty gains (p<0.01)
- Persona Simulation Augmentation: sampling from Persona Hub dataset steers outputs toward varied perspectives

- Source: [CreativeDC arXiv:2512.23601](https://arxiv.org/html/2512.23601v1)

### 2.5 GPS Framework (Goals, Prompts, Strategies)

A practitioner-oriented framework for designers using LLMs in brainstorming. Three levels:

- **Goal**: Defines purpose — divergence (exploration) or convergence (solution-narrowing)
- **Prompt**: Refines text input to elicit varied, high-quality responses
- **Strategy**: Nine questioning techniques including Chain-of-Thought, Flipped Interaction, Unconventional Roles

Evaluation uses four Torrance Tests of Creative Thinking (TTCT) dimensions: Fluency, Flexibility, Originality, Elaboration.

- Sources: [GPS arXiv:2410.11877](https://arxiv.org/abs/2410.11877); [ScienceDirect](https://www.sciencedirect.com/science/article/abs/pii/S1871187125000045)

### 2.6 Role / Persona Prompting

Assigning expert personas significantly boosts originality. "Natural scientist personas achieve higher novelty scores than generic roles." Persona Hub datasets provide population-level behavioral fidelity for sampling diverse perspectives.

Key finding: Expert personas can increase behavioral divergence in multi-agent systems and enable diverse synthetic data generation, though overall effects on factual tasks are inconsistent.

- Sources: [Role Prompting, LearnPrompting](https://learnprompting.org/docs/advanced/zero_shot/role_prompting); [PersonaFlow DIS 2025](https://dl.acm.org/doi/10.1145/3715336.3735789)

### 2.7 Constraint-Based and Denial Prompting

Paradoxically, constraints often increase creativity by forcing the model away from default, high-probability outputs:
- Negative constraint framing ("avoid mentioning X", "do not use obvious solutions") pushes models toward underutilized regions of generative space
- Incremental restriction approaches progressively block common solutions, steering toward novel territory
- "Constraints don't limit creativity — they focus it"

- Source: [Constraint-Based Prompts, Andrew Maynard](https://andrewmaynard.net/constraint-based-prompts/)

### 2.8 Multilingual / Cross-Lingual Prompting

Cross-lingual reformulations leverage distinct linguistic priors from different language traditions, reportedly "outperforming traditional diversity techniques such as temperature sampling" for some ideation tasks. Cross-Lingual-Thought Prompting (XLT) uses a generic template that stimulates cross-lingual and logical reasoning skills.

- Sources: [XLT arXiv:2305.07004](https://arxiv.org/abs/2305.07004); [Multilingual Prompt Survey arXiv:2505.11665](https://arxiv.org/html/2505.11665v1)

### 2.9 Self-Refine (Iterative Self-Feedback)

The model generates an initial output, then critiques it and produces improved versions in a FEEDBACK → REFINE → FEEDBACK loop — no supervised training data needed. Significantly improves performance on code optimization, sentiment revision, and other tasks.

Key caveat: Self-bias — LLMs systematically overrate their own generations, with self-bias amplifying monotonically over refinement steps.

- Sources: [Self-Refine arXiv:2303.17651](https://arxiv.org/abs/2303.17651); [Self-Refine](https://selfrefine.info/)

### 2.10 Bit-Flip-Spark and Assumption-Challenging

Structured prompts designed to induce "cognitive conflict" — prompting the model to explicitly identify and challenge its own assumptions before generating ideas. Moves ideation from incremental to more exploratory modes.

### 2.11 Multi-Agent Debate Prompting (MAD)

Multiple LLM agents argue from unique viewpoints, present claims and counter-arguments in turn-based format, then synthesize to a well-rounded output. This reduces hallucinations and increases reasoning breadth.

- Sources: [MAD arXiv:2305.14325](https://arxiv.org/abs/2305.14325); [ICLR Blogposts 2025](https://d2jud02ci9yv69.cloudfront.net/2025-04-28-mad-159/blog/mad/)

---

## 3. Multi-Agent Collaboration Frameworks

### 3.1 LLM Discussion Framework

Three-phase structured discussion framework using role-playing to combat LLM homogeneity:
1. **Divergent Exchange Phase**: Vigorous idea exchanges, role-assigned agents with distinct backgrounds
2. **Discussion Phase**: Critique and cross-pollination between roles
3. **Convergence Phase**: Synthesis to creative final output

Evaluated on Alternative Uses Test (AUT), Similarities Test, Instances Test, Scientific Creativity Test. Outperforms single-agent and existing multi-LLM frameworks across all creativity metrics.

- Source: [LLM Discussion arXiv:2405.06373](https://arxiv.org/abs/2405.06373)

### 3.2 Society of Mind / Sibyl / AutoGen

Inspired by Minsky's Society of Mind theory: intelligent behavior emerging from diverse collections of simpler agents. The Sibyl system implements a "multi-agent debate-based jury" with several agent "jurors" discussing before outputting a final response. Microsoft's AutoGen provides a high-level interface for multi-agent orchestration.

- Sources: [Composable Models Debate](https://composable-models.github.io/llm_debate/); [iSolutions Medium](https://isolutions.medium.com/language-model-agents-in-2025-897ec15c9c42)

### 3.3 Pipeline-Oriented Multi-Agent Workflows

Sequential specialist agents: one generates ideas, another critiques, a third synthesizes. Useful for domain-specific ideation where each stage benefits from different expertise framing.

### 3.4 Can LLM Multi-Agent Systems Augment Human Creativity?

Research demonstrates LLM-powered multi-agent systems do augment human creativity in structured brainstorming tasks, with evidence presented at ACM Collective Intelligence Conference 2025.

- Source: [ACM CI 2025](https://dl.acm.org/doi/10.1145/3715928.3737479)

---

## 4. Knowledge Augmentation for Ideation

### 4.1 Semantic RAG

Standard retrieval-augmented generation grounds the LLM in up-to-date literature, reducing hallucinations and enabling combinatorial creativity through concept recombination. However, high retrieval quality paradoxically reduces diversity by overfitting to retrieved passages.

### 4.2 Graph RAG / Knowledge Graph Integration

Relational retrieval via knowledge graphs enables multi-hop reasoning that exposes cross-domain connections invisible to nearest-neighbor search. "Graph-structured multi-hop reasoning improves plausibility and interpretability" by following relationship chains across concept spaces.

- Sources: [Microsoft GraphRAG](https://microsoft.github.io/graphrag/); [Nodus Labs KG for Ideation](https://noduslabs.com/featured/graph-rag-and-llms-how-knowledge-graphs-can-improve-ai-ideation/)

### 4.3 Analogical Reasoning Amplification

Cross-domain analogy is among the most powerful ideation accelerators. Research across 250 trials showed "human analogical guidance amplifies LLM performance 10-fold" when structured guidance activates latent cross-domain knowledge via analogical bridges. The model already has vast analogical knowledge from pre-training; the key is activating it through structured prompting.

- Source: [Nature Communications](https://www.nature.com/articles/s41467-026-70873-7)

### 4.4 CogGRAG (Mind-Map RAG)

A human cognition-inspired graph-based RAG framework that models reasoning as a tree-structured mind map: (1) top-down problem decomposition, (2) structured retrieval from external KGs, (3) bottom-up reasoning with dual-process self-verification.

- Source: [CogGRAG arXiv:2503.06567](https://arxiv.org/html/2503.06567v2)

---

## 5. Structured Ideation Methodologies + LLM Integration

### 5.1 AutoTRIZ

Automates the Theory of Inventive Problem Solving (TRIZ) using LLMs. Four-step pipeline:
1. Problem Identification (LLM)
2. Contradiction Detection (LLM identifies which of 39 TRIZ engineering parameters conflict)
3. Principle Retrieval (non-LLM module queries 39×39 contradiction matrix)
4. Solution Generation (LLM synthesizes actionable solutions)

Results: 7 of 10 test cases aligned with expert textbook analysis. The hybrid approach (LLM for reasoning, rule-based for matrix lookup) maintains interpretability while leveraging LLM domain knowledge. Dramatically lowers TRIZ adoption barriers — replaces months of required training.

Extensible to: SCAMPER, Design Heuristics, Design-by-Analogy.

- Sources: [AutoTRIZ arXiv:2403.13002](https://arxiv.org/abs/2403.13002); [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S1474034625002058)

### 5.2 SCAMPER with AI

SCAMPER (Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, Reverse) used in AI-assisted team brainstorming to develop fresh campaigns or improve product features. Generative AI students solve creative design problems via structured SCAMPER methodology.

- Source: [Design Creativity in AI: SCAMPER, Cambridge Core](https://www.cambridge.org/core/journals/ai-edam/article/design-creativity-in-ai-using-the-scamper-method/A6C81AB782B52FB9DD0C64F407DD7C63)

### 5.3 Morphological Analysis + Design-by-Analogy

Traditional morphological analysis systematically explores the combinatorial space of design dimensions. Combined with LLM reasoning, it can auto-populate morphological charts and suggest cross-combination options not previously considered.

### 5.4 Alternative Worlds / TRIZ Contradiction Matrix

"Alternative Worlds" framework borrows successful models from one industry and applies them to another — directly mirroring the TRIZ principle of applying inventive principles across domains.

---

## 6. Inference-Time Scaling for Ideation

### 6.1 Test-Time Compute Scaling

The o1 paradigm revealed a new scaling law: more inference compute = better reasoning. Extended thinking at generation time (before final output) enables deeper exploration of solution spaces. Applied to ideation, this means "thinking before answering" produces more considered, less reflexive ideas.

- Source: [Sequoia Capital Act o1](https://sequoiacap.com/article/generative-ais-act-o1/); [Sebastian Raschka LLM Reasoning](https://magazine.sebastianraschka.com/p/state-of-llm-reasoning-and-inference-scaling)

### 6.2 Sequential Refinement

Simple iterative improvement loops. Risk: "tunnel vision" — local optimization can reinforce initial creative direction rather than exploring new territory.

### 6.3 Population-Based Search (Beam Search)

Maintain multiple idea candidates in parallel, pruning and expanding. Increases diversity but irreversible pruning can eliminate promising branches prematurely.

### 6.4 Tree Search with Backtracking

Full ToT-style tree exploration. Broadest coverage of the ideation space with ability to backtrack from dead ends. Most compute-intensive but highest ceiling for creativity according to Boden's framework — approaches "exploratory" creativity level.

### 6.5 Feedback Source Hierarchy

From weakest to strongest feedback signal for ideation refinement:
1. Internal Confidence (cost-effective but miscalibrated, vulnerable to reward hacking)
2. Peer LLM Evaluators (flexible but exploitable)
3. Simulators/Real Environments (grounded trial-and-error)
4. External Tools/APIs (extends reasoning beyond text)
5. Scientific Priors/Domain Rules (constrains within valid bounds)
6. Human-in-the-Loop (gold standard but expensive and hard to scale)

---

## 7. Parameter-Level Adaptation

### 7.1 Diverse Preference Optimization (DivPO)

Meta's training method: instead of selecting the single highest-reward response from a candidate pool, select the most diverse high-quality response. Diversity criteria include model probability, word frequency, and LLM-based diversity judgment.

Results:
- +30.07% diversity improvement on structured persona generation vs. baseline
- +13.6% diversity and +39.6% quality improvement on keyword-based creative writing vs. standard preference optimization

- Sources: [DivPO arXiv:2501.18101](https://arxiv.org/html/2501.18101); [MarkTechPost](https://www.marktechpost.com/2025/02/03/this-ai-paper-from-meta-introduces-diverse-preference-optimization-divpo-a-novel-optimization-method-for-enhancing-diversity-in-large-language-models/)

### 7.2 Creative Preference Optimization (CRPO)

Uses the LLM's own general linguistic knowledge as a feedback signal for guiding logical consistency and fluency during preference optimization. Explicitly injects novelty and diversity signals into DPO-style training.

### 7.3 Supervised Fine-Tuning on Creative Corpora

Direct fine-tuning on high-creativity datasets internalizes new reasoning patterns. Domain-specific fine-tuning (e.g., on patent literature, scientific papers) grounds creative generation in field-appropriate conceptual structures.

### 7.4 Reinforcement Learning with Novelty Rewards

RL training with reward functions that explicitly penalize repetition and reward semantic distance from prior outputs. Experimental; challenges include defining robust novelty metrics that resist gaming.

### 7.5 Diversity Tuning (Post-Training)

Modifying LLMs post-training specifically for diverse creative writing — altering generation dynamics after base training to expand the spread of outputs without sacrificing quality.

- Source: [DiversityTuning GitHub](https://github.com/mj-storytelling/DiversityTuning); [arXiv:2503.17126](https://arxiv.org/html/2503.17126)

---

## 8. Evaluation Landscape for LLM Ideation

### 8.1 LiveIdeaBench

Comprehensive benchmark for scientific divergent thinking. 1,180 keywords across 18+ disciplines, 40+ models tested. Dimensions (Guilford-grounded):
- Originality
- Feasibility
- Fluency (non-redundant idea count per keyword)
- Flexibility (domain-consistent performance)

Uses UMAP/DBSCAN clustering and PCA eigenvalue analysis for objective diversity measurement. Dynamic multi-model evaluator panel minimizes individual model bias.

Key finding: Claude-3.5-Sonnet ranks highest on originality; Gemini-Pro-1.5 achieves best balanced performance across all dimensions.

- Source: [LiveIdeaBench arXiv:2412.17596](https://arxiv.org/html/2412.17596v1)

### 8.2 Torrance Tests of Creative Thinking (TTCT)

Gold-standard human creativity assessment adapted for LLM evaluation:
- **Fluency**: Number of relevant ideas generated
- **Flexibility**: Range of categories/types spanned
- **Originality**: Statistical rarity / uniqueness of ideas
- **Elaboration**: Depth and detail in idea development

### 8.3 Divergent Association Task (DAT)

Measures semantic distance between a set of words the model generates (further apart = more creative). Allows objective comparison between models and between models and humans.

Nature Human Behaviour study finding: "Human creativity on average is slightly higher than that of LLMs, but the most creative humans still exceed any model's DAT scores." However, AI is "more original and elaborate when controlling for fluency." ([Nature Human Behaviour](https://www.nature.com/articles/s41562-025-02331-1))

### 8.4 Alternative Uses Test (AUT)

Participants/models generate creative uses for common objects. Used to evaluate originality and breadth across divergent thinking frameworks. "AI outperforms humans in standardized tests of creative potential" in some AUT comparisons. ([ScienceDaily](https://www.sciencedaily.com/releases/2024/03/240301134758.htm))

### 8.5 LLM-as-Judge Approaches

Three variants:
- Prompt-based inference-time judges
- Fine-tuned judges
- RL-optimized judge variants

Persistent vulnerability: reward hacking — models learn to game evaluator preferences rather than genuinely improving.

### 8.6 Effective Semantic Diversity (ESD)

A framework measuring diversity only among outputs that meet a quality threshold — better reflects practical utility than raw output spread. Removes noise from the diversity signal. ([OpenReview ESD](https://openreview.net/forum?id=O7bF6nlSOD))

---

## 9. Human-AI Collaborative Ideation

### 9.1 Hybrid Groups Outperform Both

Wharton research: hybrid human-AI groups outperform both AI-only and human-only groups in brainstorming productivity. Accenture: AI-driven ideation produces a 35% improvement in team creativity and faster time-to-market.

### 9.2 AIdeation System

Developed at CHI 2025 from requirements gathered from 12 professional designers. Significantly enhanced creativity, ideation efficiency, and user satisfaction in studies with 16 professional designers.

- Source: [AIdeation CHI 2025](https://dl.acm.org/doi/10.1145/3706598.3714148)

### 9.3 IdeationWeb

System for tracking the evolution of design ideas across a full human-AI co-creation session — enabling users to see how concepts developed, forked, and merged over time. Presented at CHI 2025.

- Source: [IdeationWeb CHI 2025](https://dl.acm.org/doi/10.1145/3706598.3713375)

### 9.4 Novice vs. Expert Dynamics

Novice designers rely on generative AI in early ideation stages; experienced designers emphasize its value in later execution/refinement stages. HAI-CDP (Human-AI Co-Creative Design Process) models substantially improve creative performance over traditional design. ([Frontiers Computer Science 2025](https://www.frontiersin.org/journals/computer-science/articles/10.3389/fcomp.2025.1672735/full))

### 9.5 LLM Assistance and Homogenization Risk

Concerning 2025 finding: "Exposure to LLM assistance did not enhance participants' originality or fluency in subsequent unassisted tasks, and in some cases led to decreased originality and reduced diversity of ideas" — suggesting LLM reliance may homogenize human thinking over time. ([CHI 2025](https://dl.acm.org/doi/full/10.1145/3706598.3714198))

---

## 10. Boden's Three Levels of Creativity — Where LLMs Stand

| Creativity Level | Description | LLM Status |
|---|---|---|
| Combinatorial | Novel recombinations of existing concepts | Well-supported (RAG, CoT, SCAMPER) |
| Exploratory | Structured search within conceptual spaces | Partially solved (ToT, GoT, DivPO) |
| Transformational | Altering the conceptual space itself | Largely unsolved — active frontier |

Current methods cluster at combinatorial and exploratory levels. Transformational creativity — generating ideas that redefine the problem space or invent new conceptual structures — remains the primary unsolved challenge.

---

## 11. Key Challenges and Open Problems

1. **Alignment Tax**: RLHF reduces entropy and creative diversity; current safety/helpfulness optimization creates conservative attractors
2. **Diversity Collapse in RAG**: Better retrieval = less diverse ideas paradox
3. **Self-Bias in Self-Refine**: Monotonic amplification means iterative self-critique does not reliably improve novelty
4. **Evaluation Non-Standardization**: No widely-accepted benchmark; creativity assessment remains subjective across labs
5. **Auto-Regressive Architecture Limits**: Next-token prediction may impose fundamental constraints on transformational creativity
6. **Idea Length Irrelevance**: Idea quality shows near-zero correlation with response length (R²=0.003), challenging simple quality heuristics
7. **Human Homogenization Risk**: LLM assistance may reduce human creative independence over time
8. **Feasibility Gap**: More novel ideas tend to be less implementable — the fundamental trade-off has no clean solution yet

---

## 12. Key Takeaways

- **Temperature is a blunt instrument**: Semantic diversity does not reliably scale with temperature; dedicated diversity methods (DivPO, CreativeDC, multi-agent discussion) are more effective
- **Structure beats freedom**: Constrained, structured prompting (SCAMPER, TRIZ, ToT, GPS) consistently outperforms open-ended generation for ideation quality
- **Divergent before convergent**: Explicitly separating exploration from constraint-satisfaction (CreativeDC) yields 63%+ semantic novelty gains
- **Multi-agent debate amplifies creativity**: Role-play + discussion frameworks that fight homogeneity consistently outperform single-agent prompting
- **Cross-domain analogy is high-leverage**: Human analogical guidance amplifies LLM ideation 10-fold; structured analogy activation is underutilized
- **Creativity diverges from intelligence**: LLM creativity benchmarks are largely orthogonal to general intelligence benchmarks — a separate capability dimension requiring dedicated training
- **Alignment is the hidden enemy**: RLHF systematically suppresses creative entropy; future ideation-focused models may need alignment strategies that preserve rather than penalize novelty
- **Transformational creativity is the frontier**: The hardest and most valuable capability — generating ideas that reshape the problem space — remains essentially unsolved

---

## Sources

1. [CreativeDC: Divergent-Convergent Thinking in LLMs, arXiv:2512.23601](https://arxiv.org/html/2512.23601v1) — Two-phase prompting for LLM creative problem generation
2. [LiveIdeaBench: Evaluating LLMs' Scientific Creativity, arXiv:2412.17596](https://arxiv.org/html/2412.17596v1) — Benchmark for divergent thinking across 40+ models, 1180 keywords
3. [LLMs for Scientific Idea Generation: A Creativity-Centered Survey, arXiv:2511.07448](https://arxiv.org/html/2511.07448) — Comprehensive survey of five method families
4. [Can LLMs Generate Novel Research Ideas?, arXiv:2409.04109](https://arxiv.org/abs/2409.04109) — 100+ NLP researcher human study on LLM vs human novelty
5. [AutoTRIZ, arXiv:2403.13002](https://arxiv.org/abs/2403.13002) — LLM automation of TRIZ methodology
6. [Tree of Thoughts, Princeton NeurIPS 2023](https://github.com/princeton-nlp/tree-of-thought-llm) — Deliberate problem solving with branching thought trees
7. [Graph of Thoughts, arXiv:2308.09687](https://arxiv.org/abs/2308.09687) — Graph-structured thought exploration beyond trees
8. [LLM Discussion Framework, arXiv:2405.06373](https://arxiv.org/abs/2405.06373) — Three-phase discussion + role-play for creativity
9. [Self-Refine, arXiv:2303.17651](https://arxiv.org/abs/2303.17651) — Iterative self-feedback refinement without supervised training
10. [Diverse Preference Optimization (DivPO), arXiv:2501.18101](https://arxiv.org/html/2501.18101) — Meta's diversity-injecting training method
11. [GPS Framework, arXiv:2410.11877](https://arxiv.org/abs/2410.11877) — Goals-Prompts-Strategies for designer-LLM brainstorming
12. [Divergent Creativity in Humans and LLMs, Nature Scientific Reports](https://www.nature.com/articles/s41598-025-25157-3) — DAT/AUT comparison of human vs model creativity
13. [Large-Scale Comparison of Divergent Creativity, Nature Human Behaviour](https://www.nature.com/articles/s41562-025-02331-1) — Humans vs LLMs on DAT at scale
14. [Has LLM Creativity Peaked?, ScienceDirect](https://www.sciencedirect.com/science/article/pii/S2713374525000202) — Inter- and intra-LLM creativity variability analysis
15. [AI Outperforms Humans in AUT, ScienceDaily](https://www.sciencedaily.com/releases/2024/03/240301134758.htm) — LLM scores on standardized creative potential tests
16. [Multi-Agent Debate Improves LLM Factuality, arXiv:2305.14325](https://arxiv.org/abs/2305.14325) — Multiagent debate reduces hallucinations and improves reasoning
17. [Human Creativity in the Age of LLMs, CHI 2025](https://dl.acm.org/doi/full/10.1145/3706598.3714198) — LLM assistance homogenization effect on human creativity
18. [AIdeation, CHI 2025](https://dl.acm.org/doi/10.1145/3706598.3714148) — Human-AI collaborative ideation system design
19. [IdeationWeb, CHI 2025](https://dl.acm.org/doi/10.1145/3706598.3713375) — Tracking idea evolution in human-AI co-creation
20. [Is Temperature the Creativity Parameter of LLMs?, arXiv:2405.00492](https://arxiv.org/html/2405.00492v1) — Temperature vs semantic diversity empirical study
21. [Control the Temperature: Selective Sampling, arXiv:2510.01218](https://arxiv.org/html/2510.01218) — Advanced sampling for diverse and high-quality outputs
22. [Human Analogical Guidance Amplifies LLM Performance, Nature Communications](https://www.nature.com/articles/s41467-026-70873-7) — 10x improvement through analogical bridging
23. [Microsoft GraphRAG](https://microsoft.github.io/graphrag/) — Graph-structured knowledge retrieval for AI
24. [Graph RAG and LLMs for AI Ideation, Nodus Labs](https://noduslabs.com/featured/graph-rag-and-llms-how-knowledge-graphs-can-improve-ai-ideation/) — KG integration for improved AI brainstorming
25. [DivPO MarkTechPost](https://www.marktechpost.com/2025/02/03/this-ai-paper-from-meta-introduces-diverse-preference-optimization-divpo-a-novel-optimization-method-for-enhancing-diversity-in-large-language-models/) — Meta DivPO results summary
26. [Diversity Tuning for Creative Writing, arXiv:2503.17126](https://arxiv.org/html/2503.17126) — Post-training modification for diverse creative output
27. [Design Creativity in AI: SCAMPER, Cambridge Core](https://www.cambridge.org/core/journals/ai-edam/article/design-creativity-in-ai-using-the-scamper-method/A6C81AB782B52FB9DD0C64F407DD7C63) — SCAMPER methodology with AI
28. [SCAMPER at ScienceDirect AutoTRIZ](https://www.sciencedirect.com/science/article/pii/S1474034625002058) — AutoTRIZ and extensions to SCAMPER
29. [Role Prompting Guide, LearnPrompting](https://learnprompting.org/docs/advanced/zero_shot/role_prompting) — Persona-based task framing
30. [PersonaFlow, ACM DIS 2025](https://dl.acm.org/doi/10.1145/3715336.3735789) — Expert personas for research ideation
31. [Chain-of-Thought Prompting Guide](https://www.promptingguide.ai/techniques/cot) — Core CoT methodology
32. [Cross-Lingual-Thought Prompting, arXiv:2305.07004](https://arxiv.org/abs/2305.07004) — XLT for multilingual capability and diversity
33. [CogGRAG, arXiv:2503.06567](https://arxiv.org/html/2503.06567v2) — Mind-map RAG for complex problem solving
34. [AutoTRIZ ASME IDETC-CIE 2024](https://asmedigitalcollection.asme.org/IDETC-CIE/proceedings-abstract/IDETC-CIE2024/88377/V03BT03A055/1208928) — Conference version of AutoTRIZ
35. [LLM-Powered Multi-Agent Systems and Human Creativity, ACM CI 2025](https://dl.acm.org/doi/10.1145/3715928.3737479) — Evidence from brainstorming tasks
36. [Enhancing Designer Creativity through Human-AI Co-Ideation, Cambridge AI EDAM](https://www.cambridge.org/core/journals/ai-edam/article/enhancing-designer-creativity-through-humanai-coideation-a-cocreation-framework-for-design-ideation-with-custom-gpt/BCC2CBE43EECE6F0D937BBC0D2F44868) — Co-creation framework for design ideation
37. [IBM Tree of Thoughts](https://www.ibm.com/think/topics/tree-of-thoughts) — ToT prompting overview
38. [Sequoia: Generative AI's Act o1](https://sequoiacap.com/article/generative-ais-act-o1/) — Inference-time scaling and reasoning era
39. [Sebastian Raschka: State of LLM Reasoning](https://magazine.sebastianraschka.com/p/state-of-llm-reasoning-and-inference-scaling) — Inference scaling categories
40. [Evaluating Diversity and Quality of LLM Generated Content, OpenReview](https://openreview.net/forum?id=O7bF6nlSOD) — Effective semantic diversity framework

---

## Methodology

Searched 14 query variations across web sources covering: ideation techniques, prompt engineering, divergent/convergent thinking, multi-agent frameworks, structured methodologies (TRIZ, SCAMPER), evaluation benchmarks, temperature/sampling diversity, human-AI co-creativity, parameter-level adaptation (DivPO, CRPO), RAG/knowledge graphs for ideation, inference-time scaling, self-refinement, persona prompting, multilingual prompting, and the alignment-creativity trade-off. Fully analyzed 5 primary sources (full-text fetch): CreativeDC paper, LiveIdeaBench paper, Scientific Idea Generation Survey, AutoTRIZ paper, and the Can LLMs Generate Novel Research Ideas? study. Cross-referenced 35+ additional sources via search synthesis.

Sub-questions investigated:
1. What are the core failure modes of LLMs in ideation tasks?
2. What prompt engineering techniques best enhance LLM ideation quality and diversity?
3. How do multi-agent collaboration frameworks improve idea generation?
4. What structured ideation methodologies (TRIZ, SCAMPER, morphological analysis) have been adapted for LLMs?
5. How do sampling parameters (temperature, min-p) affect ideation diversity?
6. What parameter-level training methods explicitly improve creative output?
7. How does knowledge augmentation (RAG, knowledge graphs) affect ideation?
8. How are LLM ideation capabilities evaluated and benchmarked?
9. How do human-AI collaborative ideation systems compare to solo approaches?
10. What is the alignment-creativity trade-off and how can it be addressed?
