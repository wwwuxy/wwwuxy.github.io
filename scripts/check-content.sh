#!/usr/bin/env bash
set -euo pipefail

for route in / /research/ /projects/ /notes/ /cv/; do
  test -n "$route"
done

test -f _data/navigation.yml
test -f _data/projects.yml
test -f _includes/project-card.html

rg -q 'DFPVU' _data/projects.yml
rg -q 'https://github.com/wwwuxy/DFPVU' _data/projects.yml
rg -q 'project-card' _includes/project-card.html

for page in _pages/about.md _pages/research.md _pages/projects.md _pages/notes.md _pages/cv.md; do
  test -f "$page"
done
