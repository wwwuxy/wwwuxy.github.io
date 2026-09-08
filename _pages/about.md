---
title: "Home"
layout: single
permalink: /
author_profile: true
---

## About Me

Personal homepage of wuxinyu — computer architecture, numerical computing, AI accelerators.

<!-- TODO: Replace with full biography -->

## Research Interests

- Computer architecture
- RISC-V
- AI accelerators
- Hardware / software co-design
- GPGPU architecture

## Selected Projects

{% for project in site.data.projects %}
{% if project.featured %}
{% include project-card.html project=project %}
{% endif %}
{% endfor %}

## Open Source

Open-source projects are available on [GitHub](https://github.com/wwwuxy).
