#!/usr/bin/env bash
set -euo pipefail

if command -v bundle >/dev/null 2>&1; then
  bundler=(bundle)
elif command -v bundle2.7 >/dev/null 2>&1; then
  # The repository's Ruby 2.7 environment exposes Bundler under this name.
  bundler=(bundle2.7)
else
  printf 'Bundler is required; install it or make bundle available on PATH.\n' >&2
  exit 1
fi

bash scripts/check-content.sh
"${bundler[@]}" exec jekyll clean
"${bundler[@]}" exec jekyll build

for path in index.html research/index.html projects/index.html notes/index.html cv/index.html; do
  test -f "_site/$path"
done

for url in \
  https://github.com/wwwuxy \
  https://github.com/wwwuxy/QVU \
  https://github.com/wwwuxy/DFPVU \
  https://github.com/wwwuxy/PVU \
  https://github.com/wwwuxy/cvikernel \
  https://github.com/wwwuxy/cviruntime \
  https://github.com/wwwuxy/cnpy-for-tpu_mlir; do
  rg -q "$url" _site
done

test -f README.md
! rg -i -n 'Stuart Geiger|Robert Zupko|Michael Rose' _pages _data _config.yml README.md
