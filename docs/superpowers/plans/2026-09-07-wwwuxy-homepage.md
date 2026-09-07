# wwwuxy AcademicPages Homepage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Deliver a polished, static AcademicPages/Jekyll personal technical homepage for wwwuxy that deploys through GitHub Pages.

**Architecture:** Start from the official AcademicPages source so the Jekyll collections, layouts, Sass pipeline, and GitHub Pages support remain intact. Replace sample content with a small Markdown/YAML content model: page copy stays under `_pages/`, while reusable project metadata lives in `_data/projects.yml` and is rendered by a custom include. A restrained CSS override provides the side-by-side academic layout, compact project cards, and responsive behavior.

**Tech Stack:** Jekyll, AcademicPages, GitHub Pages-compatible Ruby gems, Liquid, Markdown, YAML, Sass/CSS.

**Spec:** `docs/superpowers/specs/2026-09-07-wwwuxy-homepage-design.md`

## Global Constraints

- Use the official AcademicPages template and stay a pure static Jekyll/GitHub Pages website.
- Do not add React, Next.js, Vue, a backend, database, analytics, live GitHub API calls, large JavaScript dependencies, gradients, or fabricated personal data.
- Use only supplied identity data: wwwuxy, GitHub `wwwuxy`, `cswuxy@mails.swust.edu.cn`, and the supplied public project descriptions.
- Keep user-editable content in Markdown/YAML; hide unknown CV, publication, education, experience, and award sections rather than showing visitor-visible placeholders.
- The site URL is `https://wwwuxy.github.io`, base URL is empty, and all five internal routes must build: `/`, `/research/`, `/projects/`, `/notes/`, `/cv/`.
- Preserve mobile usability at 390px with no horizontal document scrolling; code blocks may scroll internally.

---

### Task 1: Bootstrap an AcademicPages-based clean repository

**Files:**
- Create: AcademicPages base files and directories copied from `academicpages/academicpages.github.io`
- Create: `.gitignore`
- Create: `Gemfile`
- Modify: `_config.yml`
- Delete: template sample records in `_publications/`, `_talks/`, `_teaching/`, `_portfolio/`, demo posts, and unused demo pages
- Test: generated `_site/` output from `bundle exec jekyll build`

**Interfaces:**
- Consumes: official AcademicPages repository source and GitHub Pages Ruby environment.
- Produces: a buildable Jekyll base exposing layouts, Sass, collection support, and local Bundler commands for all subsequent pages.

- [ ] **Step 1: Create a minimal failing configuration check**

Run:

```bash
test -f _config.yml && test -f Gemfile && test -d _layouts && test -d _pages
```

Expected: FAIL because the empty repository has no AcademicPages files.

- [ ] **Step 2: Download the official template into a temporary directory and copy its tracked site files without its Git history**

Run:

```bash
template_dir=$(mktemp -d)
git clone --depth 1 https://github.com/academicpages/academicpages.github.io.git "$template_dir"
rsync -a --exclude .git --exclude README.md "$template_dir"/ ./
```

Do not overwrite `docs/superpowers/` or the existing `.git/` directory.

- [ ] **Step 3: Replace `_config.yml` with wwwuxy identity and deployment metadata**

Set these exact values in the template-compatible configuration:

```yaml
title: "wwwuxy"
name: "wwwuxy"
description: "Personal homepage of wwwuxy — computer architecture, numerical computing, vector processing and AI accelerators."
url: "https://wwwuxy.github.io"
baseurl: ""
repository: "wwwuxy/wwwuxy.github.io"
author:
  avatar: "profile.jpg"
  name: "wwwuxy"
  bio: "Computer Architecture · Numerical Computing · AI Accelerators"
  email: "cswuxy@mails.swust.edu.cn"
  github: "wwwuxy"
```

Enable `jekyll-sitemap` and `jekyll-seo-tag` where supported by the template; set `locale: "en-US"` and `timezone: "Asia/Shanghai"`.

- [ ] **Step 4: Remove template demonstrations and disable their collections**

Remove all sample author files, publications, talks, teaching records, portfolio records, posts, profile imagery, and demo navigation entries. Retain empty `_posts/` and `_publications/` directories with `.gitkeep` files. Disable unused collection output in `_config.yml` instead of presenting empty categories in navigation.

- [ ] **Step 5: Run the bootstrap configuration check**

Run:

```bash
test -f _config.yml && test -f Gemfile && test -d _layouts && test -d _pages && test -d _publications && test -d _posts
```

Expected: PASS.

- [ ] **Step 6: Commit the clean AcademicPages base**

```bash
git add .
git commit -m "chore: initialize AcademicPages site"
```

### Task 2: Define navigation, project data, and reusable project-card rendering

**Files:**
- Create: `_data/navigation.yml`
- Create: `_data/projects.yml`
- Create: `_includes/project-card.html`
- Modify: `_includes/masthead.html` or the template navigation include
- Test: `scripts/check-content.sh`

**Interfaces:**
- Consumes: author identity in `_config.yml`; project objects with `slug`, `name`, `subtitle`, `url`, `description`, `category`, `tags`, and optional `highlights` fields.
- Produces: `site.data.projects` for page loops and an `{% include project-card.html project=project %}` Liquid interface.

- [ ] **Step 1: Write the failing content-contract check**

Create `scripts/check-content.sh` with this initial assertion:

```bash
#!/usr/bin/env bash
set -euo pipefail
for route in / /research/ /projects/ /notes/ /cv/; do
  test -n "$route"
done
test -f _data/navigation.yml
test -f _data/projects.yml
test -f _includes/project-card.html
```

Run:

```bash
bash scripts/check-content.sh
```

Expected: FAIL because the data files and include are absent.

- [ ] **Step 2: Add the required navigation items**

Write `_data/navigation.yml` with Home, Research, Projects, Notes, CV, and an external GitHub item. Use `/`, `/research/`, `/projects/`, `/notes/`, `/cv/`, and `https://github.com/wwwuxy` respectively. Set the external link to be rendered with `target="_blank" rel="noopener noreferrer"` in the navigation include.

- [ ] **Step 3: Add all supplied project records**

Write `_data/projects.yml` with accurate records for `dfpvu`, `qvu`, `pvu`, `cvikernel`, `cviruntime`, `cnpy-for-tpu_mlir`, `cvibuilder`, `rt-thread-am`, and `riscv-board-wandering`. Populate descriptions only for the six repositories described by the requirements. For the three remaining records, use their name and GitHub URL only; do not infer descriptions or tags. Mark the homepage selection with `featured: true` only for DFPVU, QVU, PVU, cvikernel, and cviruntime.

- [ ] **Step 4: Implement the card include**

Create `_includes/project-card.html` to render project name, optional subtitle, supplied description, optional highlights list, tags, and a meaningful `View on GitHub` link. Use Liquid conditionals for optional data so empty records never show empty headings, invented copy, or dangling separators.

- [ ] **Step 5: Extend the content-contract check and verify it passes**

Append these checks:

```bash
rg -q 'DFPVU' _data/projects.yml
rg -q 'https://github.com/wwwuxy/DFPVU' _data/projects.yml
rg -q 'project-card' _includes/project-card.html
```

Run:

```bash
bash scripts/check-content.sh
```

Expected: PASS.

- [ ] **Step 6: Commit the shared content layer**

```bash
git add _data _includes scripts/check-content.sh
git commit -m "feat: add navigation and project content model"
```

### Task 3: Build the homepage and content pages

**Files:**
- Create: `_pages/about.md`
- Create: `_pages/research.md`
- Create: `_pages/projects.md`
- Create: `_pages/notes.md`
- Create: `_pages/cv.md`
- Modify: page layout includes only where needed to render data-driven cards
- Test: `scripts/check-content.sh` and `bundle exec jekyll build`

**Interfaces:**
- Consumes: navigation data and `{% include project-card.html project=project %}`.
- Produces: public static routes `/`, `/research/`, `/projects/`, `/notes/`, and `/cv/` with valid page front matter.

- [ ] **Step 1: Extend the failing route/content test**

Append:

```bash
for page in _pages/about.md _pages/research.md _pages/projects.md _pages/notes.md _pages/cv.md; do
  test -f "$page"
done
```

Run:

```bash
bash scripts/check-content.sh
```

Expected: FAIL because the five custom pages are absent.

- [ ] **Step 2: Create the homepage as Markdown-driven content**

Create `_pages/about.md` with `permalink: /` and the `single` layout. Render the supplied neutral About Me copy and source-only comment `<!-- TODO: Replace with full biography -->`; add research-interest entries; loop over only `featured` project objects using the card include; then add the supplied Open Source statement and a GitHub profile link.

- [ ] **Step 3: Create the research page**

Create `_pages/research.md` at `/research/` with direction-only sections: Computer Architecture, Numerical Computing, Mixed-Precision Computing, Vector Processing, AI Accelerator Architecture, and Hardware / Software Co-design. Mention only the supplied technologies, formats, tools, and topics; do not claim a position, project outcome, or unpublished work.

- [ ] **Step 4: Create the projects page**

Create `_pages/projects.md` at `/projects/`. Render category-filtered data records under Processor & Numerical Architecture, AI Accelerator Software Stack, and Other Open Source. The records lacking supplied descriptions must render as a repository link only.

- [ ] **Step 5: Create notes and CV empty-state pages**

Create `_pages/notes.md` at `/notes/` with the supplied two-sentence note introduction and no fake posts. Create `_pages/cv.md` at `/cv/` with research interests, listed open-source projects, and supplied technical skills. Keep source-only HTML comments for future Education, Experience, and Publications, but do not render those section headings.

- [ ] **Step 6: Run content and Jekyll checks**

Run:

```bash
bash scripts/check-content.sh
bundle exec jekyll build
```

Expected: PASS, with generated routes in `_site/` for every required path.

- [ ] **Step 7: Commit all page content**

```bash
git add _pages scripts/check-content.sh
git commit -m "feat: add technical homepage content"
```

### Task 4: Add visual polish, avatar, SEO, and responsive safeguards

**Files:**
- Create: `images/profile.jpg` or use the configured GitHub avatar fallback
- Create: `assets/css/custom.scss`
- Create: `assets/images/favicon.svg`
- Create: `robots.txt`
- Modify: Sass manifest/include ordering required by AcademicPages
- Modify: `_config.yml`
- Test: `scripts/check-content.sh`, `bundle exec jekyll build`, generated HTML checks

**Interfaces:**
- Consumes: template Sass entry point, page and card class names, site metadata.
- Produces: desktop sidebar/right-content layout, mobile single-column rendering, valid SEO metadata, accessible focus states, local favicon, and an author avatar.

- [ ] **Step 1: Write the failing presentation/metadata checks**

Append:

```bash
test -f assets/css/custom.scss
test -f assets/images/favicon.svg
test -f robots.txt
rg -q 'wwwuxy' _config.yml
rg -q 'viewport' _includes/head/custom.html
```

Run:

```bash
bash scripts/check-content.sh
```

Expected: FAIL because the visual and metadata assets are absent.

- [ ] **Step 2: Acquire or safely fall back from the public avatar**

Fetch `https://github.com/wwwuxy.png` to `images/profile.jpg` when the response is an image and the file is non-empty. If it is unavailable, configure the author avatar as `https://github.com/wwwuxy.png`; do not substitute a different person's image.

- [ ] **Step 3: Add the restrained visual system**

Create `assets/css/custom.scss` with system font stacks, accessible colors, a 1200px content cap, compact project-card borders, tag pills with restrained neutral styling, hover and keyboard focus states, `overflow-wrap: anywhere` for URLs/titles, and responsive breakpoints at 1024px and 768px. The 768px rule must remove desktop floats/width constraints and stack the author profile above content. Apply `max-width: 100%` to images and `overflow-x: auto` to preformatted code.

- [ ] **Step 4: Add metadata and favicon files**

Create a simple inline SVG `W` favicon in `assets/images/favicon.svg`, reference it from the head customization include, set canonical/Open Graph metadata through `_config.yml` and `jekyll-seo-tag`, and add a minimal `robots.txt` allowing crawlers and pointing to `/sitemap.xml`.

- [ ] **Step 5: Verify presentation assets and generated metadata**

Run:

```bash
bash scripts/check-content.sh
bundle exec jekyll build
rg -q 'Personal homepage of wwwuxy' _site/index.html
rg -q 'favicon.svg' _site/index.html
```

Expected: PASS.

- [ ] **Step 6: Commit visual and metadata work**

```bash
git add _config.yml _sass assets images robots.txt _includes/head
git commit -m "style: polish academic technical homepage"
```

### Task 5: Document, audit, build, and publish safely

**Files:**
- Create: `README.md`
- Modify: `.github/workflows/pages.yml` only if the official template requires a Pages workflow
- Test: `scripts/check-content.sh`, `bundle exec jekyll build`, `scripts/audit-site.sh`

**Interfaces:**
- Consumes: complete source tree and generated `_site/` directory.
- Produces: concise maintenance documentation, passing static audit, a clean Git history, and a pushed branch only after remote-state inspection.

- [ ] **Step 1: Write the failing source/output audit**

Create `scripts/audit-site.sh`:

```bash
#!/usr/bin/env bash
set -euo pipefail
bash scripts/check-content.sh
bundle exec jekyll build
for path in index.html research/index.html projects/index.html notes/index.html cv/index.html; do
  test -f "_site/$path"
done
for url in \
  https://github.com/wwwuxy \
  https://github.com/wwwuxy/QVU \
  https://github.com/wwwuxy/DFPVU \
  https://github.com/wwwuxy/PVU \
  https://github.com/wwwuxy/cvikernel \
  https://github.com/wwwuxy/cviruntime \
  https://github.com/wwwuxy/cnpy-for-tpu_mlir; do
  rg -q "$url" _site
done
! rg -i -n 'Stuart Geiger|Robert Zupko|Michael Rose' _pages _data _config.yml README.md
```

Run:

```bash
bash scripts/audit-site.sh
```

Expected: FAIL until documentation and the final cleaned build are complete.

- [ ] **Step 2: Write a concise project README**

Document the project purpose, `bundle install`, `bundle exec jekyll serve`, the local URL, GitHub Pages deployment, and the locations of Markdown pages, project YAML, configuration, and posts. Do not copy the AcademicPages template README.

- [ ] **Step 3: Ensure GitHub Pages deploy configuration is minimal and official-compatible**

Keep any official Pages workflow only if required by the template. Do not add custom deployment logic, secrets, or third-party actions beyond the official GitHub Pages build/deploy actions.

- [ ] **Step 4: Run the complete audit and fix each failure before proceeding**

Run:

```bash
bash scripts/audit-site.sh
git status --short
```

Expected: audit PASS; the status output lists only intended documentation/audit changes before commit.

- [ ] **Step 5: Commit verification and documentation**

```bash
git add README.md scripts/audit-site.sh .github
git commit -m "docs: add deployment and maintenance guidance"
```

- [ ] **Step 6: Inspect the requested remote before pushing**

Run:

```bash
git ls-remote https://github.com/wwwuxy/web.git
```

If it has no refs, add it as `origin` and push `main`. If it has refs, fetch and inspect its default branch before choosing a non-destructive integration path. Do not force-push.

- [ ] **Step 7: Push the verified branch when remote authentication and state permit**

Run:

```bash
git remote add origin https://github.com/wwwuxy/web.git
git push -u origin main
```

Expected: the remote reports successful branch creation or update. If authentication or remote history blocks the push, report the exact safe next action without changing remote state.
