# TextGrad ("Autograd for Text")
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — textgrad

## Summary
TextGrad extends ProTeGi's textual gradient concept to arbitrary compound AI systems, treating any multi-step LLM pipeline as a computation graph where nodes are textual variables and edges are LLM calls. Published in Nature 2025, it provides a PyTorch-like API — including `.backward()` and `.step()` methods — that propagates critique messages backward through the graph from an evaluation node to every variable that needs improvement. This enables end-to-end optimization of entire agent loops, multi-step reasoning chains, and retrieval pipelines without modifying model weights.

## Core Mechanism
TextGrad maps the backpropagation algorithm onto natural language. The computation graph is defined explicitly: each node is a string variable (a prompt, an intermediate output, a retrieved passage, or even a numeric parameter described in text), and each directed edge represents an LLM call that transforms one variable into another. A loss node is defined as an evaluation LLM call that scores the final output against quality criteria and produces a critique string. Calling `.backward()` on the loss node propagates textual critiques backward along each edge: for each upstream node, an LLM call asks "given that the downstream output was critiqued as [critique], what change to this upstream variable would address the problem?" — producing that node's textual gradient. Calling `.step()` on a variable applies its accumulated textual gradient by prompting the LLM to rewrite the variable to address the critique. The process mirrors stochastic gradient descent: multiple forward passes sample different failure modes, gradients accumulate, and `.step()` applies the update. Cycles and branches in the graph are supported. Limitation: graph topology must be hand-specified; textual feedback quality is bounded by the capability of the LLM used for gradient computation.

## Application in Skill Context
TextGrad applies when the epiphany-prompt skill is itself a multi-step pipeline — for example, a chain of prompts that first extracts requirements, then generates a draft prompt, then scores it, then refines it. Rather than optimizing each step in isolation, TextGrad can propagate quality failures from the final output back to any upstream node, including the requirement-extraction step whose errors may be the root cause. The practical entry point is to wrap the skill's sequential LLM calls as a TextGrad computation graph with explicit Variable objects and a downstream evaluation node. For single-prompt optimization, TextGrad reduces to ProTeGi and offers no additional advantage; its value is realized only in pipelines with two or more dependent LLM calls. When using TextGrad, the evaluation/loss node design is the most consequential engineering decision — an underspecified critique prompt produces diffuse gradients that fail to localize root causes.

## Key Variants / Parameters
- **Graph scope**: single-prompt (equivalent to ProTeGi) vs. multi-step chain vs. full agent loop
- **Gradient accumulation strategy**: single backward pass vs. mini-batch (multiple forward passes before `.step()`)
- **Loss node design**: LLM-judge rubric vs. exact-match vs. composite multi-criterion evaluation
- **Variable types subject to optimization**: prompt strings, few-shot examples, retrieved context snippets, configuration parameters described in text
- **Update application**: `.step()` rewrite-in-place vs. beam-search across multiple `.step()` candidates

## Related KB Entries
- enhancement/protegi.md
- enhancement/automatic-prompt-optimization.md
- enhancement/opro.md
- techniques/prompt-chaining.md
- techniques/dspy-framework.md
