---
title: "Home"
layout: single
permalink: /
author_profile: true
---

<section class="lw-hero lw-hero--solo">
<div>
<p class="lw-eyebrow">Software Engineering · Computer Architecture · Numerical Computing</p>
<h1 class="lw-title">WUXINYU/吴欣宇</h1>
<p class="lw-subtitle">Master of Software Engineering from Southwest University of Science and Technology, focusing on computer architecture, GPGPU architecture, and hardware-software co-design of AI accelerators.</p>
<div class="lw-tags">
  <span class="lw-tag">Computer Architecture</span>
  <span class="lw-tag">Numerical Computing</span>
  <span class="lw-tag">AI Accelerators</span>
  <span class="lw-tag">Hardware/Software Co-design</span>
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
<div class="lw-card-grid">
<article class="lw-card">
<h3>Computer Architecture</h3>
<p>Processor microarchitecture design, GPGPU architecture, vector processing units, and domain-specific accelerators.</p>
</article>
<article class="lw-card">
<h3>Numerical Computing</h3>
<p>Posit arithmetic, IEEE-754 floating-point formats, mixed-precision computation, and hardware/software co-design for numerical accuracy.</p>
</article>
<article class="lw-card">
<h3>AI Accelerator</h3>
<p>TPU-style accelerator software stacks, Tensor Core design, quantization units, and low-precision inference hardware.</p>
</article>
<article class="lw-card">
<h3>Vector Processing</h3>
<p>Configurable vector units supporting FP4/FP8/FP16/FP32/FP64 and Posit formats with dot-product and quantization capabilities.</p>
</article>
</div>
</section>

<section class="lw-section">
<h2 class="lw-section-title">Technical Work</h2>
<div class="lw-card-grid">
<article class="lw-card">
  <h3>Vector Processing &amp; Mixed Precision</h3>
  <p>Parameterizable vector processing and quantization units supporting Posit and IEEE-754 formats, precision conversion, vector arithmetic, and dot products.</p>
</article>
<article class="lw-card">
  <h3>Processor Simulation</h3>
  <p>Processor simulation, instruction-set experimentation, and hardware/software co-design work for RISC-V-oriented systems.</p>
</article>
<article class="lw-card">
  <h3>Accelerator Software</h3>
  <p>Low-level kernel, runtime, verification, and profiling infrastructure for accelerator software stacks.</p>
</article>
</div>
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
