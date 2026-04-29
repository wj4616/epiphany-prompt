# ReAct, Reflexion, and Agentic Prompting Patterns: Deep Research Report
*Generated: 2026-04-14 | Sources: 30+ | Confidence: High*

## Executive Summary

Agentic prompting patterns have matured from academic research (2022-2023) into production-grade frameworks deployed at scale (2024-2026). The core paradigms — ReAct (reason+act interleaved), Reflexion (verbal reinforcement), Plan-and-Execute (separated planning/execution), and ReWOO (decoupled reasoning from observations) — form a foundational taxonomy. These are now being systematically combined with LLM orchestration frameworks (LangGraph, AutoGen, CrewAI) and optimization tools (DSPy) for production deployment. Multiple 2025 surveys synthesize the field across four agent dimensions: reasoning, action, memory, and collaboration. Key 2025 trends: CodeAct (code as action space), multi-agent debate for evaluation, and Anthropic's Agent SDK formalizing production agentic architecture.

---

## 1. Foundational Agentic Reasoning Patterns

### ReAct — Reasoning and Acting (Yao et al., 2022 → ICLR 2023)
**Mechanism:** Interleaves "Thought" (reasoning trace) and "Action" (tool call or environment step) at every decision point. The explicit "Thought" step serves multiple purposes: decomposes complex tasks, tracks progress, handles exceptions, updates plans based on observation results. Actions interface with external sources (search engines, APIs, databases).

**Format per step:**
```
Thought: [reasoning about what to do next]
Action: [tool_name(args)]
Observation: [tool result]
Thought: [updated reasoning based on result]
...
Final Answer: [response]
```

**Key result:** Outperforms Chain-of-Thought alone (no action) and Acting alone (no reasoning) across HotPotQA, FEVER, AlfWorld, WebShop. Improved human interpretability and trustworthiness.

**Extensions:**
- **ReSpAct (2024):** Adds dynamic dialogue capability — agent can ask clarifying questions alongside reasoning and acting. Outperforms ReAct on task completion.
- **State Machine Reasoning (SMR, 2025):** Transition-based reasoning with discrete states, early stopping, fine-grained control over reasoning paths.

**Source:** https://arxiv.org/abs/2210.03629

---

### Reflexion — Verbal Reinforcement Learning (Shinn et al., NeurIPS 2023)
**Mechanism:** Agents learn from trial-and-error without updating model weights. Three-component loop:
1. **Actor:** Generates text/actions for the task
2. **Evaluator:** Scores the actor's output (reward signal can be binary, heuristic, or LLM-based)
3. **Self-Reflection model:** Given failure feedback, generates a verbal reflection stored in episodic memory buffer

The reflection summary is prepended to the next trial's context — acting as a lightweight, language-based "weight update." Across trials, the episodic buffer accumulates lessons learned.

**Key results:**
- 91% pass@1 on HumanEval coding (vs. 80% for GPT-4 baseline)
- 20% improvement on HotPotQA reasoning
- Strong across sequential decision-making (AlfWorld), coding, and reasoning tasks

**Limitation:** Memory buffer can fill context; reflection quality depends on evaluator accuracy.

**Source:** https://arxiv.org/abs/2303.11366

---

### Self-Refine — Iterative Self-Feedback (Madaan et al., 2023)
**Mechanism:** Single LLM acts as both generator and critic. Loop:
1. Generate initial output
2. Same LLM provides feedback on its output ("what's wrong with this?")
3. Same LLM refines output based on feedback
4. Repeat until stopping criterion

**No training required.** No separate evaluation model needed. Works with GPT-3.5/4 out-of-the-box.

**Key result:** ~20% absolute improvement on average across 7 diverse tasks vs. one-shot generation. Humans prefer Self-Refine outputs over conventional generation.

**Limitation:** **Self-bias** — LLMs tend to view their own generated text favorably; insufficient criticism leads to stagnation or quality decrease after several iterations.

**Source:** https://arxiv.org/abs/2303.17651

---

### Chain-of-Thought (CoT) — The Reasoning Baseline
**Mechanism:** Prompts LLM to generate intermediate reasoning steps before answering. Enables complex multi-step reasoning by making reasoning explicit. Foundational to all agentic reasoning patterns.

**Variants:**
- **Standard CoT:** "Let's think step by step"
- **Few-shot CoT:** Provide exemplars with reasoning chains
- **Zero-shot CoT:** Single instruction triggers self-generated reasoning

---

### Tree-of-Thoughts (ToT)
**Mechanism:** Frames CoT as a search over a tree of partial reasoning paths. At each node, the LLM generates multiple thought candidates; a value function (LLM or heuristic) evaluates which branches to expand. Supports **lookahead** and **backtracking** — unlike linear CoT.

**Best for:** Problems where intermediate reasoning can be wrong and benefit from exploration/correction.

---

### Graph-of-Thoughts (GoT) and Extensions
**Mechanism:** Extends tree to arbitrary graph structures — thoughts can merge, split, and recombine. Handles problems with interdependencies between reasoning sub-problems that don't fit linear or tree topologies.

**Adaptive Graph of Thoughts (AGoT, 2025):** Dynamically adapts graph topology based on task complexity; combines branching of ToT with GoT generality.

**Framework of Thoughts (FoT, 2025):** Foundation framework implementing chains, trees, or graphs as composable graph-of-operations where nodes can be LLM calls, tool calls, or code executions.

**Source:** https://arxiv.org/abs/2401.14295 | https://arxiv.org/abs/2502.05078

---

## 2. Plan-and-Execute / Separated Planning Patterns

### Plan-and-Execute (P-t-E) Pattern
**Mechanism:** Separates strategic planning from tactical execution:
- **Planner:** LLM generates a multi-step plan (ordered list or graph of steps) for the entire task
- **Executor:** Accepts the user query + one plan step at a time; invokes 1+ tools to complete each step

**Advantage over ReAct:** Forces the planner to "think through all steps" before any actions are taken. More predictable, cost-efficient, and better at complex tasks with many steps.

**Execute → Re-plan → Execute loop (LangGraph, 2024):** After execution, a replan node inspects results and decides if the original plan is still viable — converting rigid P-t-E into an adaptive cycle.

**Plan-and-Act (2025):** Incorporates explicit planning into long-horizon agents. Planner generates structured high-level plans; Executor translates into environment-specific actions.
**Source:** https://arxiv.org/abs/2503.09572

---

### ReWOO — Reasoning WithOut Observation (Xu et al., ICLR 2024)
**Mechanism:** Decouples the reasoning (planning) phase from the observation (execution) phase entirely. Three-component architecture:
1. **Planner:** Generates the complete multi-step plan with placeholders for tool results — does NOT see tool results yet
2. **Worker:** Executes all tool calls in the plan — potentially **in parallel** since dependencies are pre-specified
3. **Solver:** Integrates all tool results with the original plan to generate the final answer

**Why it works:** Because the Planner has pre-specified inputs for each tool step, Worker tasks with no dependencies can execute in parallel. The LLM is called only twice (Planner + Solver) vs. N times in ReAct (once per step).

**Key result:** 5x token efficiency vs. ReAct; +4% accuracy improvement on HotPotQA multi-step reasoning.

**Integration with DSPy:** DSPy optimizes the Planner and Solver prompts automatically, dramatically improving reliability.

**Source:** https://arxiv.org/abs/2305.18323

---

## 3. Action Space Patterns

### Tool Use / Function Calling
**Core pattern:** LLM generates a structured function call (name + arguments); host system executes the function; result injected back into context.

**Production evolution (2025):**
- **Dynamic Tool Discovery:** Tool Registry (MCP or vector store) is queried at runtime to find relevant tools based on user intent — prevents context window saturation from large tool catalogs. Reduces token usage by 85% (77k → 8.7k tokens for large catalogs).
- **Programmatic Tool Calling (Anthropic, 2025):** LLM writes code that calls multiple tools and processes their outputs — orchestrating tool sequences without individual API round-trips. Claude controls which information enters its context window.

**Production challenges:**
- Tool selection accuracy drops as tool catalog grows (Berkeley Function Calling Leaderboard finding)
- 58 tools can consume ~55k context tokens if all definitions loaded
- Need explicit documentation contracts: purpose, examples, argument types

**Source:** https://www.promptingguide.ai/agents/function-calling

---

### CodeAct — Executable Code as Action Space (Wang et al., ICML 2024)
**Mechanism:** Uses executable Python code as the unified action space instead of JSON/text actions. The LLM generates Python code that can use any library, define functions, call tools, and self-debug. Integrated with a Python interpreter for interactive feedback.

**Key advantages over text/JSON actions:**
- Dynamic composition: Code can combine multiple tool calls in a single action
- Self-debugging: Execution errors become observations for iterative correction
- Reusable functions: Defined in one turn, callable in subsequent turns
- Up to 20% higher success rate vs. text/JSON actions across 17 LLMs tested

**Framework:** LangGraph released `langgraph-codeact` library for production CodeAct implementation.

**Source:** https://arxiv.org/abs/2402.01030

---

## 4. Voyager — Lifelong Learning Agent Pattern
**Paper:** Voyager: An Open-Ended Embodied Agent with LLMs (Wang et al., 2023)

**Three-component architecture for lifelong learning:**
1. **Automatic Curriculum:** Maximizes exploration; proposes increasingly complex tasks based on current skill level and world state
2. **Skill Library:** Ever-growing library of verified executable code skills. New skills are stored; retrieval via embedding similarity enables reuse in new contexts
3. **Iterative Prompting Mechanism:** Per task: generate code → execute → observe errors/feedback → self-verify → improve. Incorporates environment feedback, execution errors, and self-verification

**Key results:** 3.3x more unique items, 2.3x longer distances traveled, key milestones up to 15.3x faster than prior SOTA in Minecraft. Generalizes to new worlds using accumulated skills.

**Production implication (per industry analysis):** Skill Libraries for LLMs may become a competitive moat — proprietary libraries of verified, reusable agent behaviors.

**Source:** https://arxiv.org/abs/2305.16291

---

## 5. Multi-Agent Systems and Debate Patterns

### Multi-Agent Debate (MAD)
**Mechanism:** Multiple LLM agents with different roles (or the same model instantiated multiple times) debate a question — arguing for and against positions. A judge/moderator synthesizes the consensus. Adversarial framing elicits better counterarguments than single-agent self-critique.

**Applications:**
- Hallucination mitigation
- Fact verification / claim checking
- Complex reasoning tasks
- Machine translation quality estimation
- LLM evaluation (Agent-as-a-Judge)

**2025 frameworks:**
- **PROClaim:** Structured legal-system-inspired debate with explicit Plaintiff, Defense, Judge, Critic, and Expert Witness roles + evidence admission protocols
- **CourtEval:** Court-format multi-agent evaluation; achieves state-of-the-art alignment with human judgments
- **Multi-Agent Debate for LLM Judges (2025):** Adaptive stability detection to terminate when consensus is reached

**Production benefit:** Multi-agent debate consistently outperforms single-agent approaches on complex tasks. One study: 100% actionable recommendation rate vs. 1.7% for single-agent.

**Source:** https://arxiv.org/html/2510.12697v1

---

### Orchestration Patterns (2025)

**Three patterns that survive production** (from analysis of 1,200+ deployments, ZenML 2025):
1. **Simple Chains** — Handle 80% of production use cases; linear workflows
2. **Router Patterns** — Task classification directing to specialized agents/tools
3. **Agent Loops** — Open-ended problems requiring dynamic replanning

**Architectural debate: Orchestration vs. Choreography**
- **Orchestration:** Central controller directs agents; predictable, easier to audit
- **Choreography:** Agents coordinate peer-to-peer via events; more resilient, harder to debug

**Production patterns borrowed from distributed systems:**
- Circuit breakers for failure recovery
- Saga patterns for compensation (undo sequences)
- Immutable state with versioning
- Data contracts between agents

---

### Framework Comparison (2025)

| Framework | Paradigm | Best For | Scaling Limit |
|-----------|---------|---------|--------------|
| **LangGraph** | Directed graph with conditional edges | Production workflows requiring fine-grained state control and conditional routing | Scales linearly (O(1) per node added) |
| **CrewAI** | Role-based crews | Workflows with clear role specialization (customer support, content generation) | ~5 agents before coordination overhead grows |
| **AutoGen/AG2** | Conversational GroupChat | Research, collaborative problem-solving | Poor — 20+ LLM calls per task; each agent multiplies conversation turns |
| **Microsoft Agent Framework** | Merged AutoGen + Semantic Kernel | Enterprise Azure integration | GA Q1 2026; multi-language (C#, Python, Java) |

**Source:** https://www.datacamp.com/tutorial/crewai-vs-langgraph-vs-autogen

---

## 6. Anthropic's Agentic Systems Framework

**Anthropic "Building Effective AI Agents" principles (2025):**
- Start simple: use LLM APIs directly; avoid frameworks until necessary
- **Workflows** = LLMs + tools in predefined code paths
- **Agents** = LLMs dynamically direct their own processes and tool usage
- Simple, composable patterns beat complex frameworks

**6 Composable Agent Patterns (Anthropic taxonomy):**
1. Prompt chaining (sequential LLM calls)
2. Routing (classify → direct to specialized handler)
3. Parallelization (simultaneous independent tasks)
4. Orchestrator-subagents (manager + worker agents)
5. Evaluator-optimizer (generate + critique loop)
6. Autonomous agents (full dynamic control)

**Agent SDK principle:** "Give your agent a computer" — agents work like humans by using computer interfaces, not just APIs.

**Source:** https://www.anthropic.com/research/building-effective-agents

---

## 7. Production Agentic Prompting Best Practices

### Reliability Patterns
- **Explainability gates:** Before every tool call, require a one-line reason; after, require a short observation. Boosts traceability and reduces infinite loops.
- **Retry with exponential backoff:** Standard for tool failures
- **Validation gates:** Reject/fix/escalate before tool execution — no silent failures
- **Human-in-the-loop checkpoints:** Required for high-stakes actions; governance is a design feature, not an afterthought

### Prompt Design for Agentic Tasks
- Specify stopping conditions explicitly — agents need clear exit criteria
- Define error escalation paths — what to do when tools fail or produce unexpected outputs
- Use structured output formats for all agent-to-agent communication
- Separate system-level context (agent persona, capabilities) from task context (current goal, state)

### ReAct vs. ReWOO vs. P-t-E Selection Guide
| Pattern | Use When | Token Cost | Parallelism |
|---------|---------|----------|------------|
| **ReAct** | Dynamic, unpredictable tasks; observation needed at each step | High (N LLM calls) | No |
| **Plan-and-Execute** | Complex multi-step tasks with known structure; benefits from lookahead | Medium | Limited |
| **ReWOO** | Tasks with independent tool calls; need efficiency | Low (2 LLM calls) | Yes (Workers parallel) |

### DSPy Integration
Integrating DSPy into the Planner/Solver/Reasoning steps of ReAct, ReWOO, or CodeAct dramatically improves accuracy and stability — the LLM's reasoning prompts are compiled/optimized rather than hand-tuned.

---

## 8. Autonomous Agent Systems — Lessons from First-Gen (2023-2025)

**AutoGPT / BabyAGI / AgentGPT — Production Reality:**
- Model quality is critical: GPT-3.5 leads to significantly worse loops and coherence failures vs. GPT-4
- Cost unpredictability: Without guardrails, agents can exhaust API budgets
- Reliability gap: Still require heavy prompt-engineering and domain restriction for reliable production use
- Safety requirement: Most production deployments keep agents human-in-the-loop or narrow-domain restricted
- GitHub activity: Agentic AI framework repos surged 920% from early 2023 to mid-2025

**Voyager-inspired insight:** Skill Libraries as competitive moat — verifiable, reusable, composable behaviors stored and retrieved by embedding similarity.

---

## Key Takeaways

1. **ReAct is the interleaved standard** — every major agent framework implements it; extensions (ReSpAct, SMR) add dialogue and control flow
2. **ReWOO is the efficiency winner** — 5x token reduction via pre-planned parallel tool execution; best for structured tasks
3. **Reflexion solves the "trial-and-error without fine-tuning" problem** — verbal reinforcement learning in a context buffer
4. **Self-Refine is the simplest self-improvement pattern** — single LLM, no training, ~20% improvement; limited by self-bias
5. **CodeAct unifies action spaces** — code is more expressive than JSON/text; 20% higher success rate; natural self-debugging loop
6. **LangGraph dominates production** — graph-based state management, checkpointing, and conditional routing; CrewAI for rapid prototyping
7. **Multi-agent debate** significantly improves evaluation quality and complex reasoning vs. single-agent approaches
8. **Simple wins in production** — 80% of use cases handled by simple chains; agent loops only for genuinely open-ended tasks

---

## New Sub-Topics Identified for Further Research

1. **Process Reward Models (PRMs)** — step-level reward models for agentic reasoning (mentioned in survey, not deeply covered)
2. **Inception prompting** — technique for setting up autonomous cooperative agent dialogues via persona assignment and role-flip
3. **A-MEM and evolving memory architectures** — dynamic agent memory restructuring
4. **Agentic RAG** — combining ReAct/agentic patterns with advanced RAG for knowledge-intensive tasks
5. **Safety and constitutional constraints for agents** — Constitutional AI applied to multi-step autonomous systems
6. **Temporal credit assignment in agentic tasks** — attributing success/failure to specific reasoning steps in long agent trajectories
7. **Agent benchmarks and evaluation** — standardized evaluation of agentic systems (SWE-bench, WebArena, AgentBench)
8. **Agent skill/capability distillation** — transferring emergent agent capabilities to smaller models
9. **Long-horizon task decomposition** — breaking month-long tasks into agent-executable sub-tasks
10. **Human-agent collaboration patterns** — patterns for mixed-initiative human-AI teaming beyond simple HITL checkpoints

---

## Sources

1. [ReAct: Synergizing Reasoning and Acting in Language Models](https://arxiv.org/abs/2210.03629) — Yao et al., ICLR 2023
2. [ReAct Prompting Guide](https://www.promptingguide.ai/techniques/react) — Practical implementation guide
3. [Reflexion: Language Agents with Verbal Reinforcement Learning](https://arxiv.org/abs/2303.11366) — Shinn et al., NeurIPS 2023
4. [Self-Refine: Iterative Refinement with Self-Feedback](https://arxiv.org/abs/2303.17651) — Madaan et al., 2023
5. [ReWOO: Decoupling Reasoning from Observations](https://arxiv.org/abs/2305.18323) — Xu et al., ICLR 2024
6. [Plan-and-Execute Agents - LangChain Blog](https://blog.langchain.com/planning-agents/) — Pattern overview
7. [Plan-and-Act: Improving Planning for Long-Horizon Tasks](https://arxiv.org/abs/2503.09572) — 2025
8. [CodeAct: Executable Code Actions Elicit Better LLM Agents](https://arxiv.org/abs/2402.01030) — Wang et al., ICML 2024
9. [Voyager: Open-Ended Embodied Agent with LLMs](https://arxiv.org/abs/2305.16291) — Wang et al., 2023
10. [Demystifying Chains, Trees, and Graphs of Thoughts](https://arxiv.org/abs/2401.14295) — Survey 2024
11. [Adaptive Graph of Thoughts](https://arxiv.org/pdf/2502.05078) — AGoT, 2025
12. [Building Effective AI Agents - Anthropic](https://www.anthropic.com/research/building-effective-agents) — Official guidance
13. [Multi-Agent Debate for LLM Judges](https://arxiv.org/html/2510.12697v1) — 2025
14. [A Survey on LLM-based Autonomous Agents](https://arxiv.org/abs/2308.11432) — Comprehensive survey
15. [Agentic LLMs: A Survey](https://arxiv.org/abs/2503.23037) — 2025
16. [Agentic AI: Architectures, Taxonomies and Evaluation](https://arxiv.org/html/2601.12560v1) — 2025 taxonomy
17. [LangGraph vs AutoGen vs CrewAI - DataCamp](https://www.datacamp.com/tutorial/crewai-vs-langgraph-vs-autogen) — Framework comparison
18. [What 1,200 Production Deployments Reveal About LLMOps in 2025 - ZenML](https://www.zenml.io/blog/what-1200-production-deployments-reveal-about-llmops-in-2025) — Production patterns
19. [Multi-Agent LLM Orchestration for Incident Response](https://arxiv.org/abs/2511.15755) — 2025 production case
20. [IBM: What is a ReAct Agent?](https://www.ibm.com/think/topics/react-agent) — Reference
21. [Function Calling in AI Agents - Prompting Guide](https://www.promptingguide.ai/agents/function-calling) — Tool use guide
22. [Advanced Tool Use on Claude - Anthropic](https://www.anthropic.com/engineering/advanced-tool-use) — Programmatic tool calling
23. [Agentic AI Design Patterns: ReAct, ReWOO, CodeAct](https://capabl.in/blog/agentic-ai-design-patterns-react-rewoo-codeact-and-beyond) — Pattern comparison

## Methodology

Searched 14 queries across web sources. Analyzed 30+ sources spanning academic papers (arXiv, NeurIPS, ICLR, ICML, ACL), framework documentation (LangGraph, AutoGen, CrewAI, Anthropic Claude), and industry analysis (ZenML LLMOps, Databricks, IBM). Sub-questions investigated:
1. ReAct framework mechanics and extensions
2. Reflexion verbal reinforcement learning
3. Self-Refine iterative feedback loops
4. Plan-and-Execute / Plan-and-Act patterns
5. ReWOO decoupled planning
6. CodeAct executable action spaces
7. Voyager lifelong learning agent architecture
8. Multi-agent debate and critic patterns
9. Framework comparison (LangGraph/AutoGen/CrewAI)
10. Anthropic's production agentic systems guidance
11. Tool use and function calling production patterns
12. CoT/ToT/GoT reasoning pattern landscape
13. Production lessons from AutoGPT/BabyAGI era
14. Agentic prompting survey taxonomies (2025)
