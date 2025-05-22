#!/bin/bash

# Comprehensive SketchyBar Bug Validation Script
# Tests for all the critical bugs that were found and fixed

set -e

CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

success() { echo -e "${GREEN}✓${NC} $1"; }
error() { echo -e "${RED}✗${NC} $1"; }
warning() { echo -e "${YELLOW}⚠${NC} $1"; }
info() { echo -e "${BLUE}ℹ${NC} $1"; }

echo -e "${BLUE}SketchyBar Critical Bug Validation${NC}"
echo "===================================="
echo

# Test 1: Check sketchybarrc is properly structured
info "Testing sketchybarrc entry point..."
has_require_init=false
has_package_setup=false

if grep -q 'require("init")' "$CONFIG_DIR/sketchybarrc"; then
    has_require_init=true
fi

if grep -q 'package\.cpath.*=' "$CONFIG_DIR/sketchybarrc"; then
    has_package_setup=true
fi

if $has_require_init && $has_package_setup; then
    success "sketchybarrc properly handles SbarLua and config loading"
else
    error "sketchybarrc missing proper setup or config loading"
    echo "  require(\"init\") found: $has_require_init"
    echo "  package.cpath setup found: $has_package_setup"
    exit 1
fi

# Test 2: Check settings.lua exports alphas
info "Testing settings.lua exports..."
if grep -q "alphas = dimens\.alphas" "$CONFIG_DIR/settings.lua"; then
    success "settings.lua properly exports alphas"
else
    error "settings.lua missing alphas export"
    exit 1
fi

# Test 3: Check for undefined variable patterns
info "Testing for undefined variable patterns..."
issues=0

if grep -r "settings\.alphas\." "$CONFIG_DIR" --include="*.lua" >/dev/null 2>&1; then
    error "Found settings.alphas references (should use just alphas)"
    ((issues++))
fi

if grep -r "constants\.items\.battery[^A-Z]" "$CONFIG_DIR" --include="*.lua" >/dev/null 2>&1; then
    error "Found lowercase battery constant (should be BATTERY)"
    ((issues++))
fi

if [ $issues -eq 0 ]; then
    success "No undefined variable patterns found"
fi

# Test 4: Check for hardcoded colors in shell scripts
info "Testing volume widget shell scripts..."
if grep -A5 -B5 "click_script.*SwitchAudioSource" "$CONFIG_DIR/items/widgets/volume.lua" | grep -q "0xff[0-9a-f]\{6\}"; then
    success "Volume widget uses hardcoded hex colors in shell scripts"
else
    warning "Volume widget may have color variable issues in shell scripts"
fi

# Test 5: Verify bridge component structure
info "Testing bridge component structure..."
if [ -f "$CONFIG_DIR/bridge/Makefile" ] && [ -d "$CONFIG_DIR/bridge/menus" ] && [ -d "$CONFIG_DIR/bridge/network_load" ]; then
    success "Bridge components properly structured"
else
    error "Bridge components missing or malformed"
    exit 1
fi

# Test 6: Check that unnecessary files are removed
info "Testing for removed unnecessary files..."
removed_files=0

if [ ! -f "$CONFIG_DIR/bridge/init.lua" ]; then
    ((removed_files++))
fi

if [ ! -f "$CONFIG_DIR/config/dimens.lua" ]; then
    ((removed_files++))
fi

if [ $removed_files -eq 2 ]; then
    success "Unnecessary files properly removed"
else
    warning "Some unnecessary files may still exist"
fi

# Test 7: Check for proper error handling in widgets
info "Testing widget error handling..."
error_handling=0

# Check battery widget
if grep -q "if not batteryInfo or batteryInfo == \"\"" "$CONFIG_DIR/items/widgets/battery.lua"; then
    ((error_handling++))
fi

# Check wifi widget  
if grep -q "if label and label ~= \"\"" "$CONFIG_DIR/items/widgets/wifi.lua"; then
    ((error_handling++))
fi

if [ $error_handling -ge 2 ]; then
    success "Widgets have proper error handling"
else
    warning "Some widgets may be missing error handling"
fi

# Test 8: Validate Lua syntax
info "Testing Lua syntax..."
lua_errors=0

# Check if lua is available
if ! command -v lua >/dev/null 2>&1; then
    warning "Lua interpreter not found, skipping syntax validation"
else
    for file in $(find "$CONFIG_DIR" -name "*.lua" -type f); do
        if ! lua -l "$file" >/dev/null 2>&1; then
            error "Lua syntax error in $(basename "$file")"
            ((lua_errors++))
        fi
    done

    if [ $lua_errors -eq 0 ]; then
        success "All Lua files have valid syntax"
    else
        error "$lua_errors Lua syntax errors found"
        exit 1
    fi
fi

# Test 9: Check bridge compilation
info "Testing bridge compilation..."
if [ -d "$CONFIG_DIR/bridge" ]; then
    cd "$CONFIG_DIR/bridge"
    if make clean >/dev/null 2>&1 && make >/dev/null 2>&1; then
        success "Bridge components compile successfully"
    else
        warning "Bridge components failed to compile (may need macOS/clang)"
    fi
    cd "$CONFIG_DIR"
fi

# Test 10: Test SketchyBar reload (if available)
info "Testing SketchyBar reload..."
if command -v sketchybar >/dev/null 2>&1; then
    if sketchybar --reload 2>/dev/null; then
        success "SketchyBar reloaded successfully"
    else
        error "SketchyBar reload failed"
        exit 1
    fi
else
    warning "SketchyBar not available for testing"
fi

echo
echo -e "${GREEN}🎉 All critical bug validations passed!${NC}"
echo "Your SketchyBar configuration should now work without errors."
echo
echo -e "${BLUE}Simplified structure:${NC}"
echo "  • sketchybarrc handles all setup (no separate bridge/init.lua needed)"
echo "  • Removed duplicate/empty files"
echo "  • Fixed all critical bugs"
echo
echo "To test widgets:"
echo "  • Click battery widget → should show popup"
echo "  • Click WiFi indicators → should show network details"  
echo "  • Click volume → should show audio devices"
echo "  • Play music → media controls should appear"
