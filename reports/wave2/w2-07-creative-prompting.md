# Divergent-Convergent Prompting and Creative LLM Techniques: Deep Research Report

*Generated: 2026-04-14 | Sources: 22 | Confidence: High*

---

## Executive Summary

The 2024–2025 research landscape reveals a maturing field of creative LLM prompting, converging on two key insights: (1) explicitly decoupling idea-generation from constraint-satisfaction dramatically increases novelty and diversity, and (2) structured persona/role frameworks (TRIZ, Six Thinking Hats, debate archetypes) systematically widen the semantic coverage of generated ideas. Classical creativity methodologies — TRIZ, SCAMPER, morphological analysis, Design-by-Analogy — have been successfully automated as LLM knowledge-retrieval layers. The dominant architectural pattern is a two-phase pipeline: unconstrained divergent exploration followed by constraint-satisfying convergent refinement, with persona or multi-agent mechanisms optionally applied to each phase.

---

## 1. Core Divergent-Convergent Frameworks

### 1.1 CreativeDC
**Source:** [Divergent-Convergent Thinking in LLMs for Creative Problem Generation](https://arxiv.org/abs/2512.23601) (Dec 2025)

**Mechanism:** Two-phase prompting that explicitly decouples exploration from constraint satisfaction.

- **Divergent Phase:** The prompt instructs the model to generate "wildly different, unconventional, unusual, surprising, diverse ideas" while *temporarily ignoring all task constraints*. Temperature is raised to widen the sampling distribution. The model explores without the cognitive burden of satisfying requirements.
- **Convergent Phase:** From the brainstormed pool, the model selects one promising idea and iteratively refines it to satisfy all constraints. If a chosen idea fails, the model backtracks and tries another.
- **Persona Simulation Augmentation:** Diverse personas (from the Persona Hub dataset) are injected into divergent-phase prompts to force multi-perspective exploration, combating the "Artificial Hivemind" effect where all samples cluster around statistically dominant responses.

**Theoretical Foundation:** Wallas's four-stage creativity model (preparation → incubation → illumination → verification) and Guilford's divergent-convergent framework.

**Measured Outcomes:**
- +51.5% semantic novelty vs. Base prompting
- +63.5% semantic novelty vs. Chain-of-Thought
- +72% Vendi score (effective distinct problems) at K=100
- Utility maintained at ~90%, demonstrating quality is preserved alongside diversity

---

### 1.2 Dual Persona Scaffolding
**Source:** [Scaffolding Creativity: How Divergent and Convergent LLM Personas Work](https://arxiv.org/pdf/2510.26490) (Oct 2025)

**Mechanism:** Assigns distinct LLM personality profiles aligned to each creative phase:
- **Divergent Persona:** Instructed to be expansive, associative, non-judgmental, risk-taking — encourages users to generate more novel ideas
- **Convergent Persona:** Instructed to be evaluative, rigorous, critical, selection-oriented — improves solution quality and feasibility

**Key Finding:** Strategic personality deployment outperforms neutral AI interaction for both idea quantity and quality. Users with divergent personas generate more novel ideas; users with convergent personas produce higher-quality final solutions.

---

### 1.3 GPS Framework (Goal-Prompt-Strategy)
**Source:** [A Framework for Collaborating a Large Language Model Tool in Brainstorming](https://arxiv.org/html/2410.11877v1) (2025)

**Mechanism:** Three-layer architecture guiding systematic LLM brainstorming:

**Goal Level:** Determines whether the session targets divergence (expand idea space) or convergence (refine options).

**Prompt Level:** Decomposes prompts into structured components — Who (role/audience), What (context/task/constraints/objectives), Where (environment), Supporting Information, Output Expectations.

**Strategy Level — 9 Prompting Techniques:**
1. **Chain-of-Thoughts (Multi-steps):** Decomposes complex problems into sequential reasoning steps
2. **Unconventional Role in Context:** Assigns novel, non-standard stakeholder perspectives
3. **Flipped Interaction:** Reverses roles — LLM poses questions to elicit user information
4. **Analogy (One-shot/Few-shots):** Provides examples including imaginary scenarios to guide output style
5. **Alternative Approaches:** Explicitly requests multiple perspectives rather than a singular answer
6. **Emphasis:** Uses emotional or intensity language to highlight critical aspects
7. **Reflection:** Prompts the model to explain its reasoning behind suggestions
8. **Environment Change:** Alters contextual conditions of the problem space
9. **Self-Refinement:** Requests the LLM evaluate and improve its own prior output

**Creativity Metrics (adapted Torrance TTCT):** Fluency, Flexibility, Originality, Elaboration

---

## 2. Classical Creativity Methodologies Automated via LLMs

### 2.1 AutoTRIZ (Theory of Inventive Problem Solving)
**Source:** [AutoTRIZ: Artificial Ideation with TRIZ and LLMs](https://arxiv.org/html/2403.13002v2) (2024, published ScienceDirect 2025)

**Mechanism:** Four-module pipeline automating TRIZ via LLM reasoning + deterministic knowledge retrieval:

1. **Module 1 — Problem Identification:** LLM extracts and clarifies core problem from raw user input
2. **Module 2 — Contradiction Detection:** LLM maps problem to pairs of the 39 TRIZ Engineering Parameters (improving vs. worsening features), identifying the core contradiction
3. **Module 3 — Principle Retrieval (deterministic):** Non-LLM lookup of the 39×39 Contradiction Matrix returns applicable Inventive Principles
4. **Module 4 — Solution Generation:** LLM synthesizes problem description + contradiction + principles into structured solution reports

**TRIZ Knowledge Components:**
- 39 Engineering Parameters (e.g., "Weight of moving object," "Area of stationary object")
- 40 Inventive Principles (e.g., Segmentation, Extraction, Mechanical Substitution, Strong Oxidants)
- Contradiction Matrix (39×39 grid)

**Architecture Note:** Uses "in-context learning" for zero-shot reasoning — no fine-tuning required. The paper proposes this architecture as a template extensible to SCAMPER, Design Heuristics, and Design-by-Analogy.

**Tool:** Public demo at https://www.autotriz.ai/

---

### 2.2 TRIZ Agents (Multi-Agent Extension)
**Source:** [TRIZ Agents: A Multi-Agent LLM Approach for TRIZ-Based Innovation](https://arxiv.org/abs/2506.18783) (2025)

**Mechanism:** Multi-agent system where each agent has specialized TRIZ capabilities and tool access, collaboratively solving inventive problems. Extends AutoTRIZ from single-model to collaborative agent network.

---

### 2.3 SCAMPER Applied to LLMs
**Source:** [Design Creativity in AI: Using the SCAMPER Method — Cambridge Core](https://www.cambridge.org/core/journals/ai-edam/article/design-creativity-in-ai-using-the-scamper-method/A6C81AB782B52FB9DD0C64F407DD7C63)

**Mechanism:** The SCAMPER checklist (Substitute, Combine, Adapt, Modify/Magnify, Put to other uses, Eliminate, Reverse) applied as a structured prompting scaffold — each letter becomes a distinct prompt directive guiding the LLM to transform an existing concept in a specific way.

**AutoTRIZ Extension:** AutoTRIZ paper explicitly proposes SCAMPER as a next-layer module: each SCAMPER operation becomes a knowledge-base entry, with LLM reasoning applied per operation.

---

## 3. Multi-Perspective / Role-Structuring Frameworks

### 3.1 LLM Discussion (Three-Phase Debate)
**Source:** [LLM Discussion: Enhancing Creativity via Discussion Framework and Role-Play](https://arxiv.org/html/2405.06373v1) (2024)

**Mechanism:** Emulates human collective creativity through structured group discussion:

1. **Initiation Phase:** Sets group context ("you are in a group discussion with other teammates")
2. **Discussion Phase:** Multiple rounds where each LLM agent receives all other agents' responses and is encouraged to "build on ideas of others *as well as* diverge and generate their own answers" — explicitly combining convergent synthesis with divergent generation
3. **Convergence Phase:** Directs agents to "finalize and present a list of creative answers" synthesizing the discussion

**Role Assignment:** Each LLM is given a distinct persona that persists throughout all rounds, options including:
- Diverse background roles: Visionary Millionaire, Startup Founder, Social Entrepreneur, Futurist
- Six Thinking Hats roles: White (facts/data), Red (emotions/intuition), Black (critical judgment), Yellow (optimism/benefits), Green (creativity/new ideas), Blue (process management)

---

### 3.2 Six Thinking Hats (De Bono) for LLMs
**Source:** [Six Thinking Chatbots: A Creativity Technique](https://ceur-ws.org/Vol-3672/CreaRE-paper1.pdf)

**Mechanism:** Six distinct LLM chat sessions, each assigned one hat color/mode, produce perspectives that are then synthesized. Forces structured coverage of factual, emotional, critical, optimistic, creative, and meta-process viewpoints.

**Hats:**
- White: Facts and data only
- Red: Emotional responses and intuition
- Black: Critical judgment and caution
- Yellow: Optimistic benefits and value
- Green: New ideas, alternatives, provocations
- Blue: Process control and synthesis

---

### 3.3 BILLY (Blending Persona Vectors)
**Source:** [BILLY: Steering LLMs via Merging Persona Vectors for Creative Generation](https://arxiv.org/html/2510.10157v1) (2025)

**Mechanism:** Training-free framework that extracts multiple distinct persona vectors from a model's activation space and *blends them directly* during inference — without any prompt overhead. Captures multi-LLM collaboration benefits inside a single model pass.

---

### 3.4 Town Hall Debate Prompting
**Source:** Found via [PromptHub Blog on Role-Prompting](https://www.prompthub.us/blog/role-prompting-does-adding-personas-to-your-prompts-really-make-a-difference)

**Mechanism:** Multiple LLM instantiations as distinct "expert" personas engage in structured debate: each defends a position, critiques others, then votes on the best synthesis. Achieves +13% accuracy improvement on logic puzzles for GPT-4o.

---

## 4. Analogical Reasoning Techniques

### 4.1 Analogical Prompting (Self-Generated Exemplars)
**Source:** [Large Language Models as Analogical Reasoners](https://arxiv.org/abs/2310.01714) / [Analogical Prompting — LearnPrompting](https://learnprompting.org/docs/advanced/thought_generation/analogical_prompting)

**Mechanism:** Before solving a problem, the LLM is prompted to self-generate relevant analogous examples from its own knowledge, then uses those examples as in-context guides for the target problem. Eliminates need for labeled retrieval exemplars.

**Key Insight:** Self-generated analogies can match or exceed retrieved analogies in quality; the relevance of stimuli is less critical than structural similarity.

---

### 4.2 Thought Propagation
**Source:** [Thought Propagation: An Analogical Approach to Complex Reasoning — ICLR 2024](https://arxiv.org/abs/2310.03965)

**Mechanism:** Two-stage analogical reasoning:
1. Prompt LLM to propose and solve a set of analogous problems related to the input
2. Reuse analogous problem solutions to derive a new solution or a knowledge-intensive plan to amend the initial solution

**Measured outcomes:**
- +12% finding optimal solutions in Shortest-path Reasoning
- +13% improvement in human preference for Creative Writing
- +15% task completion rate in LLM-Agent Planning

---

### 4.3 Design-by-Analogy (Cross-Domain)
**Source:** [Analogical Reasoning with LLMs: A Co-Creative Framework — Cambridge Core](https://www.cambridge.org/core/journals/design-science/article/analogical-reasoning-with-large-language-models-a-cocreative-framework-and-benchmarking-of-llms-in-design-ideation/0B8149CCF53C45E1E1B78C4CA93E5BDC)

**Mechanism:** LLM generates analogical stimuli from cross-domain source spaces for design ideation. A Generative AI layer operates across all ideation stages, generating contextually relevant textual stimuli per stage. Useful for product design, engineering, and creative writing contexts.

---

## 5. Constraint-Based and Structured Prompting

### 5.1 Constraint Relaxation Prompting
**Mechanism (from CreativeDC):** Temporarily removes all task constraints during ideation, then re-applies them during refinement. The explicit instruction "ignore constraints for now" is the active prompt directive. Counterintuitive finding: removing constraints increases final solution quality as well as diversity, because the model reaches parts of idea space it would have pruned prematurely.

### 5.2 Temperature Modulation as Divergence Control
**Source:** [Divergent creativity in humans and LLMs — Scientific Reports](https://www.nature.com/articles/s41598-025-25157-3)

**Mechanism:** Temperature adjustment functions as the "variation" dial in LLM creativity — higher temperature broadens the semantic distribution of outputs, directly analogous to human divergent thinking. Optimal creative pipelines use high temperature for divergent phases and lower temperature for convergent phases.

---

## 6. Creativity Measurement Frameworks

### 6.1 Torrance Tests of Creative Thinking (TTCT) — Adapted
Four dimensions used across research to evaluate LLM creative output:
- **Fluency:** Quantity of distinct ideas generated
- **Flexibility:** Diversity across categories (topical breadth)
- **Originality:** Uniqueness and novelty of ideas (rated by human evaluators 0–10)
- **Elaboration:** Depth and detail in responses (rated by human evaluators 0–10)

### 6.2 Alternative Uses Task (AUT)
Standard divergent thinking benchmark — how many uses can be found for a common object? Used as primary LLM creativity benchmark in multiple 2025 studies.

### 6.3 Vendi Score
**Mechanism:** Measures effective number of semantically distinct outputs in a sample pool. Higher Vendi score = genuinely diverse outputs (not paraphrase cluster). Used in CreativeDC to demonstrate anti-hivemind effectiveness.

---

## Key Takeaways

1. **Decouple exploration from evaluation:** The single highest-impact technique in 2025 research is explicitly separating the divergent (constraint-free ideation) phase from the convergent (constraint-satisfying refinement) phase — implemented via CreativeDC, GPS, Dual Persona Scaffolding, and LLM Discussion all converging on this pattern.

2. **Classical creativity frameworks (TRIZ, SCAMPER, Six Hats) are now LLM-compatible:** AutoTRIZ shows the template: domain knowledge as a modular lookup layer + LLM reasoning for problem mapping and solution generation. The 40 Inventive Principles, SCAMPER operations, and Six Hat perspectives all function as structured prompt scaffolds.

3. **Personas increase diversity more reliably than temperature alone:** Multiple studies show persona injection (role-play, diverse background assignment, persona vector blending) increases output diversity and originality, especially for open-ended tasks.

4. **Analogical reasoning boosts creative problem solving:** Both Analogical Prompting and Thought Propagation show measurable gains by anchoring LLM generation to structural analogies, leveraging the model's cross-domain knowledge.

5. **Artificial Hivemind is the key failure mode:** Without explicit diversity mechanisms, sampling multiple outputs from the same LLM produces a cluster of semantically similar responses. CreativeDC's persona augmentation and LLM Discussion's role persistence are the primary countermeasures.

---

## All Named Techniques/Frameworks (Extraction)

| # | Technique / Framework | Mechanism Summary |
|---|---|---|
| 1 | **CreativeDC** | Two-phase: constraint-free divergence → constrained convergence |
| 2 | **Persona Simulation Augmentation** | Inject diverse personas during divergent phase (Persona Hub) |
| 3 | **Dual Persona Scaffolding** | Separate divergent/convergent LLM personality profiles |
| 4 | **GPS Framework** (Goal-Prompt-Strategy) | 3-layer: goal→prompt components→9 strategy types |
| 5 | **Chain-of-Thoughts (GPS Strategy 1)** | Sequential decomposition of complex problems |
| 6 | **Unconventional Role in Context (GPS Strategy 2)** | Non-standard stakeholder perspective assignment |
| 7 | **Flipped Interaction (GPS Strategy 3)** | LLM poses questions to elicit user information |
| 8 | **Analogy Prompting in GPS (Strategy 4)** | One-shot/few-shot examples including imaginary scenarios |
| 9 | **Alternative Approaches (GPS Strategy 5)** | Explicit multi-perspective output request |
| 10 | **Emphasis (GPS Strategy 6)** | Emotional/intensity language to highlight critical aspects |
| 11 | **Reflection (GPS Strategy 7)** | Model explains its own reasoning |
| 12 | **Environment Change (GPS Strategy 8)** | Contextual condition alteration |
| 13 | **Self-Refinement (GPS Strategy 9)** | Model evaluates and improves its own output |
| 14 | **AutoTRIZ** | 4-module TRIZ automation: problem ID → contradiction → principle lookup → solution |
| 15 | **TRIZ Agents** | Multi-agent extension of AutoTRIZ |
| 16 | **SCAMPER Prompting** | 7-operation checklist as structured prompt directives |
| 17 | **LLM Discussion (Three-Phase)** | Initiation → Discussion (multi-round) → Convergence with role persistence |
| 18 | **Six Thinking Hats** | 6 distinct chat sessions/agents per hat color, then synthesis |
| 19 | **BILLY (Persona Vector Blending)** | Training-free activation-space persona merging |
| 20 | **Town Hall Debate Prompting** | Multi-persona structured debate → vote synthesis |
| 21 | **Analogical Prompting (Self-Generated)** | LLM self-generates analogous examples before solving |
| 22 | **Thought Propagation** | Solve analogous problems first; propagate solutions to target |
| 23 | **Design-by-Analogy (Cross-Domain)** | LLM generates cross-domain analogical stimuli per ideation stage |
| 24 | **Constraint Relaxation Prompting** | Explicit "ignore constraints" directive during divergent phase |
| 25 | **Temperature Modulation** | High-T for divergence, low-T for convergence |
| 26 | **Wallas Creativity Stages** | Preparation → Incubation → Illumination → Verification (theoretical basis) |
| 27 | **Guilford D-C Framework** | Divergent/convergent thinking distinction (theoretical basis) |
| 28 | **TTCT Adaptation** | Fluency/Flexibility/Originality/Elaboration as LLM creativity metrics |
| 29 | **Alternative Uses Task (AUT)** | Standard divergent thinking benchmark |
| 30 | **Vendi Score** | Effective distinct outputs measure (anti-hivemind metric) |

---

## Sources

1. [Divergent-Convergent Thinking in LLMs for Creative Problem Generation](https://arxiv.org/abs/2512.23601) — CreativeDC paper (Dec 2025)
2. [Divergent creativity in humans and large language models](https://www.nature.com/articles/s41598-025-25157-3) — Scientific Reports 2025
3. [Human Creativity in the Age of LLMs: Randomized Experiments](https://arxiv.org/abs/2410.03703) — CHI 2025
4. [A Framework for Collaborating a Large Language Model Tool in Brainstorming](https://arxiv.org/html/2410.11877v1) — GPS Framework
5. [Scaffolding Creativity: How Divergent and Convergent LLM Personas Work](https://arxiv.org/pdf/2510.26490) — Dual Persona Scaffolding
6. [AutoTRIZ: Artificial Ideation with TRIZ and LLMs](https://arxiv.org/html/2403.13002v2) — AutoTRIZ methodology
7. [AutoTRIZ in ScienceDirect](https://www.sciencedirect.com/science/article/pii/S1474034625002058) — Published journal version
8. [TRIZ Agents: A Multi-Agent LLM Approach](https://arxiv.org/abs/2506.18783) — Multi-agent TRIZ extension
9. [Design Creativity in AI: Using the SCAMPER Method](https://www.cambridge.org/core/journals/ai-edam/article/design-creativity-in-ai-using-the-scamper-method/A6C81AB782B52FB9DD0C64F407DD7C63) — SCAMPER for AI
10. [LLM Discussion: Enhancing Creativity via Discussion Framework and Role-Play](https://arxiv.org/html/2405.06373v1) — Three-phase discussion
11. [Six Thinking Chatbots: A Creativity Technique](https://ceur-ws.org/Vol-3672/CreaRE-paper1.pdf) — Six Hats for LLMs
12. [BILLY: Steering LLMs via Merging Persona Vectors](https://arxiv.org/html/2510.10157v1) — Persona vector blending
13. [Beyond Basic Prompts: Directing LLMs with Convergent and Divergent System Instructions](https://ailookingglass.blogspot.com/2025/05/beyond-basic-prompts-directing-llms.html) — Practical guide
14. [Large Language Models as Analogical Reasoners](https://arxiv.org/abs/2310.01714) — Analogical prompting
15. [Thought Propagation: An Analogical Approach to Complex Reasoning](https://arxiv.org/abs/2310.03965) — ICLR 2024
16. [Analogical Reasoning with LLMs: A Co-Creative Framework](https://www.cambridge.org/core/journals/design-science/article/analogical-reasoning-with-large-language-models-a-cocreative-framework-and-benchmarking-of-llms-in-design-ideation/0B8149CCF53C45E1E1B78C4CA93E5BDC) — Design-by-Analogy
17. [Assessing and Understanding Creativity in Large Language Models](https://link.springer.com/article/10.1007/s11633-025-1546-4) — Springer 2025
18. [Creativity in LLM-based Multi-Agent Systems: A Survey](https://aclanthology.org/2025.emnlp-main.1403.pdf) — EMNLP 2025 survey
19. [Evaluating LLMs' Divergent Thinking for Scientific Idea Generation](https://arxiv.org/html/2412.17596) — Dec 2024
20. [Role Prompting: Does Adding Personas Really Make a Difference?](https://www.prompthub.us/blog/role-prompting-does-adding-personas-to-your-prompts-really-make-a-difference) — PromptHub blog
21. [Fluid Transformers and Creative Analogies: Cross-Domain Analogical Creativity](https://dl.acm.org/doi/fullHtml/10.1145/3591196.3593516) — ACM
22. [Benchmarking Language Model Creativity](https://aclanthology.org/2025.naacl-long.141.pdf) — NAACL 2025

---

## Methodology

Searched 7 queries across web and news. Analyzed 22 sources (5 deep-read, 17 from search snippets).

Sub-questions investigated:
1. What are the primary divergent-convergent prompting frameworks for LLM creativity?
2. How are TRIZ and SCAMPER integrated into LLM prompting systems?
3. What role do personas and role-play frameworks play in creative generation?
4. How does analogical reasoning enhance LLM creative problem-solving?
5. What creativity measurement frameworks are used to evaluate LLM outputs?
