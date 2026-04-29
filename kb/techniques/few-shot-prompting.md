# Few-Shot Prompting
**Domain:** prompt-engineering
**Type:** technique
**Relevance:** high
**Source:** Wave 1 — few-shot prompting research report

## Summary
Few-Shot Prompting, established by Brown et al. (2020) in the GPT-3 paper, provides 3–5 worked input-output demonstration examples directly in the prompt, showing the model the desired output pattern before presenting the real task. The model adapts its behavior to match the demonstrated pattern through in-context learning (ICL), without any weight updates. This is consistently the highest return-on-investment basic prompting technique, reliably improving output format adherence and reasoning consistency across nearly all task types.

## Core Mechanism
Each demonstration in the prompt is a complete input-output pair that exemplifies the target behavior — the format, the reasoning style, the level of detail, and the domain vocabulary. The model processes all examples in its context window and implicitly conditions its generation on the demonstrated pattern. This works because large language models have learned to recognize and continue contextual patterns during pretraining. One-Shot prompting uses a single example, suitable when examples are costly to curate or when context budget is limited. Demonstration ordering has measurable impact on output quality: more representative or difficult examples near the end of the demonstration list generally produce better results. Few-Shot CoT is the combination of this technique with Chain-of-Thought — each example includes both the reasoning trace and the final answer.

## Application in Skill Context
Within a prompt engineering skill, Few-Shot Prompting is the first technique to apply when a specific output format, analytical style, or reasoning pattern is required. Before writing a system prompt that describes behavior abstractly, the skill author writes 2–4 concrete examples of ideal inputs and outputs, then embeds them in the prompt template. This is especially effective for: structured output tasks (showing an example JSON object), evaluation rubrics (showing example scoring with rationale), and synthesis tasks (showing example input documents → example output synthesis). Example selection criteria are critical — examples must collectively cover the range of expected inputs, have unambiguous correct outputs, and match the target task difficulty. Poor examples actively mislead the model.

## Key Variants / Parameters
- **One-Shot**: single example; lower context cost, less pattern reinforcement
- **Few-Shot (3–5 examples)**: standard configuration; best balance of context cost and reliability
- **Few-Shot CoT**: each example includes full reasoning trace + answer; see chain-of-thought.md
- **Example ordering**: harder or more representative examples placed last tend to anchor generation most strongly
- **Example selection**: diverse coverage across input types reduces distribution shift risk

## Related KB Entries
- [chain-of-thought.md](chain-of-thought.md)
- [dspy-framework.md](dspy-framework.md)
- [structured-output.md](structured-output.md)
- [role-prompting.md](role-prompting.md)
