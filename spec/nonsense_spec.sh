Describe 'git-status-in-env.sh'
  Include ./git-status-in-env.sh

  Describe 'Nonsense'
  # These cases are likely errors but nonetheless if encountered should still produce predictable results

    It 'sets predictable vars for nonsense cases'
      # A copy or rename in format 1 are nonsensical
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 R. N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 renamed-in-index.txt
        #|1 RM N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 renamed-in-index-modified-in-worktree.txt
        #|1 RD N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 renamed-in-index-deleted-in-worktree.txt
        #|1 .R N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 renamed-in-worktree.txt
        #|1 DR N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 deleted-in-index-renamed-in-worktree.txt
        #|1 C. N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 copied-in-index.txt
        #|1 CM N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 copied-in-index-modified-in-worktree.txt
        #|1 CD N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 copied-in-index-deleted-in-worktree.txt
        #|1 .C N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 copied-in-worktree.txt
        #|1 DC N... 000000 000000 000000 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 deleted-in-index-copied-in-worktree.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '10'
      The variable X_CHANGED_INDEX should equal '8'
      The variable X_CHANGED_WORKTREE should equal '8'
      The variable X_ADDED should equal ''
      The variable X_ADDED_INDEX should equal ''
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal '4'
      The variable X_DELETED_INDEX should equal '2'
      The variable X_DELETED_WORKTREE should equal '2'
      The variable X_MODIFIED should equal '2'
      The variable X_MODIFIED_INDEX should equal ''
      The variable X_MODIFIED_WORKTREE should equal '2'
      The variable X_RENAMED should equal '5'
      The variable X_RENAMED_INDEX should equal '3'
      The variable X_RENAMED_WORKTREE should equal '2'
      The variable X_COPIED should equal '5'
      The variable X_COPIED_INDEX should equal '3'
      The variable X_COPIED_WORKTREE should equal '2'
      The variable X_CLEAN should equal ''
    End

  End

End
