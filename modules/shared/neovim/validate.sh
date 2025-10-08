#!/usr/bin/env bash
# Neovim configuration validation script
# This script helps validate the neovim configuration

set -e

echo "🔍 Validating Neovim Configuration..."
echo

# Check if required directories exist
echo "📁 Checking directory structure..."
if [ -d "lua/core" ]; then
  echo "  ✓ lua/core exists"
else
  echo "  ✗ lua/core missing"
  exit 1
fi

if [ -d "lua/plugins" ]; then
  echo "  ✓ lua/plugins exists"
else
  echo "  ✗ lua/plugins missing"
  exit 1
fi

# Check if core files exist
echo
echo "📋 Checking core files..."
for file in lua/core/options.lua lua/core/keymaps.lua lua/core/autocmds.lua; do
  if [ -f "$file" ]; then
    echo "  ✓ $file exists"
  else
    echo "  ✗ $file missing"
    exit 1
  fi
done

# Check if main files exist
echo
echo "📋 Checking main files..."
for file in init.lua default.nix; do
  if [ -f "$file" ]; then
    echo "  ✓ $file exists"
  else
    echo "  ✗ $file missing"
    exit 1
  fi
done

# Check plugin files
echo
echo "🔌 Checking plugin files..."
plugin_count=$(ls -1 lua/plugins/*.lua 2>/dev/null | wc -l)
echo "  Found $plugin_count plugin files"

# List all plugins
echo
echo "📦 Plugin modules:"
for plugin in lua/plugins/*.lua; do
  name=$(basename "$plugin" .lua)
  echo "  - $name"
done

echo
echo "✅ Validation complete!"
