---
title: "Projects"
layout: single
permalink: /projects/
author_profile: true
---

{% assign project_categories = "Processor & Numerical Architecture|AI Accelerator Software Stack|Other Open Source" | split: "|" %}
{% for category in project_categories %}
## {{ category }}

{% for project in site.data.projects %}
{% if project.category == category %}
{% if project.description %}
{% include project-card.html project=project %}
{% else %}
<p><a href="{{ project.url }}" target="_blank" rel="noopener noreferrer">{{ project.name }}</a></p>
{% endif %}
{% endif %}
{% endfor %}
{% endfor %}
