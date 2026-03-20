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
const entries = [];

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

  entries.push({ name, source });
}

entries
  .sort((a, b) => a.source.localeCompare(b.source) || a.name.localeCompare(b.name))
  .forEach(({ name, source }) => {
    process.stdout.write(`${source}\t${name}\n`);
  });
NODE
)

if [[ ${#entries[@]} -eq 0 ]]; then
  echo "No tracked project skills from skills-lock.json are installed locally." >&2
  exit 0
fi

run_group() {
  local source="$1"
  shift
  local skills=("$@")
  local skill_name=""

  if [[ ${#skills[@]} -eq 0 ]]; then
    return
  fi

  if [[ $dry_run -eq 1 ]]; then
    printf 'npx skills add %q --skill' "$source"
    for skill_name in "${skills[@]}"; do
      printf ' %q' "$skill_name"
    done
    printf ' -y\n'
    return
  fi

  echo "Reinstalling ${skills[*]} from $source" >&2
  npx skills add "$source" --skill "${skills[@]}" -y
}

current_source=""
current_skills=()

for entry in "${entries[@]}"; do
  IFS=$'\t' read -r source skill <<< "$entry"

  if [[ -z "$current_source" ]]; then
    current_source="$source"
    current_skills=("$skill")
    continue
  fi

  if [[ "$source" == "$current_source" ]]; then
    current_skills+=("$skill")
    continue
  fi

  run_group "$current_source" "${current_skills[@]}"
  current_source="$source"
  current_skills=("$skill")
done

run_group "$current_source" "${current_skills[@]}"
