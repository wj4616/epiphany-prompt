#!/usr/bin/env bash
# Verify epiphany-prompt is in the expected install location and shape
# that Claude Code expects for skill discovery.

set -u
SKILL_DIR="$HOME/.claude/skills/epiphany-prompt"
FAIL=0

echo "== Skill location =="
if [[ ! -d "$SKILL_DIR" ]]; then
    echo "FAIL: $SKILL_DIR does not exist"
    exit 1
fi
echo "OK: $SKILL_DIR exists"

echo "== SKILL.md presence + frontmatter =="
if [[ ! -f "$SKILL_DIR/SKILL.md" ]]; then
    echo "FAIL: SKILL.md missing"; FAIL=1
else
    first_line=$(head -1 "$SKILL_DIR/SKILL.md")
    if [[ "$first_line" != "---" ]]; then
        echo "FAIL: SKILL.md first line is not '---' (got: '$first_line')"; FAIL=1
    else
        echo "OK: SKILL.md starts with frontmatter delimiter"
    fi
    for key in "name: epiphany-prompt" "trigger: /epiphany-prompt" "skill_path:"; do
        if grep -q "^$key" "$SKILL_DIR/SKILL.md"; then
            echo "OK: frontmatter contains '$key'"
        else
            echo "FAIL: frontmatter missing '$key'"; FAIL=1
        fi
    done
fi

echo "== Module directory =="
count=$(find "$SKILL_DIR/modules" -maxdepth 1 -name '*.md' | wc -l)
if (( count != 11 )); then
    echo "FAIL: expected 11 module files in modules/, found $count"; FAIL=1
else
    echo "OK: 11 module files present"
fi

echo "== All module frontmatter valid =="
if "$SKILL_DIR/tests/validate-frontmatter.py" "$SKILL_DIR/modules"/*.md > /dev/null; then
    echo "OK: all module frontmatter valid"
else
    echo "FAIL: module frontmatter validation failed"
    "$SKILL_DIR/tests/validate-frontmatter.py" "$SKILL_DIR/modules"/*.md
    FAIL=1
fi

echo "== kb/ and reports/ exist (from prior harvest — must not be touched) =="
for d in kb reports; do
    if [[ -d "$SKILL_DIR/$d" ]]; then
        echo "OK: $d/ present"
    else
        echo "FAIL: $d/ missing (should exist from prior KB harvest)"; FAIL=1
    fi
done

echo "== Save path directory =="
if [[ -d "$HOME/docs/epiphany/prompts" ]]; then
    echo "OK: save path $HOME/docs/epiphany/prompts/ exists"
else
    echo "NOTE: $HOME/docs/epiphany/prompts/ does not exist yet — will be created on first save"
fi

echo ""
if (( FAIL == 0 )); then
    echo "=== PASS: skill registration check passed ==="
    exit 0
else
    echo "=== FAIL: see above ==="
    exit 1
fi
