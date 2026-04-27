---
name: sketch
description: Use when the user asks to mock something up, see design variants, or compare visual options.
allowed-tools: Read, Write, Bash(mkdir *), Bash(pnpm dlx serve *), Bash(pnpm dlx serve), Bash(echo *), Task
---

# sketch

Generate visual design variants the user can compare in a browser.

## Output structure

Each sketch session writes to `<project>/.sketches/<YYYY-MM-DD>-<topic>/`:

```
.sketches/2026-04-25-checkout-form/
├── index.html       # frame: chrome, nav, base styles, fragment loader
├── variant-1.html   # body fragment for variant 1 (no DOCTYPE/head/body)
├── variant-2.html   # body fragment for variant 2
└── variant-3.html   # body fragment for variant 3
```

The frame contains the chrome (DOCTYPE, head, base reset, nav buttons, fragment loader); variants contain only the body content of the design itself, plus an optional `<style>` block for variant-specific CSS. This keeps each variant focused on its actual design choice rather than HTML boilerplate, and keeps the chrome consistent across variants.

## Process

1. Confirm the design subject. Ask how many variants (default 3, max 5).
2. Plan the distinct design choices each variant explores. Choices should be different fundamental directions — different layouts, hierarchies, aesthetic approaches — not minor tweaks. **Be specific** — e.g. "minimalist single-column with serif display type and generous whitespace," not just "minimalist." These directions drive the index.html labels, the subagent prompts, and the creative lane each subagent commits to. Vague directions produce converging variants.
3. Write `index.html` using the template below. Update the button list to match the actual number of variants and substitute the variant labels (e.g. `1: minimalist single-column`).
4. Dispatch one general-purpose subagent per variant **in parallel** (single message, multiple `Task` tool calls). Subagents have no access to this conversation — construct a self-contained prompt for each. Each prompt must include:
   - **Output contract:** Write exactly one file at the absolute path `<sketch-dir>/variant-N.html`. Body fragment only — no DOCTYPE, no `<html>`, no `<head>`, no `<body>`. May start with a `<style>` block for variant-specific CSS. No JavaScript unless the variant specifically demonstrates an interaction.
   - **What the frame already provides:** box-sizing reset, system-ui body font, base color `#111`, line-height 1.5, sticky variant-switcher nav. Do not redefine these unless the variant intentionally overrides them.
   - **The assigned direction** (verbatim from step 2). This is the creative lane — the subagent chooses all details inside it but must not drift to a different aesthetic.
   - **Project context** for placeholder content: a short summary of what the product/page is about, real-feeling copy hooks, target audience. No Lorem ipsum.
   - **Polish guidance** (conditional on the user's signal):
     - If the request implies real design exploration ("design", "polish", "show me what you'd build") — instruct the subagent to invoke the `frontend-design` skill.
     - If the request is a quick comparative mockup ("throw together some layouts", "just show me options") — skip `frontend-design`; the subagent writes the variant directly.

   Wait for all subagents to complete before continuing. If a subagent produces a full HTML document instead of a fragment, re-dispatch that variant with a corrective prompt.

5. After all variant subagents have returned, run `mkdir -p <project>/.claude/.runtime` to create the runtime directory. Start `pnpm dlx serve` in the sketch directory in the background. Write the PID using a bash echo redirect — **do not use the Write tool** (it will prompt for confirmation on new files): `echo $SERVER_PID > "<project>/.claude/.runtime/sketch-server.pid"`
6. Tell the user the URL (default port 3000; capture the actual port from serve's output if it differs) and a one-line description of what each variant explores.

## Frame template

Save this verbatim as `index.html`, updating the button list and labels to match the actual variants:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Sketch</title>
    <style>
      *,
      *::before,
      *::after {
        box-sizing: border-box;
      }
      body {
        margin: 0;
        font-family:
          system-ui,
          -apple-system,
          sans-serif;
        line-height: 1.5;
        color: #111;
      }
      .frame-nav {
        position: sticky;
        top: 0;
        z-index: 1000;
        background: #f5f5f5;
        border-bottom: 1px solid #ddd;
        padding: 0.5rem 1rem;
        display: flex;
        gap: 0.5rem;
        align-items: center;
      }
      .frame-nav .label {
        color: #666;
        font-size: 0.875rem;
        margin-right: 0.5rem;
      }
      .frame-nav button {
        background: white;
        border: 1px solid #ccc;
        padding: 0.4rem 0.8rem;
        border-radius: 4px;
        cursor: pointer;
        font: inherit;
      }
      .frame-nav button[aria-current="true"] {
        background: #111;
        color: white;
        border-color: #111;
      }
      main {
        padding: 0;
      }
    </style>
  </head>
  <body>
    <nav class="frame-nav">
      <span class="label">Variants:</span>
      <button data-variant="variant-1">
        1:
        <!-- description -->
      </button>
      <button data-variant="variant-2">
        2:
        <!-- description -->
      </button>
      <button data-variant="variant-3">
        3:
        <!-- description -->
      </button>
    </nav>
    <main id="content"></main>
    <script>
      const buttons = document.querySelectorAll(".frame-nav button");
      const content = document.getElementById("content");

      async function load(variant) {
        const res = await fetch(variant + ".html");
        content.innerHTML = await res.text();
        // innerHTML doesn't execute <script> tags; re-create them so it does
        content.querySelectorAll("script").forEach((old) => {
          const fresh = document.createElement("script");
          if (old.src) fresh.src = old.src;
          else fresh.textContent = old.textContent;
          old.replaceWith(fresh);
        });
        buttons.forEach((b) =>
          b.setAttribute(
            "aria-current",
            b.dataset.variant === variant ? "true" : "false",
          ),
        );
        location.hash = variant;
      }
      buttons.forEach((b) =>
        b.addEventListener("click", () => load(b.dataset.variant)),
      );
      load((location.hash || "#variant-1").slice(1));
    </script>
  </body>
</html>
```

## Cleanup

The `~/.claude/hooks/session-end-cleanup.sh` hook reads the PID file at session end and kills the server. No manual cleanup needed.

## Constraints

- Variant fragments are body-only — no DOCTYPE, `<html>`, `<head>`, `<body>` tags.
- Each fragment may include a `<style>` block at the top for variant-specific CSS. The frame's base styles cover reset and typography; fragments add what's specific to their design.
- No JavaScript in fragments unless a variant specifically demonstrates an interaction. The frame's loader correctly re-executes inline scripts after fragment swap.
- Realistic placeholder content based on the project context — not "Lorem ipsum."
- `.sketches/` is in the global gitignore — no per-project action needed.
- Variant subagents are dispatched in parallel and have no shared context — the orchestrator's directions in step 2 are the only mechanism keeping variants distinct. Make them specific.
