---
title: "Home"
layout: single
permalink: /
author_profile: true
---

## About Me

Personal homepage of wwwuxy — computer architecture, numerical computing, vector processing and AI accelerators.

<!-- TODO: Replace with full biography -->

## Research Interests

- Computer architecture
- Numerical computing
- AI accelerators
- Hardware / software co-design

## Selected Projects

{% for project in site.data.projects %}
{% if project.featured %}
{% include project-card.html project=project %}
{% endif %}
{% endfor %}

## Open Source

Open-source projects are available on [GitHub](https://github.com/wwwuxy).
