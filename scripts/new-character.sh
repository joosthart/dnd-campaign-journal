#!/bin/bash
#
# Scaffold a new character page for an existing campaign.
#
# Usage: ./scripts/new-character.sh <campaign-slug> <character-slug> "Character Name" "Race" "Class"
#
# Example: ./scripts/new-character.sh cos strahd "Count Strahd" "Vampire" "Nobleman"
#          ./scripts/new-character.sh wbtw pip-moonstep "Pip Moonstep" "Haregon" "Bladesinger Wizard"

set -euo pipefail

if [ $# -lt 5 ]; then
  echo "Usage: $0 <campaign-slug> <character-slug> \"Character Name\" \"Race\" \"Class\""
  echo "Example: $0 cos ezmerelda \"Ezmerelda\" \"Vistani\" \"Monster Hunter\""
  exit 1
fi

CAMPAIGN="$1"
CHAR_SLUG="$2"
CHAR_NAME="$3"
RACE="$4"
CLASS="$5"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Find campaign folder
CAMPAIGN_DIR=""
for dir in "$ROOT"/*/; do
  if [ -f "$dir/CLAUDE.md" ]; then
    # Check if this dir's index.md has the right campaign slug
    if grep -q "campaign: $CAMPAIGN" "$dir/index.md" 2>/dev/null; then
      CAMPAIGN_DIR="$dir"
      break
    fi
  fi
done

if [ -z "$CAMPAIGN_DIR" ]; then
  echo "Error: Campaign '$CAMPAIGN' not found. Run ./scripts/new-campaign.sh first."
  exit 1
fi

CHAR_FILE="$CAMPAIGN_DIR/characters/$CHAR_SLUG.md"

if [ -f "$CHAR_FILE" ]; then
  echo "Error: Character file already exists at $CHAR_FILE"
  exit 1
fi

cat > "$CHAR_FILE" << EOF
---
layout: page
title: "$CHAR_NAME"
permalink: /$CAMPAIGN/characters/$CHAR_SLUG/
campaign: $CAMPAIGN
---

<img src="{{ site.baseurl }}/assets/images/$CAMPAIGN/profile-picture-$CHAR_SLUG.jpeg" alt="$CHAR_NAME" class="character-portrait">

**Race:** $RACE | **Class:** $CLASS | **Age:** Unknown

*Add character description here. Only include information revealed in sessions.*
EOF

echo "Created $CHAR_FILE"
echo ""
echo "Next steps:"
echo "  1. Edit $CHAR_FILE with character details from sessions"
echo "  2. Add a portrait to assets/images/$CAMPAIGN/profile-picture-$CHAR_SLUG.jpeg"
echo "  3. Add the character to $CAMPAIGN_DIR/characters/index.md"
echo "  4. Add the character to $CAMPAIGN_DIR/index.md party grid"
