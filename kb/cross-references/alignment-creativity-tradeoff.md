# Alignment-Creativity Trade-off
**Domain:** cross-domain
**Type:** theory
**Relevance:** high
**Source:** Wave 2 — alignment-ideation-tension.md

## Summary
The Alignment-Creativity Trade-off describes a structural tension in which RLHF and safety alignment training systematically suppress creative entropy in LLMs, producing a distributional bias toward safe, conventional, high-probability outputs. This creates a fundamental conflict between prompt engineering for reliability (where alignment is an asset) and prompt engineering for ideation (where alignment actively narrows the output space). The trade-off is not incidental but mechanistic: human raters used in RLHF training consistently prefer conventional outputs, so the model's reward function is directly optimized against novelty. Understanding this tension is prerequisite to designing prompt engineering skills that serve both enhancement and ideation goals without sacrificing one for the other.

## Core Mechanism
RLHF trains models to maximize human preference scores across a distribution of outputs. Human raters exhibit a systematic preference for safe, clear, and conventional responses over novel or boundary-pushing ones — even when novelty is explicitly desirable. The result is a trained distributional bias: the aligned model's output probability mass concentrates around a narrow "safe" region of the response space.

Three supporting evidence streams confirm this mechanism:
1. **DivPO research**: Direct Preference Optimization (standard RLHF variant) directly penalizes output diversity by rewarding the single preferred response and penalizing alternatives, compressing the output distribution
2. **LLM ideation studies**: models produce ideas scoring higher on novelty than humans primarily when operating near alignment boundaries — conventional prompting retrieves conventional outputs
3. **RLVR training**: reinforcement learning with verifiable rewards concentrates probability mass on known-correct solution paths, reducing variance across all generation (including creative generation as collateral damage)

The practical effect: aligned models are highly reliable and easy to prompt for structured tasks, but progressively harder to prompt for genuine novelty. The more capable and more aligned the model, the more pronounced this effect.

## Application in Skill Context
A prompt engineering skill that must serve both enhancement (reliability, precision) and ideation (novelty, divergence) requires a phase-aware architecture that treats the alignment boundary differently in each phase:

**Divergent phase design** (minimize alignment interference):
- Use non-expert personas — aligned models behave more creatively when role-playing as fictional inventors, non-AI characters, or domain outsiders than when acting as AI assistants
- Frame tasks as thought experiments or hypothetical scenarios rather than direct instructions
- Apply CreativeDC-style divergent-phase isolation: generate alternatives before any evaluation or critique
- Prefer instruct-only or lower-alignment model variants for pure divergent generation when available

**Convergent phase design** (leverage alignment for quality filtering):
- Return to standard aligned prompting for evaluation, critique, and selection
- Use Constitutional AI self-critique in reverse: evaluate whether output is too conservative rather than too harmful
- Apply RLHF-trained preference for clarity and structure to select the most communicable of the divergent candidates

**Skill-level implication**: any skill invoking both ideation and enhancement capabilities must explicitly sequence divergent generation before convergent evaluation, and must not allow evaluation rubrics to be visible during the divergent phase — premature exposure to quality criteria activates self-censorship.

## Key Variants / Parameters
- **Persona strategy**: non-expert/fictional personas reduce alignment suppression; AI assistant persona maximizes it
- **Framing strategy**: "thought experiment" / "hypothetical" framing reduces self-censorship vs. direct instruction framing
- **Phase isolation**: strict separation of divergent and convergent phases is the primary structural mitigation
- **Model selection**: base models vs. instruct-tuned vs. RLHF-aligned represent a spectrum of creative entropy; higher alignment = lower divergent output variance
- **CAI reverse critique**: Constitutional AI self-critique loop applied to conservatism rather than harm; flags outputs that are too conventional as a quality failure

## Related KB Entries
- [../ideation/creative-dc.md](../ideation/creative-dc.md)
- [../ideation/divpo.md](../ideation/divpo.md)
- [../ideation/anti-conformity-prompting.md](../ideation/anti-conformity-prompting.md)
- [multi-agent-patterns-for-pe.md](multi-agent-patterns-for-pe.md)
- [../theory/synthesis-failure-modes.md](../theory/synthesis-failure-modes.md)
