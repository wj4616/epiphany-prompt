# epiphany-prompt

Modular, subagent-orchestrated prompt enhancement skill for Claude Code. Takes any user-provided prompt and produces a semantically optimized, creatively enhanced version — preserving all original meaning, technical content, and intent while maximizing effectiveness when consumed by AI systems.

Applies 13 prompt engineering techniques through a wave-based pipeline. Output uses semantic XML structure optimized for machine consumption.

## Modes and scales

**Three modes:**
- **normal** (default) — enhanced `<prompt>` XML
- **`--specification`** — formal requirements document (`<specification>` XML, MUST/SHOULD/MAY)
- **`--plan`** — step-by-step plan (`<plan>` XML with `<steps>`, `<dependencies>`, `<safeguards>`)

**Three scales:**
- **`--minimal`** → FAST — inline, zero subagent spawns
- *(default)* → STANDARD — 3-wave pipeline
- **`--verbose`** → DEEP — 5-wave pipeline (up to 9 waves with repairs)

**Orthogonal flags:**
- **`--quiet`** — suppress terminal display, save directly to file
- **`--specification --plan`** — chained: run spec first, then plan over spec output

## Installation

Clone this repo into Claude Code's skills directory:

```bash
git clone https://github.com/wj4616/epiphany-prompt.git ~/.claude/skills/epiphany-prompt
chmod +x ~/.claude/skills/epiphany-prompt/tests/*.sh
chmod +x ~/.claude/skills/epiphany-prompt/tests/validate-frontmatter.py
```

Verify installation:

```bash
~/.claude/skills/epiphany-prompt/tests/test-structure.sh
~/.claude/skills/epiphany-prompt/tests/test-skill-registration.sh
```

Both must report PASS.

## Usage

Invoke in any Claude Code session:

```
/epiphany-prompt [your prompt here]
/epiphany-prompt --minimal [trivial prompt]
/epiphany-prompt --verbose [complex prompt]
/epiphany-prompt --specification [concept to formalize]
/epiphany-prompt --plan [spec to turn into plan]
/epiphany-prompt --specification --plan [concept → spec → plan]
```

Output saves to `~/docs/epiphany/prompts/DD-MM-{slug}.md`. Session stage files persist at `~/docs/epiphany/prompts/.sessions/{session_id}/stages/` for introspection.

## Repository layout

```
.
├── SKILL.md                      # Orchestrator protocol — loaded by Claude Code on trigger
├── modules/                      # 11 stage-specific subagent protocols
│   ├── m12-analysis-ideation.md
│   ├── m3-synthesis.md
│   ├── m4-verification.md
│   ├── m4m5-verify-output.md
│   ├── m5-expansion.md
│   ├── mspec12-domain-req.md
│   ├── mspec3-synthesis.md
│   ├── mspec4m5-verify-output.md
│   ├── mplan12-analysis-design.md
│   ├── mplan3-synthesis.md
│   └── mplan4m5-verify-output.md
└── tests/
    ├── test-structure.sh           # SKILL.md + module frontmatter sanity
    ├── test-skill-registration.sh  # Install-location + frontmatter keys
    ├── validate-frontmatter.py     # YAML schema check for modules
    ├── EXPECTED-SMOKE.md           # 12 live-session smoke test cases
    └── smoke-inputs/               # Input fixtures for smoke tests
```

## Design principles

- **Zero information loss** — every technical detail (paths, versions, constants, URLs) survives into the output XML verbatim
- **Prompt content only** — the skill enhances the prompt; it does not execute its contents
- **Three-layer rule** — orchestrator never reads stage files directly; module subagents do
- **File-based state** — every wave's output is a stage file, making sessions fully introspectable
- **PASS-WITH-NOTES for spec/plan** — never hard-fails; returns output with notes on remaining concerns

## Testing

Structural tests (run automatically; no Claude session needed):

```bash
~/.claude/skills/epiphany-prompt/tests/test-structure.sh
~/.claude/skills/epiphany-prompt/tests/test-skill-registration.sh
```

Live-session smoke tests require pasting each input from `tests/smoke-inputs/` into Claude Code and verifying checkboxes from `tests/EXPECTED-SMOKE.md`. 12 cases cover all mode × scale combinations plus edge cases (flag conflict, chained spec+plan, collision handling, type-C input detection, quiet flag, file-path input).

## License

MIT
