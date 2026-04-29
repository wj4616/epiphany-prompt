# ProTeGi (Prompt Optimization via Textual Gradients)
**Domain:** enhancement
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — protegi

## Summary
ProTeGi applies the concept of gradient descent to natural language prompts by replacing numeric gradients with LLM-generated diagnostic feedback called "textual gradients." Rather than simply appending scores to a history (as OPRO does), ProTeGi explicitly analyzes failure cases to identify what is structurally wrong with the current prompt, then generates targeted improvements. Beam search with bandit selection balances exploration of new candidates against exploitation of known-good ones. Extensions MAPO and PO2G add momentum and dual-pass diagnostics respectively.

## Core Mechanism
Each optimization cycle has five stages: (1) Batch evaluation — run the current prompt on a sample of labeled examples and collect failures; (2) Textual gradient computation — pass the failures to an LLM with the instruction "analyze what patterns in these failures indicate about weaknesses in the prompt; write a diagnostic that describes the error pattern" — the resulting diagnostic is the textual gradient; (3) Candidate generation — the LLM uses the textual gradient to propose a set of improved prompt variants that address the diagnosed weakness; (4) Beam search — all candidates are evaluated on the task; the top-B candidates by score form the beam for the next iteration; (5) Bandit selection — a multi-armed bandit algorithm (e.g., UCB) balances allocating evaluation budget between exploiting the current best beam members and exploring lower-ranked candidates that may have upside. MAPO (Momentum-Aided Textual Gradient Descent) appends a momentum term: if the same failure pattern has recurred across multiple iterations, its textual gradient is weighted more heavily in candidate generation. PO2G (Two-Gradient ProTeGi) runs two independent diagnostic passes on the failures and merges the resulting gradients before generating candidates, increasing diagnostic coverage.

## Application in Skill Context
ProTeGi is the preferred optimization strategy when OPRO has plateaued or when a prompt has known failure modes that need structured remediation. In the epiphany-prompt skill context, the textual gradient step translates directly: collect examples where the current prompt produced low-quality output, pass them to the LLM with a diagnostic meta-prompt, and use the returned failure analysis to guide the next rewrite. The beam search parameter B should be set to 3–5 for typical skill refinement budgets — larger beams increase quality but multiply evaluation cost. Bandit selection is most valuable when the skill optimization spans many iterations and some candidate branches may recover after early underperformance. When integrating with DSPy, ProTeGi's beam search maps to DSPy's `BootstrapFewShotWithRandomSearch` optimizer with a custom teleprompter that injects textual gradients as demonstrations.

## Key Variants / Parameters
- **Beam width B**: number of candidate prompts maintained per iteration (typically 3–5)
- **Bandit algorithm**: UCB (upper confidence bound) vs. Thompson sampling for exploration/exploitation balance
- **Diagnostic pass count**: single-gradient (base ProTeGi) vs. dual-gradient (PO2G)
- **Momentum term**: disabled (base ProTeGi) vs. enabled with decay factor (MAPO)
- **Failure sample size**: number of failed examples passed to the diagnostic step — larger samples yield more reliable gradients at higher cost

## Related KB Entries
- enhancement/automatic-prompt-optimization.md
- enhancement/opro.md
- enhancement/textgrad.md
- enhancement/ape.md
- techniques/self-refine.md
