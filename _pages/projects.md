---
title: "Projects"
layout: single
permalink: /projects/
author_profile: true
---

<section class="lw-section" aria-label="开源项目">
{% assign project_categories = "Processor & Numerical Architecture|AI Accelerator Software Stack|Other Open Source" | split: "|" %}
{% for category in project_categories %}
{% for project in site.data.projects %}
{% if project.category == category %}
{% include project-card.html project=project %}
{% endif %}
{% endfor %}
{% endfor %}
</section>
