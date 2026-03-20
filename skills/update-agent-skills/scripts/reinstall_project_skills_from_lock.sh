#!/usr/bin/env bash

set -euo pipefail

project_root="."
dry_run=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --project-root)
      if [[ $# -lt 2 ]]; then
        echo "--project-root requires a path" >&2
        exit 1
      fi
      project_root="$2"
      shift 2
      ;;
    --dry-run)
      dry_run=1
      shift
      ;;
    *)
      echo "Usage: $0 [--project-root PATH] [--dry-run]" >&2
      exit 1
      ;;
  esac
done

project_root="$(cd "$project_root" && pwd)"
lockfile="$project_root/skills-lock.json"

if [[ ! -f "$lockfile" ]]; then
  echo "skills-lock.json not found in $project_root" >&2
  exit 1
fi

skill_dirs=()
for dir in ".agents/skills" ".claude/skills" ".augment/skills"; do
  if [[ -d "$project_root/$dir" ]]; then
    skill_dirs+=("$project_root/$dir")
  fi
done

if [[ ${#skill_dirs[@]} -eq 0 ]]; then
  echo "No project skill directories found in $project_root" >&2
  exit 1
fi

mapfile -t entries < <(
  node - "$lockfile" "${skill_dirs[@]}" <<'NODE'
const fs = require('fs');
const path = require('path');

const [lockfile, ...skillDirs] = process.argv.slice(2);
const lock = JSON.parse(fs.readFileSync(lockfile, 'utf8'));
const skills = lock.skills && typeof lock.skills === 'object' ? lock.skills : {};

for (const [name, meta] of Object.entries(skills)) {
  const installed = skillDirs.some((dir) =>
    fs.existsSync(path.join(dir, name, 'SKILL.md'))
  );

  if (!installed) {
    continue;
  }

  let source = meta.source || '';

  if (
    meta.sourceType === 'github' &&
    source &&
    !source.startsWith('http://') &&
    !source.startsWith('https://')
  ) {
    source = `https://github.com/${source}`;
  }

  if (!source) {
    continue;
  }

  process.stdout.write(`${name}\t${source}\n`);
}
NODE
)

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "No tracked project skills from skills-lock.json are installed locally." >&2
  exit 0
fi

for entry in "${entries[@]}"; do
  IFS=$'\t' read -r skill source <<< "$entry"

  if [[ $dry_run -eq 1 ]]; then
    printf 'npx skills add %q --skill %q\n' "$source" "$skill"
    continue
  fi

  echo "Reinstalling $skill from $source" >&2
  npx skills add "$source" --skill "$skill"
done
