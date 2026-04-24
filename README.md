# D&D Campaign Journal

A multi-campaign D&D journal site built with Jekyll and deployed on GitHub Pages. Session transcripts are processed with [Claude Code](https://claude.ai/code) into polished narrative summaries, character pages, and an interactive journey timeline.

**Live site:** [joosthart.github.io/dnd-campaign-journal](https://joosthart.github.io/dnd-campaign-journal/)

## Campaigns

### [Wild Beyond the Witchlight](wild-beyond-the-witchlight/)
A D&D 5e adventure through the Feywild. Four adventurers navigate a mysterious carnival and the misty lands beyond.

- **Erophin** — Wood elf ranger, crowned the Witchlight Monarch
- **Pip Moonstep** — Haregon bladesinger searching for his lost rhythm
- **Baba (Uma)** — Tabaxi monk, reluctant carnival worker turned adventurer
- **Aruni** — Elf druid searching for someone she can't remember

---

## Project Structure

```
DnD/
├── _config.yml                        # Jekyll site config
├── _data/
│   ├── campaigns.yml                  # Campaign registry (drives nav + homepage)
│   └── <slug>/
│       └── journey.yml                # Journey timeline data (per campaign)
├── _includes/
│   └── nav.html                       # Data-driven navigation
├── _layouts/
│   ├── default.html                   # Base HTML shell
│   ├── home.html                      # Homepage layout
│   ├── page.html                      # Generic content page
│   ├── session.html                   # Session with prev/next navigation
│   └── journey.html                   # Journey timeline (generic)
├── assets/
│   ├── css/style.css                  # All styles
│   └── images/<slug>/                 # Character portraits (per campaign)
├── scripts/
│   ├── new-campaign.sh                # Scaffold a new campaign
│   └── new-character.sh               # Scaffold a new character page
├── index.md                           # Campaign hub homepage
├── <slug>-journey.html                # Journey page (per campaign, frontmatter only)
│
└── <campaign-folder>/                 # One folder per campaign
    ├── index.md                       # Campaign landing page
    ├── sessions.md                    # Session list
    ├── the_story_so_far.md            # Running narrative + lore tracker
    ├── CLAUDE.md                      # AI workflow rules for this campaign
    ├── characters/
    │   ├── index.md                   # Character list with portraits
    │   └── <character>.md             # Individual character pages
    ├── summaries/
    │   └── summary_session_N.md       # Polished session summaries
    └── transcripts/
        └── transcript_session_N.md    # Raw transcripts (excluded from build)
```

### Key Design Decisions

- **Campaign isolation**: Each campaign has its own folder, data namespace (`_data/<slug>/`), image namespace (`assets/images/<slug>/`), and URL prefix (`/<slug>/`). No content mixing.
- **Data-driven nav**: Navigation reads from `_data/campaigns.yml`. On a campaign page, the nav shows that campaign's links. On the homepage, it shows all campaigns.
- **Session scoping**: The session layout filters prev/next navigation by `campaign` frontmatter, so sessions from different campaigns never intermix.
- **Generic layouts**: All layouts are campaign-agnostic. Campaign-specific content lives in data files and page frontmatter.

---

## Adding a New Campaign

Run the scaffold script:

```bash
./scripts/new-campaign.sh <slug> "Campaign Name"

# Example:
./scripts/new-campaign.sh cos "Curse of Strahd"
```

This creates everything you need:

| What | Where |
|---|---|
| Campaign content folder | `<slug>/` (with index, sessions, characters, story tracker) |
| Campaign CLAUDE.md | `<slug>/CLAUDE.md` (AI workflow rules) |
| Journey data | `_data/<slug>/journey.yml` |
| Journey page | `<slug>-journey.html` |
| Claude skill | `.claude/skills/<slug>-new-session/` |
| Image folder | `assets/images/<slug>/` |
| Campaign registration | Appended to `_data/campaigns.yml` |
| Transcript exclusion | Added to `_config.yml` exclude list |

After running the script:

1. Edit `<slug>/index.md` with your campaign description
2. Edit `<slug>/CLAUDE.md` with any campaign-specific spoiler rules
3. Edit `_data/campaigns.yml` to set a proper tagline
4. Add character portraits to `assets/images/<slug>/`
5. Create character pages (see below)
6. Drop your first transcript and process it

### Adding a Character

```bash
./scripts/new-character.sh <campaign-slug> <character-slug> "Name" "Race" "Class"

# Example:
./scripts/new-character.sh cos ezmerelda "Ezmerelda d'Avenir" "Vistani" "Monster Hunter"
```

Then add the character to the campaign's `characters/index.md` and `index.md` party grid.

---

## Adding a New Session

### 1. Drop the transcript

Place the raw transcript at:
```
<campaign-folder>/transcripts/transcript_session_<N>.md
```

### 2. Process with Claude Code

Each campaign has a Claude skill that reads the transcript and produces all updates:

```
/<slug>-new-session <session-number>

# Example:
/wbtw-new-session 3
```

This will:
- Read all prior context (previous summaries + story tracker)
- Write a polished narrative summary in `summaries/`
- Update `the_story_so_far.md` (new chapter, NPCs, lore, open threads)
- Update character pages with new information
- Add the session to the session list and campaign landing page

### 3. Update the journey timeline

After processing, manually append new locations to `_data/<slug>/journey.yml`:

```yaml
- type: line
  region: regionname

- type: stop
  region: regionname
  category: Landmark          # Landmark, Location, or Dangerous
  name: "New Location"
  short: "One-line description."
  long: >-
    Detailed description of what happened here. Shown when
    the user clicks on the stop in the journey timeline.
  session: 3
```

### 4. Review and push

Review the generated content, make any edits, commit, and push. GitHub Pages deploys automatically.

---

## Local Development

Requires Ruby (3.0+) and Bundler:

```bash
bundle install
bundle exec jekyll serve
```

If using macOS system Ruby (too old), use Homebrew Ruby:

```bash
export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/4.0.0/bin:$PATH"
bundle install
bundle exec jekyll serve
```

The site will be available at `http://127.0.0.1:4000/dnd-campaign-journal/`.

---

## Page Frontmatter Reference

Every content page in a campaign needs these frontmatter fields:

```yaml
---
layout: page              # or session, journey
title: "Page Title"
permalink: /<slug>/path/
campaign: <slug>           # Must match the campaign slug
---
```

Session pages additionally need:

```yaml
session_number: 1          # Used for prev/next navigation
```

Journey pages need:

```yaml
layout: journey
subtitle: "Description shown below the title"
legend:
  - label: Region Name
    color: css-variable-name
```
