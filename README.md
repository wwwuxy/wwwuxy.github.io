# wwwuxy homepage

A static AcademicPages/Jekyll homepage for wwwuxy, focused on computer
architecture, numerical computing, vector processing, and AI accelerators.

## Local development

Install the Ruby dependencies, then start the development server:

```bash
bundle install
bundle exec jekyll serve
```

Visit <http://localhost:4000>. Use `bundle exec jekyll build` for a production
build, or `bash scripts/audit-site.sh` to run the content and generated-site
checks together. The audit also requires Node.js for a focused JavaScript
runtime check; its HTML parser is already included in the Ruby bundle.

After changing the navigation or `assets/js/_main.js`, regenerate the served
JavaScript bundle using the existing npm build tools:

```bash
npm install --ignore-scripts
npm run build:js
node scripts/check-site-js.js
```

## Maintenance and deployment

- Markdown pages: `_pages/`
- Project records: `_data/projects.yml`
- Site configuration: `_config.yml`
- Posts: `_posts/`

GitHub Pages publishes the generated Jekyll site after Pages is configured for
this repository's publishing branch. The site uses GitHub Pages-compatible
plugins and needs no custom deployment logic or secrets.
