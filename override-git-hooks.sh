#!/usr/bin/env bash

declare -i HookFolderNotFoundStatus=1

HookFolderNotFoundMessage="Hook folder not found."

HookFolder=".git/hooks/"
HookSuffix=".sample"

function makeRunnable()
{
  local target="$1"
  (
    cd "$HookFolder"
    [[ -f "$target" ]] && mv -T "$target" "${target%$HookSuffix}"
  )
}

function preCommitOverride()
{
  local target="${HookFolder}pre-commit$HookSuffix"
cat <<-"EOF" > "$target"
#!/usr/bin/env bash
set -e

if git rev-parse --verify HEAD >/dev/null 2>&1
then
  against=HEAD
else
  against="$(git hash-object -t tree /dev/null)"
fi

program="main.sh"
./shellcheck "$program"

declare -r DuplicatingCommentsStatus=1

comments="$(grep -E '^[[:space:]]*#.*' "$program" | sort | uniq -d)"
[[ -n "$comments" ]] && {
  echo "There are duplicating comments. Please remove them or make uniq them."
  echo "$comments"
  exit "$DuplicatingCommentsStatus"
}
EOF
}

[[ ! -d "$HookFolder" ]] && {
  echo "$HookFolderNotFoundMessage"
  exit "$HookFolderNotFoundStatus"
}

preCommitOverride
makeRunnable "pre-commit.sample"
