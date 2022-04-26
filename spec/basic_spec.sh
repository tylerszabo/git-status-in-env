Describe 'git-status-in-env.sh'
  Include ./git-status-in-env.sh

  Describe 'Basic functionality'
    git() { return 0; }

    It 'outputs nothing'
      When call set_git_status_vars
      The output should equal ''
      The error should equal ''
      The status should be success
    End

    It 'should define all output variables on success'
      When call set_git_status_vars PREFIX
      The variable PREFIX_IS_REPO should be defined

      The variable PREFIX_COMMIT should be defined
      The variable PREFIX_BRANCH should be defined
      The variable PREFIX_UPSTREAM should be defined
      The variable PREFIX_AHEAD should be defined
      The variable PREFIX_BEHIND should be defined
      The variable PREFIX_GONE should be defined

      The variable PREFIX_EQUAL should be defined

      The variable PREFIX_UNTRACKED should be defined
      The variable PREFIX_CHANGED should be defined
      The variable PREFIX_CHANGED_WORKTREE should be defined
      The variable PREFIX_CHANGED_INDEX should be defined
      The variable PREFIX_ADDED should be defined
      The variable PREFIX_ADDED_WORKTREE should be defined
      The variable PREFIX_ADDED_INDEX should be defined
      The variable PREFIX_DELETED should be defined
      The variable PREFIX_DELETED_WORKTREE should be defined
      The variable PREFIX_DELETED_INDEX should be defined
      The variable PREFIX_MODIFIED should be defined
      The variable PREFIX_MODIFIED_WORKTREE should be defined
      The variable PREFIX_MODIFIED_INDEX should be defined

      The variable PREFIX_RENAMED should be defined
      The variable PREFIX_RENAMED_WORKTREE should be defined
      The variable PREFIX_RENAMED_INDEX should be defined
      The variable PREFIX_COPIED should be defined
      The variable PREFIX_COPIED_WORKTREE should be defined
      The variable PREFIX_COPIED_INDEX should be defined

      The variable PREFIX_MERGED should be defined
      The variable PREFIX_MERGE_ADDED_US should be defined
      The variable PREFIX_MERGE_ADDED_THEM should be defined
      The variable PREFIX_MERGE_DELETED_US should be defined
      The variable PREFIX_MERGE_DELETED_THEM should be defined
      The variable PREFIX_MERGE_MODIFIED_US should be defined
      The variable PREFIX_MERGE_MODIFIED_THEM should be defined

      The variable PREFIX_CLEAN should be defined

      The variable PREFIX_STASH should be defined
    End
  End

  Describe 'Set variables with prefixes'
    git() { return 0; }
    Parameters
      ''          PROMPT_GIT_IS_REPO
      AA          AA_IS_REPO
      BB          BB_IS_REPO
      PROMPT_GIT  PROMPT_GIT_IS_REPO
      GIT_PROMPT  GIT_PROMPT_IS_REPO
      _GIT        _GIT_IS_REPO
    End
    It 'using prefix $1'
      When call set_git_status_vars $1
      The variable $2 should be defined
    End
  End

  Describe 'Sets IS_REPO variable'
    It 'when current directory is a repo'
      git() { return 0; }
      When call set_git_status_vars X
      The variable X_IS_REPO should equal '1'
      The status should be success
    End
    It 'when current directory is not a repo'
      git() { return 128; }
      When call set_git_status_vars X
      The variable X_IS_REPO should equal ''
      The status should be success
    End
    It 'when git status returns an error'
      git() { return 1; }
      When call set_git_status_vars X
      The variable X_IS_REPO should be undefined
      The status should be failure
    End
  End

End
