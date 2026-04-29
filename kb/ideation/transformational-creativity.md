# Transformational Creativity
**Domain:** ideation
**Type:** theory
**Relevance:** high
**Source:** Wave 3 — inference-and-creativity-research-2025.md

## Summary
Transformational creativity (Boden's level 3) describes ideas that restructure the conceptual space itself rather than recombining within it. LLMs reliably achieve level 1 (combinatorial), partially achieve level 2 (exploratory), and do not reliably achieve level 3 without architectural or prompting interventions. RLHF training is a structural suppressor of transformational output because it optimizes against the distributional tail where genuinely novel ideas live.

## Core Mechanism
Boden's three-level taxonomy defines a hierarchy of creative depth:
1. **Combinatorial** — novel pairings of familiar ideas. LLMs handle this by default.
2. **Exploratory** — traversal to unexplored regions of an existing conceptual space. LLMs partially achieve this via temperature and diverse sampling.
3. **Transformational** — the conceptual space itself is altered (new dimensions added, constraints removed, axioms replaced). LLMs structurally resist this because RLHF training penalizes outputs that deviate from the reward model's learned distribution, which is built on human consensus — exactly the consensus that transformational ideas must break.

Supporting empirical evidence:
- ICLR 2025: LLM ideas rated more novel than human experts' but less feasible — consistent with exploratory-not-transformational generation.
- CHI 2025 (N=1,100): LLM assistance homogenizes group creative diversity and harms subsequent independent creativity ("homogenization paradox").
- Nature Human Behaviour (N=9,198): Humans retain superiority at the far-right tail of idea distributions (exceptional outlier ideas).

Ceiling of prompting: RLHF-aligned models cannot be fully prompted into transformational creativity. DivPO/CRPO training is required for parametric-level enhancement. Prompting can push toward the transformational regime but cannot reliably breach it.

## Application in Skill Context
Epiphany-* skills targeting transformational output should:
1. Deploy **Denial Prompting** as a default gate — explicitly block the top-N obvious solutions before soliciting ideas, forcing search into less-visited space regions.
2. Use **CreativeDC** (divergent-convergent two-phase) as the primary generation architecture; it yields the strongest quantified novelty gain (+32.9%) among documented prompting approaches.
3. Apply **Bit-Flip-Spark** (assumption inversion) when a session appears stuck in exploratory cycling — each assumption of the problem is systematically questioned to induce cognitive conflict.
4. Use **Chain-of-Ideas (CoI)** to capture breakthrough dependency graphs across multi-turn sessions, enabling multi-hop conceptual chaining rather than independent per-turn generation.
5. Use **Multilingual Prompting** for semantic diversity when temperature sampling is exhausted — different languages encode different conceptual groupings and escape English-language semantic attractors.
6. Apply **Conceptual Blending Theory** prompts to trigger Prompt-Induced Transitions (PITs: genuine conceptual shifts). Monitor for Prompt-Induced Hallucinations (PIHs: coherent but ungrounded fusions) and flag for verification.
7. For highest combined novelty+feasibility, route to the **SPARK System** (Xplor knowledge exploration + Spark Generator + Judge model trained on 600K peer reviews).
8. For novel concept generation from structured inputs, use **DishCover** (tree-blending via Zhang-Shasha tree-edit algorithms) — outperforms GPT-4o direct prompting on this task.

## Key Variants / Parameters
- **CreativeDC**: Two phases — divergent (unconstrained generation, no evaluation) then convergent (selection + refinement). The phase boundary is explicit in the prompt; merging phases collapses gains.
- **Denial Prompting**: Parameter is the denial list length. Start with top-3 obvious solutions; increase to top-7 for domains with dense attractor basins.
- **Bit-Flip-Spark**: Each assumption is individually inverted. Works best when the assumption list is exhaustive (5–10 items); shallow assumption lists produce surface-level inversions only.
- **Multilingual Prompting**: Language choice is a parameter. Non-Indo-European languages (e.g., Japanese, Arabic) show greater semantic distance from English attractors; use for maximum diversity.
- **SPARK System**: Three-component pipeline — Xplor (knowledge exploration), Spark Generator, and a Judge model. The Judge component requires fine-tuning on domain-specific review data to calibrate feasibility scoring.

## Related KB Entries
- [theory/inference-economics.md](../theory/inference-economics.md)
- [cross-references/inference-economics-unified.md](../cross-references/inference-economics-unified.md)
