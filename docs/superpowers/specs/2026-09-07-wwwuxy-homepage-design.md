# wwwuxy AcademicPages Homepage Design

## Purpose and scope

Create the GitHub Pages repository `wwwuxy.github.io` as a static Jekyll site based on the official AcademicPages template. The site presents wwwuxy's public technical interests and open-source work without inventing a name, affiliation, education, employment, publications, awards, or CV details.

The first release includes Home, Research, Projects, Notes, CV, and an external GitHub navigation link. Publications remain supported by the template structure but are not exposed until real content exists.

## Information architecture

The global navigation is Home, Research, Projects, Notes, CV, and GitHub (external). The home page uses AcademicPages' desktop author sidebar plus a right-hand document column. On smaller screens it becomes one column, with the profile information before the main content.

Home content appears in this order:

1. About Me, using only the supplied neutral biography.
2. Research Interests: computer architecture, numerical computing, AI accelerators, and hardware/software co-design.
3. Selected Projects: DFPVU, QVU, PVU, cvikernel, and cviruntime.
4. Open Source, with a link to the GitHub profile.

Research is a direction-oriented page. Projects groups the supplied repositories by architectural/numerical work, accelerator software, and other open source. Notes is an empty-state page prepared for Jekyll posts. CV exposes only supplied research interests, projects, and skills; private or unknown categories are source comments rather than visitor-visible placeholders.

## Content model

Site-wide identity, URL, metadata, and sidebar fields live in `_config.yml`. Navigation lives in `_data/navigation.yml`. Project metadata, including URLs, descriptions, categories, highlights, and tags, lives in `_data/projects.yml`; layouts render it into reusable project cards. Page prose stays in Markdown under `_pages/` so later edits do not require layout changes.

The avatar is stored locally as `images/profile.jpg` when it can be fetched. If downloading is unavailable during setup, the author configuration uses the GitHub avatar URL as a safe fallback.

## Visual design

The design remains academic, technical, and restrained: white or near-white background; deep gray text; muted secondary copy; pale borders; and a single accessible blue for interactive links. It uses system sans-serif fonts and a monospaced stack for inline code and code blocks.

Project entries are compact bordered cards with a clear project link, a concise description, tags, and optional highlights. Borders gain a subtle blue emphasis on hover; there are no heavy shadows, gradients, decorative imagery, animation, dashboards, or live GitHub API calls. The content container is capped near 1200px, with a roughly 250px sidebar and readable main-column line length.

## Technical design

The official AcademicPages source supplies the Jekyll layouts, Sass pipeline, collections, and GitHub Pages-compatible dependency set. Template-only pages, sample records, sample identity data, analytics, and unused navigation are removed or disabled. A small override stylesheet provides the custom cards, content spacing, focus states, and responsive refinements.

SEO configuration supplies the canonical URL, title, description, author, Open Graph fields, sitemap, robots policy, and favicon. The repository stays pure static HTML/CSS/Markdown/YAML; it introduces no frontend framework, client-side data calls, database, server, analytics, or large JavaScript dependency.

## Accessibility and resilience

The site uses meaningful link text, image alt text, a logical heading hierarchy, sufficient contrast, visible keyboard focus, and `noopener noreferrer` on external links. Cards, navigation, images, code blocks, and long project titles wrap within narrow viewports. The layout has breakpoints for desktop, tablet, and 390px mobile widths without horizontal document scrolling.

## Verification

Run `bundle install` as needed and `bundle exec jekyll build` after implementation. Correct build failures before handoff. Check generated routes for `/`, `/research/`, `/projects/`, `/notes/`, and `/cv/`; validate the supplied project and GitHub links; search the resulting source and output for removed AcademicPages demo content; and inspect responsive rendering at 1440, 1280, 1024, 768, and 390px where tooling permits.

## Out of scope

No fabricated biography or credentials, publications/talks/teaching/awards, PDF CV, project images, dynamic GitHub statistics, or post content is included in the initial release. The structure remains ready for those additions when verified source material is available.
