#!/bin/bash
#
# Scaffold a new D&D campaign.
#
# Usage: ./scripts/new-campaign.sh <slug> "Campaign Name"
#
# Example: ./scripts/new-campaign.sh cos "Curse of Strahd"
#
# This creates the full folder structure, data files, pages, Claude skill,
# and registers the campaign in _data/campaigns.yml.

set -euo pipefail

if [ $# -lt 2 ]; then
  echo "Usage: $0 <slug> \"Campaign Name\""
  echo "Example: $0 cos \"Curse of Strahd\""
  exit 1
fi

SLUG="$1"
NAME="$2"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"

# Check if campaign already exists
if grep -q "slug: $SLUG" "$ROOT/_data/campaigns.yml" 2>/dev/null; then
  echo "Error: Campaign '$SLUG' already exists in _data/campaigns.yml"
  exit 1
fi

echo "Creating campaign: $NAME ($SLUG)"
echo ""

# ── Campaign content folder ──
CAMPAIGN_DIR="$ROOT/$SLUG"
mkdir -p "$CAMPAIGN_DIR"/{transcripts,summaries,characters}

echo "Created $CAMPAIGN_DIR/"

# ── Campaign landing page ──
cat > "$CAMPAIGN_DIR/index.md" << EOF
---
layout: page
title: "$NAME"
permalink: /$SLUG/
campaign: $SLUG
---

*Add your campaign description here.*

## The Party

<ul class="party-grid">
  <!-- Add party members:
  <li>
    <img src="{{ site.baseurl }}/assets/images/$SLUG/profile-name.jpeg" alt="Name" class="party-portrait">
    <strong><a href="{{ site.baseurl }}/$SLUG/characters/name/">Character Name</a></strong>
    <span class="race">Race Class</span>
  </li>
  -->
</ul>

## Sessions

<ul class="card-list">
  <!-- Sessions will be added here as they are played -->
</ul>
EOF

# ── Sessions index ──
cat > "$CAMPAIGN_DIR/sessions.md" << EOF
---
layout: page
title: Sessions
permalink: /$SLUG/sessions/
campaign: $SLUG
---

All session summaries from our $NAME campaign.

<ul class="card-list">
  <!-- Sessions will be added here as they are played -->
</ul>
EOF

# ── Characters index ──
cat > "$CAMPAIGN_DIR/characters/index.md" << EOF
---
layout: page
title: Characters
permalink: /$SLUG/characters/
campaign: $SLUG
---

The adventurers of $NAME — as known from our sessions.

<ul class="character-list">
  <!-- Characters will be added here:
  <li>
    <img src="{{ site.baseurl }}/assets/images/$SLUG/profile-name.jpeg" alt="Name" class="character-thumb">
    <div>
      <a href="{{ site.baseurl }}/$SLUG/characters/name/">Character Name</a>
      <span class="race">Race Class</span>
      <p class="description">Short description.</p>
    </div>
  </li>
  -->
</ul>
EOF

# ── Story tracker ──
cat > "$CAMPAIGN_DIR/the_story_so_far.md" << EOF
---
layout: page
title: The Story So Far
permalink: /$SLUG/story/
campaign: $SLUG
---

*Last updated after: Session 0*

---

## The Party

<!-- Add party member descriptions here -->

---

<!-- Chapters will be added as sessions are played -->

## What We Know

<!-- NPCs, lore, inventory tracking -->

## Open Threads

<!-- Unresolved questions and hooks -->
EOF

# ── CLAUDE.md ──
cat > "$CAMPAIGN_DIR/CLAUDE.md" << EOF
# $NAME — Campaign Project

## What This Is
A D&D campaign journal for a group playing **$NAME**. This project contains session transcripts, summaries, and character pages. Claude helps produce polished session summaries and maintain a running narrative.

## The Golden Rule: NO SPOILERS

**NEVER include information the players have not yet discovered in-game.** This is the most important rule in this project.

- Only reference campaign/module knowledge that has already been revealed in the transcripts.
- Do not hint at, foreshadow, or allude to future events, NPC true identities, or plot twists from the published module that the players haven't encountered yet.
- If unsure whether the players know something, leave it out.

## Project Structure

\`\`\`
$SLUG/
  transcripts/          # Raw session transcripts
  summaries/            # Polished session summaries (Claude-written)
  characters/           # Character pages (generated from session content only)
  the_story_so_far.md   # Running narrative and tracker
\`\`\`

## Workflow: Adding a New Session

1. Drop a new transcript into \`$SLUG/transcripts/\`.
2. Run \`/$SLUG-new-session <number>\` to process it.
3. Review the output and request edits.

## Summary Format

Each summary should include:
- **Session number and title** — a short evocative title
- **Characters present** — who was there this session
- **Recap** — 1-2 sentence reminder of where we left off
- **Narrative summary** — past tense, third person, engaging prose
- **Key discoveries & decisions** — bullet list
- **Open threads** — what's unresolved
- **Notable quotes** — funny or memorable lines

## Tone
- Write like a campaign chronicler: vivid but concise.
- Preserve the humor and personality of the group.
- Use character names, not player names, in the narrative.
EOF

# ── Claude skill for processing sessions ──
SKILL_DIR="$ROOT/.claude/skills/$SLUG-new-session"
mkdir -p "$SKILL_DIR"

cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SLUG-new-session
description: Process a new $NAME session transcript into a polished summary and update the campaign
argument-hint: <session-number>
disable-model-invocation: true
---

# $NAME — New Session Processing

Process the transcript for session **\$ARGUMENTS** and produce all campaign journal updates for the $NAME campaign.

## Steps

1. **Read context**: Read \`$SLUG/the_story_so_far.md\` and the previous session's summary from \`$SLUG/summaries/\` to understand where the story left off.

2. **Read the new transcript**: Read the full transcript at \`$SLUG/transcripts/transcript_session_\$ARGUMENTS.md\`. It will be large — read it in chunks to get everything.

3. **Write the session summary**: Create \`$SLUG/summaries/summary_session_\$ARGUMENTS.md\`. Start the file with Jekyll front matter, then the content:
   \`\`\`
   ---
   layout: session
   title: "Session \$ARGUMENTS: [Evocative Title]"
   session_number: \$ARGUMENTS
   permalink: /$SLUG/sessions/\$ARGUMENTS/
   campaign: $SLUG
   ---
   \`\`\`
   Followed by:
   - **Characters present**: Who was there this session
   - **Recap**: 1-2 sentences on where last session left off
   - **Narrative summary**: Past tense, third person, broken into ### sections by major scene. Engaging prose — not bullet points.
   - **Key discoveries & decisions**: Bullet list
   - **Open threads**: What's unresolved
   - **Notable quotes**: Funny or memorable lines

4. **Update the running narrative**: Edit \`$SLUG/the_story_so_far.md\`:
   - Update the "Last updated after" line
   - Add a new \`## Chapter N\` section with the session's events as continuous narrative prose
   - Update **The Party** section if any character details changed
   - Update **What We Know** — add new NPCs, lore, inventory
   - Update **Open Threads** — add new questions, resolve answered ones

5. **Update the website**:
   - Add the new session to the card lists in \`$SLUG/index.md\` and \`$SLUG/sessions.md\`
   - Update character pages in \`$SLUG/characters/\` with any new information revealed this session

6. **Present results**: Show the user the new summary and a brief changelog of what was updated.

## Critical Rules

- **NO SPOILERS**: Never include information from the published module that the players haven't discovered in their sessions.
- **Tone**: Write like a campaign chronicler. Vivid but concise. Preserve the group's humor and personality.
- **Character names**: Use character names, not player names, in the narrative.
- **Consistency**: Match the prose style of existing chapters in \`the_story_so_far.md\`.
EOF

# ── Journey data file ──
mkdir -p "$ROOT/_data/$SLUG"

cat > "$ROOT/_data/$SLUG/journey.yml" << EOF
# Journey timeline data for $NAME.
# Add new stops as sessions are played. Only include discovered locations.
#
# Types: region, stop, line, portal
# Categories: Landmark, Location, Dangerous
#
# Example:
#
# - type: region
#   region: regionname
#   name: "Region Display Name"
#   sub: "Session 1"
#
# - type: stop
#   region: regionname
#   category: Landmark
#   name: "Location Name"
#   short: "Brief one-line description."
#   long: >-
#     Detailed description of what happened here. This is shown when
#     the user clicks on the location in the journey timeline.
#   session: 1
#
# - type: line
#   region: regionname
#
# - type: portal
#   label: "Portal Label"
EOF

# ── Journey page ──
cat > "$ROOT/$SLUG-journey.html" << EOF
---
layout: journey
title: Journey Map
permalink: /$SLUG/journey/
campaign: $SLUG
subtitle: "Follow the party's journey through $NAME"
legend: []
# Add legend entries as regions are discovered:
# legend:
#   - label: Region Name
#     color: css-variable-name
---
EOF

# ── Images directory ──
mkdir -p "$ROOT/assets/images/$SLUG"

# ── Register in campaigns.yml ──
cat >> "$ROOT/_data/campaigns.yml" << EOF

- slug: $SLUG
  name: "$NAME"
  tagline: "Add a tagline for $NAME."
  status: active
  nav:
    - label: Story
      url: /$SLUG/story/
    - label: Sessions
      url: /$SLUG/sessions/
    - label: Characters
      url: /$SLUG/characters/
    - label: Journey
      url: /$SLUG/journey/
EOF

# ── Exclude transcripts from build ──
if ! grep -q "$SLUG/transcripts/" "$ROOT/_config.yml"; then
  # Add to exclude list
  sed -i '' "/^exclude:/a\\
\\  - $SLUG/transcripts/" "$ROOT/_config.yml"
fi

# ── Summary ──
echo ""
echo "Campaign '$NAME' ($SLUG) created successfully!"
echo ""
echo "Files created:"
echo "  $SLUG/                          Campaign content folder"
echo "  $SLUG/index.md                  Campaign landing page (/$SLUG/)"
echo "  $SLUG/sessions.md               Sessions list (/$SLUG/sessions/)"
echo "  $SLUG/characters/index.md       Characters list (/$SLUG/characters/)"
echo "  $SLUG/the_story_so_far.md       Story tracker (/$SLUG/story/)"
echo "  $SLUG/CLAUDE.md                 AI workflow instructions"
echo "  $SLUG/transcripts/              Transcript folder"
echo "  $SLUG/summaries/                Summary folder"
echo "  _data/$SLUG/journey.yml         Journey timeline data"
echo "  $SLUG-journey.html              Journey page (/$SLUG/journey/)"
echo "  .claude/skills/$SLUG-new-session/  Claude skill for processing sessions"
echo "  assets/images/$SLUG/            Image folder"
echo ""
echo "Registered in _data/campaigns.yml"
echo ""
echo "Next steps:"
echo "  1. Edit $SLUG/index.md with your campaign description"
echo "  2. Edit $SLUG/CLAUDE.md with campaign-specific rules"
echo "  3. Edit _data/campaigns.yml to add a proper tagline"
echo "  4. Add character portraits to assets/images/$SLUG/"
echo "  5. Add character pages to $SLUG/characters/"
echo "  6. Drop your first transcript into $SLUG/transcripts/"
echo "  7. Run /$SLUG-new-session 1 to process it"
