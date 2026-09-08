---
title: "CV"
layout: single
permalink: /cv/
author_profile: true
---

## Research Interests

- Computer architecture
- Numerical computing
- Mixed-precision computing
- Vector processing
- AI accelerator architecture
- Hardware / software co-design

## Open Source Projects

{% for project in site.data.projects %}
- [{{ project.name }}]({{ project.url }})
{% endfor %}

## Technical Skills

- Chisel and SystemVerilog
- Verilator
- C++
- Posit and IEEE-754 floating-point formats
- FP4, FP8, FP16, FP32, FP64, INT4, and INT8
- TPU and MLIR
- NumPy `.npy` and `.npz`

<!-- Education: add verified information when available. -->
<!-- Experience: add verified information when available. -->
<!-- Publications: add verified information when available. -->
