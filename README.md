# Nexus PDF Editor

A focused, in-place PDF text editor. Static, client-side only — deploys straight to
GitHub Pages, no backend, no build step.

## What's new in this version
- **Real editing surface, not a form:** click any word on the rendered page and it
  becomes editable right there, at its real size and position.
- **Toolset:** Edit (default), Add Text (click anywhere to drop a new text box),
  Highlight (drag a marker box), Redact (drag a solid black box).
- **Floating context toolbar** appears above whatever you're editing — font size,
  color, alignment, delete.
- **Undo / redo**, page navigator, zoom, **Find & Replace**, and keyboard shortcuts
  (Ctrl/Cmd+Z undo, Ctrl/Cmd+Shift+Z or Ctrl/Cmd+Y redo, Ctrl/Cmd+S export).
- **Export** rebuilds a real PDF with pdf-lib: edited text is whited-out-and-redrawn
  at its original coordinates, added text/highlights/redactions are drawn on top.

## Deploy to GitHub Pages
1. Push `index.html` to a GitHub repo (root or `/docs`).
2. Repo → **Settings → Pages** → Source: deploy from branch → pick the branch/folder → Save.
3. Live at `https://<username>.github.io/<repo>/` shortly after.

Everything loads from CDN (pdf.js, pdf-lib) and runs in the visitor's browser — nothing
is uploaded anywhere.

## Fixes in this version
- **Edited text no longer overlaps the original** — when you edit or replace a word,
  the box now gets a proper white patch underneath it (matching what export does), so
  it reads cleanly instead of the old and new text visually colliding.
- **Spellcheck squiggles removed** from editable text — they were making edits look
  messy.
- **Bottom-docked toolbar on mobile** — the font/color/size toolbar now pins to the
  bottom of the screen on phones instead of floating awkwardly near your finger, and
  includes its own **⬇ Export** button so you don't have to scroll back up top.

## New: font styles, colors, quick actions, AI agent
- **Floating toolbar** (appears over anything you click/add) now has font family
  (Helvetica / Times / Courier), bold, italic, size, color, alignment.
- **Quick action buttons**: Rotate page, Delete page, alongside Undo/Redo.
- **🤖 AI Agent panel**:
  - *Auto-redact PII* — scans the extracted text of every page with regex for emails,
    phone numbers, and card-like digit runs, and drops a redaction box on each match.
    Runs fully offline, no key needed. This is the "agentic" part — it perceives the
    document, decides what looks sensitive, and acts by placing redactions — kept
    deliberately simple (regex) so it's fast and predictable rather than guessing.
  - *Ask about this document* — optional, bring-your-own Anthropic API key (stored
    only in your browser's localStorage). Sends the extracted page text as context so
    you can ask questions grounded in the actual document — a lightweight, single-shot
    version of retrieval-augmented generation. It calls `api.anthropic.com` directly
    from the browser, which means **your API key is visible in that request** — don't
    use a key you're not comfortable exposing client-side, and note some networks/CORS
    policies may block the call entirely since there's no backend proxying it.
- **Dockerfile** included for local/self-hosted preview (`docker build && docker run`)
  — GitHub Pages itself doesn't need it at all, it's a convenience for local testing.

## What I didn't fake
A CNN (convolutional neural net) doesn't have a real job to do here — this edits real
PDF text, not images, so there's no image classification task for one to solve; the
in-browser OCR path from the earlier version (Tesseract.js) is the honest equivalent
for image-based documents. Similarly, "RAG" above is the honest lightweight version
(stuff the document's text as context) rather than a fake vector database, and the
"agent" is a real, working rule-based scan-and-act loop rather than a name slapped on
nothing. Multi-agent orchestration, a trained layout-understanding model, and true
vector-embedding RAG are real ML/infra projects that need a backend and training data —
happy to help design one if you want to go there next.

## Honest limits
- Edited/added text exports in Helvetica — it won't match a custom embedded font in the
  original PDF pixel-for-pixel (embedding the source font is possible with pdf-lib +
  fontkit, but needs the actual font file, which isn't extractable from every PDF).
- This edits text runs and adds overlays; it doesn't reflow surrounding paragraphs,
  tables, or images if new text is longer than the space it replaces.
- Best for fixing/adding words, names, dates, numbers, redacting/highlighting regions —
  not a substitute for full desktop PDF authoring software on complex layouts.
