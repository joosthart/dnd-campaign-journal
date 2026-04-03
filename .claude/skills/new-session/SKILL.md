---
name: new-session
description: Process a new D&D session transcript into a polished summary and update the running campaign narrative
argument-hint: <session-number>
disable-model-invocation: true
---

# New Session Processing

Process the transcript for session **$ARGUMENTS** and produce all campaign journal updates.

## Steps

1. **Read context**: Read `wild-beyond-the-witchlight/the_story_so_far.md`, all files in `wild-beyond-the-witchlight/backstories/`, and the previous session's summary from `wild-beyond-the-witchlight/summaries/` to understand where the story left off.

2. **Read the new transcript**: Read the full transcript at `wild-beyond-the-witchlight/transcripts/transcript_session_$ARGUMENTS.md`. It will be large — read it in chunks to get everything.

3. **Write the session summary**: Create `wild-beyond-the-witchlight/summaries/summary_session_$ARGUMENTS.md` with this format:
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

5. **Present results**: Show the user the new summary and a brief changelog of what was updated in `the_story_so_far.md` so they can review.

## Critical Rules

- **NO SPOILERS**: Never include information from the published Wild Beyond the Witchlight module that the players haven't discovered in their sessions. Only write about what actually happened in the transcripts.
- **Tone**: Write like a campaign chronicler. Vivid but concise. Preserve the group's humor and personality.
- **Character names**: Use character names (Pip, Erophin, Baba, Aruni), not player names.
- **Consistency**: Match the prose style of existing chapters in `the_story_so_far.md`.
