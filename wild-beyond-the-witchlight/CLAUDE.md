# Wild Beyond the Witchlight — Campaign Project

## What This Is
A D&D campaign journal for a group playing **The Wild Beyond the Witchlight**. This project contains session transcripts, summaries, and character backstories. Claude helps produce polished session summaries and maintain a running narrative.

## The Golden Rule: NO SPOILERS

**NEVER include information the players have not yet discovered in-game.** This is the most important rule in this project.

- Only reference campaign/module knowledge that has already been revealed in the transcripts.
- Do not hint at, foreshadow, or allude to future events, NPC true identities, or plot twists from the published module that the players haven't encountered yet.
- If unsure whether the players know something, leave it out.
- Backstory connections to the campaign should only be noted when the players have made those connections themselves in-session.

## Project Structure

```
wild-beyond-the-witchlight/
  transcripts/          # Raw session transcripts (from Notion note-taker)
  summaries/            # Polished session summaries (Claude-written)
  backstories/          # Player character backstories
  the_story_so_far.md   # Running narrative and tracker
```

## Workflow: Adding a New Session

1. The user drops a new transcript into `wild-beyond-the-witchlight/transcripts/`.
2. Claude reads the transcript alongside all prior summaries, backstories, and `wild-beyond-the-witchlight/the_story_so_far.md`.
3. Claude produces a polished summary in `wild-beyond-the-witchlight/summaries/` following the summary format below.
4. Claude updates `wild-beyond-the-witchlight/the_story_so_far.md`: adds a new chapter to the narrative, updates the "What We Know" section (NPCs, lore, inventory), and refreshes "Open Threads" (adding new ones, resolving answered ones).
5. The user reviews and requests edits.

## Summary Format

Each summary should include:
- **Session number and title** — a short evocative title for the session
- **Characters present** — who was there this session
- **Recap** — 1-2 sentence reminder of where we left off
- **Narrative summary** — the main body, written in past tense, third person. Capture key events, dialogue highlights, combat encounters, discoveries, and character moments. Aim for engaging prose, not dry bullet points.
- **Key discoveries & decisions** — bullet list of important new information learned and choices made
- **Open threads** — what's unresolved, what the party is pursuing next
- **Notable quotes** — funny or memorable lines from the session (if any stand out in the transcript)

## Tone
- Write like a campaign chronicler: vivid but concise.
- Preserve the humor and personality of the group — these are friends having fun.
- Use character names, not player names, in the narrative.

## Characters

Refer to `backstories/` for detailed backstories. Quick reference:
- **Erophin** — Wood elf, ranger-type, golden eyes, horns, accompanied by birds. Lost something unknown.
- **Pip Moonstep** — Haregon bladesinger, lost his rhythm at the carnival 8 years ago. Trained by a faerie mentor in dance-like swordsmanship.
- **Baba (Uma)** — Tabaxi monk, purple skin, works at the carnival. Possible memory/time issues.
- **Aruni** — Druid, 142 years old, dreadlocks, searching for someone she can't remember.
