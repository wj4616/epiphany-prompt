#!/usr/bin/env bash
# Structural assertions for epiphany-prompt skill files.
# Checks: SKILL.md exists with required sections; all 11 module files exist
# with valid frontmatter. Exits 0 on success, 1 on failure.

set -u
SKILL_DIR="$HOME/.claude/skills/epiphany-prompt"
FAIL=0

assert_file() {
    if [[ ! -f "$1" ]]; then
        echo "FAIL: missing file $1"
        FAIL=1
    fi
}

assert_grep() {
    # args: pattern, file, description
    if ! grep -qE "$1" "$2" 2>/dev/null; then
        echo "FAIL: $3 — pattern not found in $2"
        FAIL=1
    fi
}

# SKILL.md existence + required sections
assert_file "$SKILL_DIR/SKILL.md"
if [[ -f "$SKILL_DIR/SKILL.md" ]]; then
    assert_grep '^name: epiphany-prompt' "$SKILL_DIR/SKILL.md" "frontmatter name"
    assert_grep '^## Trigger Conditions' "$SKILL_DIR/SKILL.md" "trigger section"
    assert_grep '^## Hard Gates' "$SKILL_DIR/SKILL.md" "hard gates section"
    assert_grep '^## Orchestrator' "$SKILL_DIR/SKILL.md" "orchestrator section"
    assert_grep '^## FAST Inline Pipeline' "$SKILL_DIR/SKILL.md" "FAST inline section"
    assert_grep '^## Techniques' "$SKILL_DIR/SKILL.md" "techniques section"
    assert_grep '^## Preservation Methodology' "$SKILL_DIR/SKILL.md" "preservation section"
    assert_grep 'Mandatory Preservation Categories' "$SKILL_DIR/SKILL.md" "preservation categories"
    assert_grep 'Preservation Verification Protocol' "$SKILL_DIR/SKILL.md" "preservation verification"
    assert_grep 'Handling Overlapping Categories' "$SKILL_DIR/SKILL.md" "overlapping categories"
    assert_grep 'Handling Malformed Items' "$SKILL_DIR/SKILL.md" "malformed items"
    assert_grep 'STEP 0 — FLAG DETECTION' "$SKILL_DIR/SKILL.md" "STEP 0"
    assert_grep 'STEP 1 — INPUT ROUTING' "$SKILL_DIR/SKILL.md" "STEP 1"
    assert_grep 'STEP 2 — ANNOUNCE' "$SKILL_DIR/SKILL.md" "STEP 2"
    assert_grep 'STEP 3 — SUFFICIENCY CHECK' "$SKILL_DIR/SKILL.md" "STEP 3"
    assert_grep 'Type A — raw text' "$SKILL_DIR/SKILL.md" "type A detection"
    assert_grep 'Type B — prompt-epiphany XML' "$SKILL_DIR/SKILL.md" "type B detection"
    assert_grep 'Type C — prior epiphany-prompt output' "$SKILL_DIR/SKILL.md" "type C detection"
    assert_grep 'Mode routing signal' "$SKILL_DIR/SKILL.md" "mode routing signal"
    assert_grep 'STEP 4 — SESSION INIT' "$SKILL_DIR/SKILL.md" "STEP 4"
    assert_grep 'topic_slug' "$SKILL_DIR/SKILL.md" "topic_slug generation"
    assert_grep 'stop words removed' "$SKILL_DIR/SKILL.md" "stop word list"
    assert_grep 'Zero meaningful words' "$SKILL_DIR/SKILL.md" "zero-words fallback"
    assert_grep 'prompt-\{short-hash\}' "$SKILL_DIR/SKILL.md" "short-hash fallback"
    assert_grep '00-config.md' "$SKILL_DIR/SKILL.md" "00-config"
    assert_grep '00-input.md' "$SKILL_DIR/SKILL.md" "00-input"
    assert_grep 'mkdir -p \{session_dir\}' "$SKILL_DIR/SKILL.md" "session dir mkdir"
    assert_grep 'STEP 5 — WAVE EXECUTION' "$SKILL_DIR/SKILL.md" "STEP 5"
    assert_grep 'Pre-spawn validation' "$SKILL_DIR/SKILL.md" "pre-spawn validation"
    assert_grep 'VERIFICATION: PASS' "$SKILL_DIR/SKILL.md" "PASS contract"
    assert_grep 'VERIFICATION: FAIL' "$SKILL_DIR/SKILL.md" "FAIL contract"
    assert_grep 'VERIFICATION: PASS-WITH-NOTES' "$SKILL_DIR/SKILL.md" "PASS-WITH-NOTES contract"
    assert_grep 'Three-layer rule' "$SKILL_DIR/SKILL.md" "three-layer rule"
    assert_grep 'subagent_type.*general-purpose' "$SKILL_DIR/SKILL.md" "subagent type"
    assert_grep 'STEP 6 — REPAIR LOOPS' "$SKILL_DIR/SKILL.md" "STEP 6"
    assert_grep 'STANDARD — W3' "$SKILL_DIR/SKILL.md" "standard repair"
    assert_grep 'DEEP — W3' "$SKILL_DIR/SKILL.md" "deep W3 repair"
    assert_grep 'DEEP — W5' "$SKILL_DIR/SKILL.md" "deep W5 repair"
    assert_grep 'STEP 7 — OUTPUT' "$SKILL_DIR/SKILL.md" "STEP 7"
    assert_grep 'Double-failure' "$SKILL_DIR/SKILL.md" "double-failure path"
    assert_grep 'DD-MM-\{filename_slug\}.md' "$SKILL_DIR/SKILL.md" "save path pattern"
    assert_grep 'append .*v2' "$SKILL_DIR/SKILL.md" "collision suffix v2"
    assert_grep '.v3.' "$SKILL_DIR/SKILL.md" "collision suffix v3"
    assert_grep 'mkdir -p ~/docs/epiphany/prompts' "$SKILL_DIR/SKILL.md" "save path mkdir"
    assert_grep 'STEP 8 — SESSION ARTIFACTS' "$SKILL_DIR/SKILL.md" "STEP 8"
    assert_grep '^## Chained spec\+plan execution' "$SKILL_DIR/SKILL.md" "chained spec+plan section"
    assert_grep '^## Stage Introspection' "$SKILL_DIR/SKILL.md" "stage introspection section"
    assert_grep 'YYYYMMDD-\{topic_slug\}-plan' "$SKILL_DIR/SKILL.md" "plan session suffix"
    assert_grep 'show me the analysis' "$SKILL_DIR/SKILL.md" "introspection mapping"
    assert_grep 'Quick Analysis inline' "$SKILL_DIR/SKILL.md" "FAST quick analysis"
    assert_grep 'Zero subagent spawns' "$SKILL_DIR/SKILL.md" "FAST zero spawns"
    assert_grep 'prompt-epiphany --minimal' "$SKILL_DIR/SKILL.md" "FAST minimal technique subset ref"
    for t in T1 T2 T3 T4 T5 T6 T7 T8 T9 T10 T11 T12 T13; do
        assert_grep "\\b$t\\b" "$SKILL_DIR/SKILL.md" "technique $t"
    done
    assert_grep 'Application order' "$SKILL_DIR/SKILL.md" "technique ordering"
    assert_grep '^## Verification Checks' "$SKILL_DIR/SKILL.md" "verification checks section"
    for c in 6a 6b 6c 6d 6e 6f 6g 6h 6i 6j 6k 6l; do
        assert_grep "\\b$c\\b" "$SKILL_DIR/SKILL.md" "check $c"
    done
    for c in S7a S7b S7c S7d S7e S7f S7g S7h S7i S7j S7k; do
        assert_grep "\\b$c\\b" "$SKILL_DIR/SKILL.md" "check $c"
    done
    for c in P9a P9b P9c P9d P9e P9f P9g P9h P9i; do
        assert_grep "\\b$c\\b" "$SKILL_DIR/SKILL.md" "check $c"
    done
    assert_grep '^## Specification Mode Pipeline' "$SKILL_DIR/SKILL.md" "spec pipeline section"
    assert_grep '^## Plan Mode Pipeline' "$SKILL_DIR/SKILL.md" "plan pipeline section"
    for s in S1 S2 S3 S4 S5 S6 S7; do
        assert_grep "\\bStep $s\\b" "$SKILL_DIR/SKILL.md" "pipeline step $s"
    done
    for p in P1 P2 P3 P4 P5 P6 P7 P8 P9; do
        assert_grep "\\bStep $p\\b" "$SKILL_DIR/SKILL.md" "pipeline step $p"
    done
    assert_grep '^## Output Formats' "$SKILL_DIR/SKILL.md" "output formats section"
    assert_grep '^## Schemas' "$SKILL_DIR/SKILL.md" "schemas section"
    assert_grep '<meta source="epiphany-prompt"/>' "$SKILL_DIR/SKILL.md" "meta marker"
    assert_grep 'Enhancement contract schema' "$SKILL_DIR/SKILL.md" "enhancement contract"
    assert_grep 'Verification report schema' "$SKILL_DIR/SKILL.md" "verification report"
    assert_grep '00-config' "$SKILL_DIR/SKILL.md" "00-config schema"
fi

# All 11 module files + frontmatter
MODULES=(
    m12-analysis-ideation.md
    m3-synthesis.md
    m4-verification.md
    m5-expansion.md
    m4m5-verify-output.md
    mspec12-domain-req.md
    mspec3-synthesis.md
    mspec4m5-verify-output.md
    mplan12-analysis-design.md
    mplan3-synthesis.md
    mplan4m5-verify-output.md
)
for m in "${MODULES[@]}"; do
    assert_file "$SKILL_DIR/modules/$m"
done

# Run frontmatter validator across all existing module files
EXISTING=()
for m in "${MODULES[@]}"; do
    [[ -f "$SKILL_DIR/modules/$m" ]] && EXISTING+=("$SKILL_DIR/modules/$m")
done
if (( ${#EXISTING[@]} > 0 )); then
    if ! "$SKILL_DIR/tests/validate-frontmatter.py" "${EXISTING[@]}"; then
        FAIL=1
    fi
fi

if (( FAIL == 0 )); then
    echo "PASS: all structural checks passed"
    exit 0
else
    echo "FAILURES detected (see above)"
    exit 1
fi
