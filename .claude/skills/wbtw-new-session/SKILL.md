---
name: wbtw-new-session
description: Process a new Wild Beyond the Witchlight session transcript into a polished summary and update the campaign
argument-hint: <session-number>
disable-model-invocation: true
---

# Wild Beyond the Witchlight — New Session Processing

Process the transcript for session **$ARGUMENTS** and produce all campaign journal updates for the Wild Beyond the Witchlight campaign.

## Steps

1. **Read context**: Read `wild-beyond-the-witchlight/the_story_so_far.md` and the previous session's summary from `wild-beyond-the-witchlight/summaries/` to understand where the story left off.

2. **Read the new transcript**: Read the full transcript at `wild-beyond-the-witchlight/transcripts/transcript_session_$ARGUMENTS.md`. It will be large — read it in chunks to get everything.

3. **Write the session summary**: Create `wild-beyond-the-witchlight/summaries/summary_session_$ARGUMENTS.md`. Start the file with Jekyll front matter, then the content:
   ```
   ---
   layout: session
   title: "Session $ARGUMENTS: [Evocative Title]"
   session_number: $ARGUMENTS
   permalink: /wbtw/sessions/$ARGUMENTS/
   campaign: wbtw
   ---
   ```
   Followed by:
   - **Session title**: `# Session $ARGUMENTS: [Evocative Title]`
   - **Characters present**: Who was there this session
   - **Recap**: 1-2 sentences on where last session left off
   - **Narrative summary**: Past tense, third person, broken into ### sections by major scene. Engaging prose — not bullet points. Capture events, dialogue highlights, combat, discoveries, and character moments.
   - **Key discoveries & decisions**: Bullet list
   - **Open threads**: What's unresolved, what they're pursuing next
   - **Notable quotes**: Funny or memorable lines from the transcript

4. **Update the running narrative**: Edit `wild-beyond-the-witchlight/the_story_so_far.md`:
   - Update the "Last updated after" line
   - Add a new `## Chapter N` section with the session's events as continuous narrative prose, matching the tone and style of existing chapters
   - Update **The Party** section if any character details changed (new abilities, items, revelations)
   - Update **What We Know** — add new NPCs, lore, inventory; update existing entries with new information
   - Update **Open Threads** — add new questions, remove or mark any that were answered this session

5. **Update the NPC directory**: Edit `_data/wbtw/npcs.yml`:
   - Add a new YAML entry for every named NPC the party met or learned about for the first time
   - Update the `last_session` field on existing entries that appeared again
   - Update `status`, `location`, or `long` if anything important changed (defeated, joined as ally, moved, revealed information)
   - Use only knowledge the party has gained in-game — no spoilers
   - Status values: `ally` | `neutral` | `hostile` | `defeated` | `missing` | `deceased` | `unknown`
   - Group NPCs via the `faction` field (e.g. "Witchlight Carnival", "Hourglass Coven", "Soggy Court", "Brigand Clan", "Summer Court", "Mysterious"). Reuse existing factions where possible; create new ones only when needed.

6. **Update the journey timeline**: Edit `_data/wbtw/journey.yml`:
   - Add new stops for each notable location the party visited this session
   - Add region banners and lines as the party crosses into new sub-realms

7. **Update the website**:
   - Add the new session to the card lists in `wild-beyond-the-witchlight/index.md` and `wild-beyond-the-witchlight/sessions.md` (chronological order — append at the bottom).
   - Update character pages in `wild-beyond-the-witchlight/characters/` with any new information revealed this session (new abilities, items, relationships, combat moments). Only include information that has been shown in sessions — never include backstory details the other players haven't learned in-game.

8. **Present results**: Show the user the new summary and a brief changelog of what was updated (story, NPCs, journey, characters) so they can review.

## Critical Rules

- **NO SPOILERS**: Never include information from the published Wild Beyond the Witchlight module that the players haven't discovered in their sessions. Only write about what actually happened in the transcripts.
- **Tone**: Write like a campaign chronicler. Vivid but concise. Preserve the group's humor and personality.
- **Character names**: Use character names (Pip, Erophin, Baba, Aruni), not player names.
- **Consistency**: Match the prose style of existing chapters in `the_story_so_far.md`.
