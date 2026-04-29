# Knowledge Distillation for Synthesis
**Domain:** synthesis
**Type:** technique
**Relevance:** medium
**Source:** Wave 1 — knowledge-distillation-synthesis

## Summary
Knowledge distillation in the synthesis context transfers reasoning capability from a large teacher model to a smaller student model by training the student on the teacher's synthesis outputs and reasoning traces, not just final answers. Rationale-based distillation transfers the full chain of reasoning, enabling the student to generalize synthesis patterns rather than memorize answers. The technique has produced models that outperform much larger models: DeepSeek-R1-Distill-Qwen-7B at 7B parameters outperforms QwQ-32B-Preview on synthesis tasks through effective distillation.

## Core Mechanism
Standard distillation: the teacher model generates synthesis outputs for a large dataset of inputs; the student trains to reproduce these outputs via supervised fine-tuning. Rationale-based distillation extends this by having the teacher include its full reasoning chain (CoT trace) in each training example, so the student learns the synthesis process, not just the result. CoT Curriculum Distillation structures the training data by difficulty: early examples have simple, short reasoning chains; later examples require multi-step cross-document synthesis. This scaffolds the student's learning trajectory. AdaptDistill adds an error analysis loop: the teacher examines student outputs, identifies specific deficiencies (e.g., fails to reconcile contradictions), and generates targeted training examples that address those deficiencies. Multi-teacher frameworks use several specialized teachers — one for summarization, one for comparison, one for inference — whose outputs are combined to give the student broader synthesis capability. Key risk: model collapse occurs if synthetic training data diverges too far from the real distribution, causing the student to fail on out-of-distribution inputs.

## Application in Skill Context
Prompt engineering skills can apply distillation-style prompting without actual fine-tuning, by using exemplar-based few-shot prompts. The pattern: present the model with high-quality exemplar prompt improvements that include the full reasoning trace (why the change was made, what weakness it addresses, what improvement is expected), then ask it to apply the same reasoning pattern to the current prompt. This is in-context distillation — the exemplars serve as a synthetic teacher signal. AdaptDistill's targeted feedback approach maps to iterative prompt refinement: after each improvement attempt, the skill should diagnose specific remaining weaknesses and provide targeted exemplars addressing those weaknesses in the next pass. The model collapse risk translates to a skill design concern: if all exemplars come from the same narrow domain, the skill may fail to generalize to prompts from different domains.

## Key Variants / Parameters
- **Distillation target**: output-only (answer matching) vs. rationale-based (CoT trace matching)
- **Curriculum structure**: flat (all difficulties equal) vs. progressive (simple to complex synthesis chains)
- **Teacher count**: single teacher vs. multi-teacher ensemble with specialized roles
- **AdaptDistill loop depth**: fixed single-pass vs. iterative error-targeted refinement cycles
- **In-context equivalent**: number of exemplars (1-shot to 5-shot), quality of included reasoning traces

## Related KB Entries
- synthesis/mixture-of-experts.md
- synthesis/cot-synthesis.md
- enhancement/automatic-prompt-optimization.md
