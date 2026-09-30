---
title: "Home"
layout: single
permalink: /
author_profile: true
---

<section class="lw-hero lw-hero--solo">
<div>
<p class="lw-eyebrow">Computer Architecture · GPGPU · Numerical Computing</p>
<h1 class="lw-title"><span class="lw-title__en">WUXINYU</span> <span class="lw-title__cn" lang="zh-CN">吴欣宇</span></h1>
<p class="lw-subtitle">Master of Software Engineering from Southwest University of Science and Technology. My work focuses on GPGPU architecture modeling, RISC-V vector processing, Posit and IEEE 754 arithmetic, and low-precision quantization.</p>
<div class="lw-tags">
  <span class="lw-tag">GPGPU Architecture</span>
  <span class="lw-tag">RISC-V Vector Processing</span>
  <span class="lw-tag">Posit &amp; IEEE 754</span>
  <span class="lw-tag">Low-Precision Quantization</span>
</div>
<div class="lw-actions">
  <a class="lw-button" href="/projects/">Open Source</a>
  <a class="lw-button lw-button--ghost" href="/research/">Research</a>
  <a class="lw-button lw-button--ghost" href="https://github.com/wwwuxy">GitHub</a>
</div>
</div>
</section>

<section class="lw-section">
<h2 class="lw-section-title">Research Focus</h2>
<div class="lw-card-grid lw-focus-grid">
<article class="lw-card">
<h3>Vector Processing</h3>
<p>RISC-V vector units for arithmetic, dot products, and dual-format floating-point execution.</p>
</article>
<article class="lw-card">
<h3>Numerical Formats &amp; Quantization</h3>
<p>Posit and IEEE 754 computation, precision conversion, and FP4, FP8, FP16, INT4, and INT8 quantization.</p>
</article>
<article class="lw-card">
<h3>GPGPU Architecture</h3>
<p>GPGPU architecture modeling, with a focus on parallel execution, compute organization, and memory behavior.</p>
</article>
</div>
</section>

<section class="lw-section" aria-labelledby="home-research-papers-title">
<h2 class="lw-section-title" id="home-research-papers-title">Selected Papers</h2>
{% include research-papers.html %}
</section>

<section class="lw-section">
<h2 class="lw-section-title">Open Source</h2>
<div class="lw-card-grid">
{% for project in site.data.projects %}
{% if project.featured %}
<article class="lw-card lw-project-card">
  <h3><a href="{{ project.url }}">{{ project.name }}</a></h3>
  <p>{{ project.description }}</p>
  <a class="lw-mini-link" href="{{ project.url }}">GitHub →</a>
</article>
{% endif %}
{% endfor %}
</div>
</section>
