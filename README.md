# 吴欣宇个人主页

A static AcademicPages/Jekyll homepage for 吴欣宇, focused on computer
architecture, numerical computing, vector processing, and AI accelerators.

## Local development

Use Ruby 3.3, install the Ruby dependencies, then start the development server:

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

The workflow in `.github/workflows/deploy.yml` builds this Jekyll site and
publishes the generated `_site/` directory whenever `main` is pushed. In the
repository's **Settings → Pages → Build and deployment**, set **Source** to
**GitHub Actions**. The workflow can also be started from the Actions tab.

This site does not use `npm run build` or a `dist/` directory for deployment.
The npm script above is only for regenerating the committed JavaScript bundle
after its source changes. No deployment secrets are required.
