# Forest of Thought
**Domain:** ideation
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — forest-of-thought

## Summary
Forest of Thought (FoT, ICML 2025) extends Tree of Thoughts to a forest of multiple parallel reasoning trees with cross-tree consensus via sparse activation. The key advantage over a single ToT instance is that independent trees explore different reasoning branches, escaping the local optima where single-tree BFS or DFS can get stuck. Cross-tree paths can agree on an answer even when no individual tree reached it via a clean path.

## Core Mechanism
Three-stage process: (1) Run M parallel Tree of Thoughts instances independently from the same root problem — each tree explores its own branching reasoning paths via BFS or DFS; (2) Score all paths across all trees using a sparse activation function that selects the most relevant reasoning paths across the full forest (not just within each tree); (3) Combine the selected cross-tree paths into a consensus answer. The sparse activation step is what distinguishes FoT from simply running multiple independent ToT instances and majority-voting — it allows partial reasoning steps from different trees to be recombined, not just their final answers.

Adaptive Graph of Thoughts (AGoT) is a related technique that dynamically selects chain, tree, or graph topology per query based on estimated problem complexity, rather than committing to a fixed structure upfront.

## Application in Skill Context
In a prompt engineering skill, Forest of Thought is applicable to high-stakes prompt synthesis tasks where a single reasoning tree risks premature convergence on an obvious but suboptimal enhancement direction. Run M=3–5 parallel ToT instances across distinct framing angles (e.g., one tree focused on structural improvements, one on semantic precision, one on adversarial robustness), then apply sparse activation to select and recombine the strongest reasoning paths across trees into a final synthesis. Use AGoT's topology-selection logic to decide whether FoT overhead is warranted — simple prompt tweaks warrant chain-of-thought; complex redesigns warrant FoT.

## Key Variants / Parameters
- **M (number of trees):** typically 3–5 parallel instances; higher M increases coverage but multiplies compute
- **Sparse activation scoring:** selects most relevant cross-tree paths; implementation varies (confidence-weighted, diversity-weighted)
- **Per-tree search strategy:** BFS (breadth-first, exhaustive), DFS (depth-first, commitment)
- **AGoT variant:** dynamically selects chain/tree/graph topology per query complexity
- **Consensus method:** path recombination (FoT default) vs. final-answer majority vote (simpler but loses intermediate reasoning)

## Related KB Entries
- theory/test-time-compute-scaling.md
