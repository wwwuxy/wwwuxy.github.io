---
title: "Projects"
layout: single
permalink: /projects/
author_profile: true
---

<header class="lw-page-header">
<p class="lw-eyebrow">Open Source · Reproducible Systems · GPU Research</p>
<h1 class="lw-title">Open Source Projects</h1>
<p class="lw-subtitle">Selected repositories related to computer architecture, numerical computing, vector processing, and AI accelerators.</p>
</header>

<section class="lw-section">
<div class="lw-card-grid">
{% assign project_categories = "Processor & Numerical Architecture|AI Accelerator Software Stack|Other Open Source" | split: "|" %}
{% for category in project_categories %}
{% for project in site.data.projects %}
{% if project.category == category %}
<article class="lw-card lw-project-card">
  <h3><a href="{{ project.url }}">{{ project.name }}</a></h3>
  {% if project.description %}<p>{{ project.description }}</p>{% endif %}
  <a class="lw-mini-link" href="{{ project.url }}">GitHub →</a>
</article>
{% endif %}
{% endfor %}
{% endfor %}
</div>
</section>
