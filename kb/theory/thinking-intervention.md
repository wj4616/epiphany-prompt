# Thinking Intervention
**Domain:** prompt-engineering
**Type:** theory
**Relevance:** high
**Source:** Wave 2 — thinking-intervention

## Summary
Thinking Intervention is the post-hoc insertion or modification of specific tokens within an active reasoning trace (inside `<think>` tags) without fine-tuning. It represents a new prompt engineering category that sits between system prompting and fine-tuning — it steers reasoning mid-stream rather than before generation starts. Published research reports significant improvements: +6.7% instruction following, +15.4% reasoning hierarchy adherence, +40.0% refusal improvement.

## Core Mechanism
During generation, the practitioner (or an orchestrating agent) inserts specific guidance tokens into the thinking trace at designated checkpoint points while the model is still generating its reasoning. This requires access to the live generation stream — achievable via a streaming API or local inference. The inserted tokens redirect the model's chain of thought toward desired reasoning paths without altering model weights. Budget Forcing is a related technique: a hard decoding-time cap is placed on thinking token count, terminating the trace at a set limit. Budget Forcing tradeoff: reduces latency and cost but degrades accuracy significantly on hard math and logic tasks; acceptable performance on easy tasks.

## Application in Skill Context
In a prompt engineering skill context, Thinking Intervention enables mid-reasoning redirection after an initial prompt analysis phase. Concretely: after the model generates its first analysis of a prompt's weaknesses, insert intervention tokens that redirect the reasoning trace toward underexplored enhancement directions (e.g., "now consider structural clarity improvements not yet addressed"). This prevents the model from over-anchoring on its first assessment and diversifies the enhancement search. Budget Forcing can be applied to time-boxed subtasks within the skill pipeline where latency matters more than exhaustive reasoning depth.

## Key Variants / Parameters
- **Token insertion:** guidance tokens injected at designated points in the `<think>` trace during streaming generation
- **Budget Forcing:** hard decoding-time cap on thinking token count; reduces cost/latency at accuracy cost on hard tasks
- **Checkpoint placement:** early intervention (redirects before anchoring), mid-trace (course correction), late-trace (quality check before answer emission)

## Related KB Entries
- theory/test-time-compute-scaling.md
