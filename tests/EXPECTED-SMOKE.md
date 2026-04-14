# epiphany-prompt — Smoke Test Checklist

Run each test in a live Claude Code session. Paste the input verbatim after the trigger (preserve newlines). Verify each checkbox manually by inspecting the skill's output.

Before starting: confirm the skill is registered by running `/epiphany-prompt` with no input. Expected: the skill asks for a prompt.

## Test 1 — FAST scale (normal mode, --minimal)

Command: `/epiphany-prompt --minimal` then paste `smoke-inputs/fast-trivial.txt` content.

Expected behavior:
- [ ] Announces "epiphany-prompt skill (FAST, normal mode)"
- [ ] No session directory created — check `ls ~/docs/epiphany/prompts/.sessions/ | grep -v plan | tail -5` — no new entry since last known
- [ ] Sufficiency check emits "Sufficient — [reason]"
- [ ] Output XML has `<prompt>` root with `<meta source="epiphany-prompt"/>` as first child
- [ ] Output preserves the URL `https://example.com/article` verbatim
- [ ] Asks "Save to file? (y/n)" (non-quiet default)
- [ ] Answering "y" saves to `~/docs/epiphany/prompts/DD-MM-{slug}.md`

## Test 2 — STANDARD scale (normal mode, default)

Command: `/epiphany-prompt` then paste `smoke-inputs/standard-normal.txt`.

Expected:
- [ ] Announces "epiphany-prompt skill (STANDARD, normal mode)"
- [ ] Session directory created at `~/docs/epiphany/prompts/.sessions/YYYYMMDD-{slug}/stages/`
- [ ] `00-config.md` + `00-input.md` present
- [ ] After wave 1: `01-analysis.md`, `01-inventory.md`, `02-ideation.md` all present and non-empty
- [ ] After wave 2: `03-synthesis.md` present
- [ ] After wave 3: `04-verification.md` present; output XML displayed
- [ ] `01-inventory.md` contains entries for paths `~/data/file.csv` and `/tmp/output.json`, technology `Python 3.11`
- [ ] Output XML preserves all INVENTORY items
- [ ] "show me the inventory" after wave 1 displays `01-inventory.md` content
- [ ] Output saves to `~/docs/epiphany/prompts/DD-MM-{slug}.md`

## Test 3 — DEEP scale (normal mode, --verbose)

Command: `/epiphany-prompt --verbose` then paste `smoke-inputs/deep-complex.txt`.

Expected:
- [ ] Announces "epiphany-prompt skill (DEEP, normal mode)"
- [ ] 5 waves executed: M12, M3, M4, M5, M4M5
- [ ] Stage files 01-*, 02-ideation, 03-synthesis, 04-verification, 05-expansion, 06-verification-2 all written
- [ ] INVENTORY captures JUCE 7.0.5, VST3, APVTS, SmoothedValue, LookAndFeel v4, 1ms, 256 samples, 44.1 kHz
- [ ] Output XML preserves all versioned items verbatim
- [ ] DEEP-specific: weakness impact scores visible in `01-analysis.md`
- [ ] DEEP-specific: anti-conformity contracts appear in `02-ideation.md`

## Test 4 — Specification mode

Command: `/epiphany-prompt --specification` then paste `smoke-inputs/spec-concept.txt`.

Expected:
- [ ] Announces "epiphany-prompt skill (STANDARD, specification mode)"
- [ ] 3 waves: MSPEC12, MSPEC3, MSPEC4M5
- [ ] Stage files: `spec-01-domain.md`, `spec-02-requirements.md`, `spec-03-synthesis.md`, `spec-04-verify.md`
- [ ] Output root is `<specification>` with `<meta>` first child
- [ ] Requirements classified MUST/SHOULD/MAY
- [ ] Save path `~/docs/epiphany/prompts/DD-MM-{slug}.md` (no `-plan` suffix)

## Test 5 — Plan mode

Command: `/epiphany-prompt --plan` then paste `smoke-inputs/plan-spec.txt`.

Expected:
- [ ] Announces "epiphany-prompt skill (STANDARD, plan mode)"
- [ ] Input type correctly detected as type B (prompt-epiphany XML) — verify by checking `00-input.md` contents show extracted requirements text, not raw `<specification>` markup
- [ ] 3 waves: MPLAN12, MPLAN3, MPLAN4M5
- [ ] Output root is `<plan>` with numbered `<steps>`, `<dependencies>`, `<safeguards>`
- [ ] Save path `~/docs/epiphany/prompts/DD-MM-{slug}.md`

## Test 6 — Chained spec+plan

Command: `/epiphany-prompt --specification --plan` then paste `smoke-inputs/spec-plan-chain.txt`.

Expected:
- [ ] Skill asks "Run --specification first, then --plan on its output sequentially? (y/n)" — answer `y`
- [ ] Announces spec phase starting
- [ ] Spec pipeline runs to completion, saves to `DD-MM-{slug}.md`
- [ ] Announces "Specification complete. Starting plan pipeline with spec as input."
- [ ] Plan pipeline uses a NEW session directory with `-plan` suffix (`YYYYMMDD-{slug}-plan`)
- [ ] Plan output saves to `DD-MM-{slug}-plan.md`

## Test 7 — Quiet flag

Command: `/epiphany-prompt --minimal --quiet` then paste `smoke-inputs/fast-trivial.txt`.

Expected:
- [ ] No output XML displayed in terminal
- [ ] File saved directly without "Save to file? (y/n)" prompt
- [ ] Terminal confirms "Saved to [full path]"

## Test 8 — Input routing (type C detection)

After Test 2, paste the saved output file contents back as input: `/epiphany-prompt` then paste the contents of the saved file from Test 2 (including the `<meta source="epiphany-prompt"/>` marker).

Expected:
- [ ] Skill detects type C (prior epiphany-prompt output) — confirmable via "show me input" after wave 1 showing the extracted original input section, not the wrapped XML
- [ ] Pipeline completes without treating the wrapping XML as the new prompt

## Test 9 — File path input

Command: `/epiphany-prompt ~/.claude/skills/epiphany-prompt/tests/smoke-inputs/standard-normal.txt`

Expected:
- [ ] Skill reads file contents as input (not treats the path string as the prompt)
- [ ] Behaves identically to Test 2

## Test 10 — Sufficiency block

Command: `/epiphany-prompt ` (just whitespace or empty)

Expected:
- [ ] Sufficiency check emits BLOCK message explaining input is required
- [ ] No session directory created

## Test 11 — Flag conflict

Command: `/epiphany-prompt --minimal --verbose` then paste `smoke-inputs/fast-trivial.txt`.

Expected:
- [ ] BLOCK with "pick one" message
- [ ] No session directory created, no pipeline execution

## Test 12 — Collision handling

Run Test 2 twice with the same input.

Expected:
- [ ] Second run produces `DD-MM-{slug}-v2.md` (or `-v3` if `-v2` already exists)
- [ ] Session directory collision: second run's session_id has `-2` suffix
