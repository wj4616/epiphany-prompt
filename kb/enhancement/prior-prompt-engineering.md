# Prior Prompt Engineering (pPE)
**Domain:** enhancement
**Type:** technique
**Relevance:** high
**Source:** Wave 2 — prior-prompt-engineering

## Summary
Prior Prompt Engineering (pPE) is the practice of engineering the system prompt that is present during RL training of an LLM — as a distinct lever that permanently shapes the model's inference-time behavioral defaults. Published at EMNLP 2025, pPE research demonstrates that the system prompt seen during RLVR/GRPO rollouts instills durable reasoning styles into the trained model. Critically, models trained with a given pPE strategy respond best to inference prompts that match that training style, meaning the optimal inference prompt is not universal but is conditioned on the model's training history.

## Core Mechanism
During reinforcement learning from verifiable rewards (RLVR) or GRPO training, each rollout begins with a context that includes a system prompt — the "prior prompt." The model's learned policy is shaped not only by the reward signal but also by the behavioral patterns that were consistently activated during training rollouts. Five pPE strategies were studied: (1) CoT-style pPE — the system prompt during training instructs step-by-step reasoning; the trained model defaults to chain-of-thought behavior at inference; (2) Plan-and-Solve pPE — instills decomposition-first behavior; (3) Program-of-Thought pPE — instills code-generation as the default reasoning medium; (4) Zero-Shot pPE — instills direct response without scaffolding; (5) Null-Example pPE — minimal instruction with no task examples in the training system prompt. Null-example pPE achieves the largest average performance gains because it does not constrain the model's reasoning style during training, preserving maximum flexibility. The critical behavioral finding: a model trained with CoT pPE is best prompted with CoT at inference; a model trained with null-example pPE performs best with minimal zero-shot inference prompts. Mismatched inference prompts (e.g., prompting a null-pPE model with extensive CoT scaffolding) can actively degrade performance compared to the model's trained default.

## Application in Skill Context
pPE has two distinct applications in a prompt engineering skill context. First, as a selection heuristic: when choosing which model to use for a task, consult the model's training documentation or model card to identify its training system prompt (if disclosed). Match the inference prompting strategy to the pPE style — use CoT prompting with CoT-pPE models, and prefer minimal prompts with null-pPE or undisclosed-pPE models. Second, as a diagnostic tool: if a model responds poorly to an elaborately scaffolded prompt despite the scaffolding being well-formed, the root cause may be pPE mismatch — try a minimal zero-shot version of the same instruction. For the epiphany-prompt skill, this means maintaining two prompt variants for key reasoning steps: a scaffolded CoT variant for models with CoT-pPE training history, and a minimal zero-shot variant for models with null or unknown pPE. When operating with Claude models, Anthropic has documented that extended thinking (Claude 3.7+) is most effective with minimal scaffolding in the user prompt — consistent with null-example pPE principles.

## Key Variants / Parameters
- **pPE strategy** (training-time): CoT-style, Plan-and-Solve, Program-of-Thought, Zero-Shot, Null-Example
- **Best inference match**: CoT pPE → CoT inference; Null pPE → minimal zero-shot inference; mismatches degrade performance
- **Null-example pPE advantage**: achieves largest average gains by not constraining training-time reasoning style
- **Applicability**: only actionable when model training details are disclosed; otherwise use null-example/zero-shot as the safe default
- **Diagnostic use**: if scaffolded prompts underperform expectations, test a minimal zero-shot variant to detect pPE mismatch

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- theory/in-context-learning.md
- techniques/chain-of-thought.md
- theory/prompt-engineering-foundations.md
