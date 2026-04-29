# Six Thinking Hats
**Domain:** ideation
**Type:** framework
**Relevance:** high
**Source:** Wave 2 — multi-agent-ideation-patterns.md

## Summary
Six Thinking Hats (de Bono) is a structured parallel thinking framework that separates six distinct cognitive modes into discrete, non-overlapping roles: White (facts and data), Red (emotions and intuition), Black (critical judgment), Yellow (optimistic value), Green (creative alternatives), and Blue (process and meta-thinking). When adapted for LLM-based ideation, each hat is assigned to a separate prompt or session, preventing the default "hat-mixing" problem in which models blend analytical and critical thinking without systematic coverage of emotional, optimistic, or creative dimensions. The Blue hat session acts as synthesizer and aggregates all other hat outputs into a coherent improvement strategy.

## Core Mechanism
The framework is implemented as six independent LLM sessions (or sequential prompts), each receiving the same input but constrained to a single hat's perspective:
- **White**: gather and report only observable data — what is known, what metrics exist, what has been tested
- **Red**: surface gut-level reactions and intuitions — what feels off, what seems promising without needing justification
- **Black**: identify risks, failure modes, and weaknesses — what will go wrong, what assumptions are fragile
- **Yellow**: enumerate value and benefits — what is working, what should be preserved or amplified
- **Green**: generate alternative approaches — what other formulations, angles, or structures are possible
- **Blue**: review all outputs from the other five hats, identify conflicts and gaps, and produce a synthesis and action plan

Each hat session must be isolated — agents must not see the outputs of other hats until the Blue synthesis stage. This isolation prevents premature convergence and ensures each perspective is genuinely distinct. The Blue hat synthesizer receives all five hat outputs simultaneously and produces the integrated result.

## Application in Skill Context
In a prompt engineering skill, Six Thinking Hats provides comprehensive multi-dimensional evaluation of a candidate prompt without requiring a full multi-agent debate loop. The six perspectives map directly to prompt improvement needs: White identifies what performance data or test cases exist; Red flags formulations that feel awkward or misaligned with intent; Black enumerates edge cases and likely failure modes; Yellow preserves what is already working in the current prompt; Green generates alternative phrasings, structures, or instruction strategies; Blue produces the final revision plan reconciling all inputs. This pattern is most effective when a prompt requires both critical hardening and creative reformulation in a single pass, and when token budget is constrained relative to a full MAD pipeline.

## Key Variants / Parameters
- **Sequential vs. parallel**: hats can run sequentially in one session (lower cost, some cross-contamination risk) or in parallel isolated sessions (higher quality, higher cost)
- **Hat selection**: not all six hats are required for every task; a focused review can use only Black + Green + Blue for fast critique-and-alternatives cycles
- **Blue hat timing**: Blue should always run last after all other hats have completed; early synthesis collapses the independent perspectives
- **Role framing**: explicit persona instruction ("You are wearing the Black Hat. Your only role is...") outperforms simple instruction ("Focus on weaknesses") for maintaining hat discipline

## Related KB Entries
- [multi-agent-debate.md](multi-agent-debate.md)
- [anti-conformity-prompting.md](anti-conformity-prompting.md)
- [persona-hub.md](persona-hub.md)
- [../cross-references/multi-agent-patterns-for-pe.md](../cross-references/multi-agent-patterns-for-pe.md)
