# Constraint-Based Prompting
**Domain:** ideation
**Type:** technique
**Relevance:** medium
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
Constraint-Based Prompting is a family of ideation techniques that uses explicit restrictions on what the model cannot do, cannot assume, or cannot include in order to force exploration of non-obvious regions of the solution space. The core insight is that constraints act as solution-space partitioners: removing the default high-probability region forces the model to generate from the remainder, which contains less-explored but often more creative solutions. Key techniques in this family include Denial Prompting (forbidding common approaches), Bit-Flip-Spark (challenging all problem assumptions), Cross-Lingual Thought Prompting (reasoning in a different language to exploit different semantic groupings), the GPS Framework (Goals, Prompts, Strategies), and the Flipped Interaction technique.

## Core Mechanism
Denial Prompting: explicitly forbid the most common or obvious approach — "Generate a solution that does NOT use [X]" — forcing generation away from the highest-probability region. The constraint must name the specific approach to exclude, not a vague category. Bit-Flip-Spark: enumerate all assumptions embedded in the problem statement, then explicitly negate each one and ask what solution would work under the negated assumption — this operationalizes assumption challenging rather than treating it as a vague heuristic. Cross-Lingual Thought Prompting (XLT): instruct the model to reason through the problem in a non-native language (e.g., German, Mandarin) before translating the answer back — exploits the fact that different languages encode different semantic groupings and conceptual categories, accessing parts of the model's semantic space not activated by English prompts. GPS Framework: structures ideation with three explicit layers in the prompt — Goals (what outcome is required), Prompts (the specific prompt strategy to apply), Strategies (the cognitive or creative strategy the model should employ) — making the ideation process explicit and steerable. Flipped Interaction: instead of the model generating ideas, the model asks the user targeted questions to build context before ideation; this prevents the model from generating ideas based on under-specified problems.

## Application in Skill Context
In a prompt engineering skill, constraint-based prompting is applied during prompt variant generation to escape pattern repetition. Denial Prompting is used to force structural diversity: "Generate a prompt that achieves this goal WITHOUT using explicit instructions — use only examples." Bit-Flip-Spark is applied to the prompt engineering meta-problem: "What assumptions are embedded in the current prompt design? Negate each and describe what the prompt would look like if that assumption were false." XLT can be used for cross-linguistic ideation on prompt phrasing when English phrasings have plateaued. GPS Framework provides a structured audit of whether the prompt explicitly communicates all three layers and whether they are aligned. Flipped Interaction is used when the prompt problem is underspecified — the skill prompts the model to ask clarifying questions before generating prompt candidates.

## Key Variants / Parameters
- **Denial Prompting**: names specific forbidden approaches; works best when the default approach is well-defined
- **Bit-Flip-Spark**: requires explicit enumeration of assumptions before negation; higher setup cost, higher novelty yield
- **Cross-Lingual Thought (XLT)**: most effective with languages structurally distant from English; adds translation overhead
- **GPS Framework**: explicit 3-layer structure in prompt; highest overhead but most auditable
- **Flipped Interaction**: inverts the generation direction; best for underspecified problems

## Related KB Entries
- [creative-dc.md](creative-dc.md)
- [autotriz.md](autotriz.md)
- [graphrag-ideation.md](graphrag-ideation.md)
- [persona-hub.md](persona-hub.md)
