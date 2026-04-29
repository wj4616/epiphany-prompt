# Tree of Thoughts
**Domain:** prompt-engineering
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — tree-of-thoughts research report

## Summary
Tree of Thoughts (ToT), introduced by Yao et al. (2023), extends Chain-of-Thought prompting from a single linear reasoning chain into a branching tree of intermediate reasoning states. At each node in the tree, the model generates multiple candidate next steps, self-evaluates which are most promising, and explores the tree via search strategies such as BFS or DFS with backtracking. On the Game of 24 benchmark, standard GPT-4 CoT achieves 4% accuracy while ToT achieves 74%. ToT is the foundation for systematic exploration of large, complex reasoning spaces.

## Core Mechanism
The model maintains a tree where each node represents a partial reasoning state (e.g., a partial solution or intermediate conclusion). At each expansion step, the model generates B candidate continuations (branching factor B). It then evaluates all candidates — typically by prompting the same model to vote on which states look most promising — and selects which branches to expand next. BFS explores the tree level by level, useful when solution depth is known; DFS with backtracking allows deeper exploration with pruning when branches become unpromising. This structure allows the model to abandon dead-end reasoning paths and explore alternatives, something impossible with linear CoT. The Tree of Uncertain Thoughts (TouT) extension adds per-node uncertainty quantification, allowing the search to weigh both promise and reliability. Adaptive Graph of Thoughts (AGoT, 2025) unifies chain, tree, and graph reasoning adaptively based on task type.

## Application in Skill Context
In a prompt engineering skill, ToT is applied to tasks with large, explorable solution spaces that require systematic search — such as generating multiple distinct prompt variants and evaluating which is most effective, exploring alternative framings of a creative brief, or exhaustively checking design options against constraints. The skill can implement a lightweight ToT by running multiple parallel generation calls (branching), scoring each with a separate evaluation prompt, and selecting the top branch for further development. Full recursive tree search is expensive, so most skill applications use a single-level ToT: generate N candidates, evaluate all, select best. This single-level variant is often called "generate-and-rank."

## Key Variants / Parameters
- **Branching factor (B)**: number of candidate steps per node; B=3–5 is typical; higher B increases coverage but multiplies cost
- **Search strategy**: BFS for bounded depth tasks; DFS+backtracking for open-ended exploration
- **Evaluation method**: model votes on candidate quality; can use value function prompts or separate evaluator model
- **TouT**: adds uncertainty scores per node; useful when model confidence is unreliable
- **AGoT (2025)**: adaptively selects chain/tree/graph structure based on task; most general but most complex

## Related KB Entries
- [chain-of-thought.md](chain-of-thought.md)
- [self-consistency.md](self-consistency.md)
- [react-framework.md](react-framework.md)
- [reflexion.md](reflexion.md)
