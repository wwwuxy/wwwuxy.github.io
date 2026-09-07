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
