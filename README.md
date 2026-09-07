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
checks together.

## Maintenance and deployment

- Markdown pages: `_pages/`
- Project records: `_data/projects.yml`
- Site configuration: `_config.yml`
- Posts: `_posts/`

GitHub Pages publishes the generated Jekyll site after Pages is configured for
this repository's publishing branch. The site uses GitHub Pages-compatible
plugins and needs no custom deployment logic or secrets.
