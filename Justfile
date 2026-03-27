# --- Build targets ---
setup: obsidian-setup
build: obsidian-build
test: obsidian-test
lint: obsidian-lint

obsidian: obsidian-setup obsidian-lint obsidian-test obsidian-build obsidian-pack

clean:
	rm -rf out
	rm -rf node_modules

# --------------------------------------------------
# Obsidian plugin
# --------------------------------------------------

obsidian-setup:
  npm ci && npm audit --omit=dev

obsidian-build:
  npm run build

obsidian-test:
  npm run test

obsidian-lint:
  npm run lint:fix

obsidian-pack:
  #!/bin/sh
  set -eu

  VERSION=$(cat VERSION.txt)
  echo pack tabula.obsidian.${VERSION}.tar.gz

  mkdir -p dist
  tar -czf dist/tabula.obsidian.${VERSION}.tar.gz -C out .

github-lint:
  wrkflw validate

# --------------------------------------------------
# Version bump targets
# --------------------------------------------------
_update_version version:
  #!/usr/bin/env bash
  echo VERSION.txt
  echo -ne "{{version}}" > ./VERSION.txt

_update_json_version version json:
  #!/usr/bin/env bash
  echo {{json}}
  sed -e "s/^\([ \t]*\)\"version\":.*/\1\"version\": \"{{version}}\",/" {{json}} > tmp && mv tmp {{json}}

_commit_version version:
  git checkout -b release/v{{version}}
  git add "VERSION.txt" "package.json" "manifest.json"
  git commit -m "chore(release): bump version to {{version}}"
  echo "Committed version {{version}} on branch release/v{{version}}"

major:
  #!/usr/bin/env bash
  set -eu

  CUR_VERSION=`cat ./VERSION.txt`
  MAJOR=`echo $CUR_VERSION | cut -d. -f1`
  NEW_VERSION="$(($MAJOR + 1)).0.0"
  echo $CUR_VERSION "->" $NEW_VERSION

  just _update_json_version ${NEW_VERSION} "package.json"
  just _update_json_version ${NEW_VERSION} "manifest.json"
  just _update_version ${NEW_VERSION}
  just _commit_version ${NEW_VERSION}

minor:
  #!/usr/bin/env bash
  set -eu

  CUR_VERSION=`cat ./VERSION.txt`
  MAJOR=`echo $CUR_VERSION | cut -d. -f1`
  MINOR=`echo $CUR_VERSION | cut -d. -f2`
  NEW_VERSION="${MAJOR}.$(($MINOR + 1)).0"
  echo $CUR_VERSION "->" $NEW_VERSION

  just _update_json_version ${NEW_VERSION} "package.json"
  just _update_json_version ${NEW_VERSION} "manifest.json"
  just _update_version ${NEW_VERSION}
  just _commit_version ${NEW_VERSION}

patch:
  #!/usr/bin/env bash
  set -eu

  CUR_VERSION=`cat ./VERSION.txt`
  MAJOR=`echo $CUR_VERSION | cut -d. -f1`
  MINOR=`echo $CUR_VERSION | cut -d. -f2`
  PATCH=`echo $CUR_VERSION | cut -d. -f3`
  NEW_VERSION="${MAJOR}.${MINOR}.$(($PATCH + 1))"
  echo $CUR_VERSION "->" $NEW_VERSION

  just _update_json_version ${NEW_VERSION} "package.json"
  just _update_json_version ${NEW_VERSION} "manifest.json"
  just _update_version ${NEW_VERSION}
  just _commit_version ${NEW_VERSION}
