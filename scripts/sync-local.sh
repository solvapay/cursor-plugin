#!/bin/bash
SRC="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../plugins/solvapay" && pwd )"
DEST="$HOME/.cursor/plugins/local/solvapay"

sync_plugin() {
  rsync -a --delete --exclude='.DS_Store' "$SRC/" "$DEST/"
  echo "[$(date +%H:%M:%S)] Synced to $DEST"
}

sync_plugin

if command -v fswatch &>/dev/null; then
  echo "Watching $SRC for changes..."
  fswatch -o "$SRC" | while read; do
    sync_plugin
  done
else
  echo "Install fswatch for auto-sync: brew install fswatch"
  echo "For now, re-run this script after making changes."
fi
