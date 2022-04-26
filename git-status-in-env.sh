#!/bin/bash

## MIT License
##
## Copyright (c) 2022 Tyler Szabo
##
## Permission is hereby granted, free of charge, to any person obtaining a copy
## of this software and associated documentation files (the "Software"), to deal
## in the Software without restriction, including without limitation the rights
## to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
## copies of the Software, and to permit persons to whom the Software is
## furnished to do so, subject to the following conditions:
##
## The above copyright notice and this permission notice shall be included in all
## copies or substantial portions of the Software.
##
## THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
## IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
## FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
## AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
## LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
## OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
## SOFTWARE.


set_git_status_vars() {
  if [[ -n "$ZSH_VERSION" ]]; then
    setopt local_options BASH_REMATCH
    setopt local_options KSH_ARRAYS
  fi

  local var_prefix="${1:-PROMPT_GIT}"

  local git_status
  local exit_code
  git_status=$(git --no-optional-locks status --porcelain=v2 --branch --show-stash 2>/dev/null)
  exit_code=$?

  if [[ "$exit_code" -eq 0 ]]; then
    declare -g "${var_prefix}_IS_REPO=1"
  elif [[ "$exit_code" -eq 128 ]]; then
    declare -g "${var_prefix}_IS_REPO="
    return 0
  else
    return $exit_code
  fi

  local commit
  local branch
  local upstream
  local gone
  local ahead
  local behind
  local equal

  local untracked

  local changed
  local changed_worktree
  local changed_index
  local changed_either

  local added
  local added_worktree
  local added_index
  local added_either

  local deleted
  local deleted_worktree
  local deleted_index
  local deleted_either

  local modified
  local modified_worktree
  local modified_index
  local modified_either

  local renamed
  local renamed_worktree
  local renamed_index
  local renamed_either

  local copied
  local copied_worktree
  local copied_index
  local copied_either

  local merged
  local added_us
  local added_them
  local deleted_us
  local deleted_them
  local modified_us
  local modified_them

  local clean
  local stash

  local -r regex_commit='^#\ branch\.oid\ (.*)$'
  local -r regex_branch='^#\ branch\.head\ (.*)$'
  local -r regex_upstream='^#\ branch\.upstream\ (.*)$'
  local -r regex_ab='^#\ branch\.ab\ \+([0-9]*)\ -([0-9]*)$'
  local -r regex_stash='^#\ stash\ ([0-9]+)$'
  local -r regex_ordinary='^1\ (.)(.)'
  local -r regex_rename='^2\ (.)(.)'
  local -r regex_merge='^u\ (.)(.)'
  local -r regex_untracked='^\?'

  local line
  while IFS= read -r line ; do
    changed_either=0
    added_either=0
    deleted_either=0
    modified_either=0
    renamed_either=0
    copied_either=0

    if [[ "$line" =~ $regex_commit ]]; then
      commit=${BASH_REMATCH[1]}
    elif [[ "$line" =~ $regex_branch ]]; then
      branch=${BASH_REMATCH[1]}
    elif [[ "$line" =~ $regex_upstream ]]; then
      upstream=${BASH_REMATCH[1]}
    elif [[ "$line" =~ $regex_ab ]]; then
      ahead=${BASH_REMATCH[1]}
      behind=${BASH_REMATCH[2]}
    elif [[ "$line" =~ $regex_stash ]]; then
      stash=${BASH_REMATCH[1]}
    elif [[ "$line" =~ $regex_ordinary ]]; then
      [[ ${BASH_REMATCH[1]} != '.' ]] && changed_index=$((changed_index+1)) && changed_either=1
      [[ ${BASH_REMATCH[2]} != '.' ]] && changed_worktree=$((changed_worktree+1)) && changed_either=1
      case ${BASH_REMATCH[1]} in
        'A') added_index=$((added_index+1)) && added_either=1 ;;
        'D') deleted_index=$((deleted_index+1)) && deleted_either=1 ;;
        'M'|'T'|'U') modified_index=$((modified_index+1)) && modified_either=1 ;;
        'R') renamed_index=$((renamed_index+1)) && renamed_either=1 ;;
        'C') copied_index=$((copied_index+1)) && copied_either=1 ;;
      esac
      case ${BASH_REMATCH[2]} in
        'A') added_worktree=$((added_worktree+1)) && added_either=1 ;;
        'D') deleted_worktree=$((deleted_worktree+1)) && deleted_either=1 ;;
        'M'|'T'|'U') modified_worktree=$((modified_worktree+1)) && modified_either=1 ;;
        'R') renamed_worktree=$((renamed_worktree+1)) && renamed_either=1 ;;
        'C') copied_worktree=$((copied_worktree+1)) && copied_either=1 ;;
      esac
    elif [[ "$line" =~ $regex_rename ]]; then
      [[ ${BASH_REMATCH[1]} != '.' ]] && changed_index=$((changed_index+1)) && changed_either=1
      [[ ${BASH_REMATCH[2]} != '.' ]] && changed_worktree=$((changed_worktree+1)) && changed_either=1
      case ${BASH_REMATCH[1]} in
        'A') added_index=$((added_index+1)) && added_either=1 ;;
        'D') deleted_index=$((deleted_index+1)) && deleted_either=1 ;;
        'M'|'T'|'U') modified_index=$((modified_index+1)) && modified_either=1 ;;
        'R') renamed_index=$((renamed_index+1)) && renamed_either=1 ;;
        'C') copied_index=$((copied_index+1)) && copied_either=1 ;;
      esac
      case ${BASH_REMATCH[2]} in
        'A') added_worktree=$((added_worktree+1)) && added_either=1 ;;
        'D') deleted_worktree=$((deleted_worktree+1)) && deleted_either=1 ;;
        'M'|'T'|'U') modified_worktree=$((modified_worktree+1)) && modified_either=1 ;;
        'R') renamed_worktree=$((renamed_worktree+1)) && renamed_either=1 ;;
        'C') copied_worktree=$((copied_worktree+1)) && copied_either=1 ;;
      esac
    elif [[ "$line" =~ $regex_merge ]]; then
      [[ ${BASH_REMATCH[1]} != '.' ]] && changed_us=$((changed_us+1)) && changed_either=1
      [[ ${BASH_REMATCH[2]} != '.' ]] && changed_them=$((changed_them+1)) && changed_either=1
      case ${BASH_REMATCH[1]} in
        'A') added_us=$((added_us+1)) && added_either=1 ;;
        'D') deleted_us=$((deleted_us+1)) && deleted_either=1 ;;
        'U') modified_us=$((modified_us+1)) && modified_either=1 ;;
      esac
      case ${BASH_REMATCH[2]} in
        'A') added_them=$((added_them+1)) && added_either=1 ;;
        'D') deleted_them=$((deleted_them+1)) && deleted_either=1 ;;
        'U') modified_them=$((modified_them+1)) && modified_either=1 ;;
      esac
      [[ "$added_either" -gt 0 ]] && added_index=$((added_index+1))
      [[ "$deleted_either" -gt 0 ]] && deleted_index=$((deleted_index+1))
      [[ "$modified_either" -gt 0 ]] && modified_index=$((modified_index+1))
      [[ "$changed_either" -gt 0 ]] && changed_index=$((changed_index+1))
      [[ "$changed_either" -gt 0 ]] && merged=$((merged+1))
    elif [[ "$line" =~ $regex_untracked ]]; then
      untracked=$((untracked+1))
    fi

    [[ "$changed_either" -gt 0 ]] && changed=$((changed+1))
    [[ "$added_either" -gt 0 ]] && added=$((added+1))
    [[ "$deleted_either" -gt 0 ]] && deleted=$((deleted+1))
    [[ "$modified_either" -gt 0 ]] && modified=$((modified+1))
    [[ "$renamed_either" -gt 0 ]] && renamed=$((renamed+1))
    [[ "$copied_either" -gt 0 ]] && copied=$((copied+1))
  done <<< $git_status

  [[ "$ahead" -eq 0 ]] && ahead=
  [[ "$behind" -eq 0 ]] && behind=

  [[ -n "$upstream" ]] && ! git --no-optional-locks rev-parse --verify --end-of-options "${upstream}^{commit}" &>/dev/null && gone=1

  [[ -n "$upstream" && "$ahead" -eq 0 && "$behind" -eq 0 && "$gone" -eq 0 ]] && equal=1

  [[ "$untracked" -eq 0 && "$changed" -eq 0 ]] && clean=1

  declare -g "${var_prefix}_COMMIT=$commit"
  declare -g "${var_prefix}_BRANCH=$branch"
  declare -g "${var_prefix}_UPSTREAM=$upstream"
  declare -g "${var_prefix}_AHEAD=$ahead"
  declare -g "${var_prefix}_BEHIND=$behind"
  declare -g "${var_prefix}_GONE=$gone"

  declare -g "${var_prefix}_EQUAL=$equal"

  declare -g "${var_prefix}_UNTRACKED=$untracked"
  declare -g "${var_prefix}_CHANGED=$changed"
  declare -g "${var_prefix}_CHANGED_WORKTREE=$changed_worktree"
  declare -g "${var_prefix}_CHANGED_INDEX=$changed_index"
  declare -g "${var_prefix}_ADDED=$added"
  declare -g "${var_prefix}_ADDED_WORKTREE=$added_worktree"
  declare -g "${var_prefix}_ADDED_INDEX=$added_index"
  declare -g "${var_prefix}_DELETED=$deleted"
  declare -g "${var_prefix}_DELETED_WORKTREE=$deleted_worktree"
  declare -g "${var_prefix}_DELETED_INDEX=$deleted_index"
  declare -g "${var_prefix}_MODIFIED=$modified"
  declare -g "${var_prefix}_MODIFIED_WORKTREE=$modified_worktree"
  declare -g "${var_prefix}_MODIFIED_INDEX=$modified_index"

  declare -g "${var_prefix}_RENAMED=$renamed"
  declare -g "${var_prefix}_RENAMED_WORKTREE=$renamed_worktree"
  declare -g "${var_prefix}_RENAMED_INDEX=$renamed_index"
  declare -g "${var_prefix}_COPIED=$copied"
  declare -g "${var_prefix}_COPIED_WORKTREE=$copied_worktree"
  declare -g "${var_prefix}_COPIED_INDEX=$copied_index"

  declare -g "${var_prefix}_MERGED=$merged"
  declare -g "${var_prefix}_MERGE_ADDED_US=$added_us"
  declare -g "${var_prefix}_MERGE_ADDED_THEM=$added_them"
  declare -g "${var_prefix}_MERGE_DELETED_US=$deleted_us"
  declare -g "${var_prefix}_MERGE_DELETED_THEM=$deleted_them"
  declare -g "${var_prefix}_MERGE_MODIFIED_US=$modified_us"
  declare -g "${var_prefix}_MERGE_MODIFIED_THEM=$modified_them"

  declare -g "${var_prefix}_CLEAN=$clean"

  declare -g "${var_prefix}_STASH=$stash"

  return 0
}
