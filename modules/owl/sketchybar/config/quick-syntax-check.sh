#!/bin/bash

# Quick syntax checker for SketchyBar config files
# Uses luac if available, otherwise just checks for basic syntax issues

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Quick Syntax Check for SketchyBar Config"
echo "==========================================="

syntax_errors=0
total_files=0

for file in $(find "$CONFIG_DIR" -name "*.lua" -type f); do
    filename=$(basename "$file")
    ((total_files++))
    
    if command -v luac >/dev/null 2>&1; then
        # Use luac for syntax-only checking (best method)
        if luac -p "$file" >/dev/null 2>&1; then
            echo "✓ $filename"
        else
            echo "✗ $filename - Syntax Error"
            luac -p "$file"
            ((syntax_errors++))
        fi
    else
        # Fallback: use loadfile which only checks syntax
        error_output=$(lua -e "loadfile('$file')" 2>&1)
        if [ $? -eq 0 ] || echo "$error_output" | grep -q "attempt to.*global.*sbar"; then
            # Either no error, or just missing 'sbar' global (which is expected)
            echo "✓ $filename"
        else
            echo "✗ $filename - Syntax Error:"
            echo "  $error_output"
            ((syntax_errors++))
        fi
    fi
done

echo
echo "Summary: $total_files files checked, $syntax_errors syntax errors found"

if [ $syntax_errors -eq 0 ]; then
    echo "🎉 All files have valid Lua syntax!"
    echo
    echo "Note: Files depend on 'sbar' global from SketchyBar - this is normal."
    echo "To test the actual config: sketchybar --reload"
else
    echo "❌ Found $syntax_errors real syntax errors that need fixing."
fi
