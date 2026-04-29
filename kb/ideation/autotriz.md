# AutoTRIZ — LLM-Automated TRIZ Ideation
**Domain:** ideation
**Type:** framework
**Relevance:** high
**Source:** Wave 1 — 04-llm-ideation.md

## Summary
AutoTRIZ applies the TRIZ methodology (Theory of Inventive Problem Solving) using LLMs as the reasoning engine. TRIZ is a structured Soviet-era innovation framework derived from analysis of 400,000 patents, distilled into 40 inventive principles and a Contradiction Matrix that maps problem types to applicable principles. AutoTRIZ automates the three-step TRIZ workflow — contradiction identification, matrix lookup, and principle application — enabling systematic generation of novel solutions that unconstrained LLM brainstorming typically misses. Research shows AutoTRIZ produces more novel solutions than free-form LLM brainstorming on engineering and design tasks.

## Core Mechanism
The three-step AutoTRIZ pipeline: (1) Contradiction Identification — prompt the model to identify the technical contradiction in the problem: what parameter you want to improve and what parameter gets worse as a result (e.g., "improving instruction specificity degrades generalization"). (2) Matrix Mapping — provide the TRIZ Contradiction Matrix as context and prompt the model to identify which of the 40 inventive principles apply to this contradiction pair. (3) Principle Application — prompt the model to apply each selected principle to generate a concrete solution variant. AutoTRIZ also integrates SCAMPER (Substitute, Combine, Adapt, Modify, Put to other uses, Eliminate, Reverse), Design Heuristics, and Morphological Analysis as complementary structured ideation frameworks, each providing a different generative lens on the same problem.

## Application in Skill Context
In a prompt engineering skill, AutoTRIZ is used to systematically generate prompt variants rather than iterating by intuition. Example: identifying the contradiction between "instruction clarity" (more explicit = better compliance) and "instruction flexibility" (more explicit = less adaptable to edge cases), then applying TRIZ Principle 10 (Prior Action — perform the required action in advance or partially) to generate the variant: add a pre-check step that classifies the input type before applying differentiated instructions. SCAMPER is applied directly to the prompt structure: Substitute (replace few-shot exemplars with role-play); Combine (merge CoT with structured output); Eliminate (remove all preamble and test if performance holds). This produces structured coverage of the variant space rather than random exploration.

## Key Variants / Parameters
- **TRIZ 40 Principles**: full contradiction matrix application; highest structured novelty
- **SCAMPER**: simpler checklist-style application; lower overhead, good for rapid iteration
- **Morphological Analysis**: enumerate all dimensions of the prompt (format, persona, instruction style, output format) and generate combinations; useful for exhaustive variant coverage
- **Design Heuristics**: apply domain-specific heuristics derived from successful designs; bridges TRIZ and domain knowledge

## Related KB Entries
- [creative-dc.md](creative-dc.md)
- [constraint-based-prompting.md](constraint-based-prompting.md)
- [graphrag-ideation.md](graphrag-ideation.md)
