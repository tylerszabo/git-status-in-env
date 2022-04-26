Describe 'git-status-in-env.sh'
  Include ./git-status-in-env.sh

  Describe 'Set changes info'
    It 'sets vars for files changed in worktree'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 .M N... 100644 100644 100644 b70949b8306669496407a4d986c8c23eb353ea01 b70949b8306669496407a4d986c8c23eb353ea01 git-status-in-env.sh
        #|1 .M N... 100644 100644 100644 ea878840483cd37ae84d01526001c9b7f5efd61e ea878840483cd37ae84d01526001c9b7f5efd61e spec/basic_spec.sh
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '2'
      The variable X_CHANGED_INDEX should equal ''
      The variable X_CHANGED_WORKTREE should equal '2'
      The variable X_MODIFIED should equal '2'
      The variable X_MODIFIED_INDEX should equal ''
      The variable X_MODIFIED_WORKTREE should equal '2'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for files changed in index'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 M. N... 100644 100644 100644 b70949b8306669496407a4d986c8c23eb353ea01 952a696a933bf3a5a6f42b65570af7984acafac5 git-status-in-env.sh
        #|1 M. N... 100644 100644 100644 ea878840483cd37ae84d01526001c9b7f5efd61e 394d07f995d2db0dceb70f442c5282282733f44f spec/basic_spec.sh
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '2'
      The variable X_CHANGED_INDEX should equal '2'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '2'
      The variable X_MODIFIED_INDEX should equal '2'
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for files changed in both worktree and index'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 MM N... 100644 100644 100644 b70949b8306669496407a4d986c8c23eb353ea01 f5563da0a867d2ae0b2ef6b879bc6efb2e2fdcee git-status-in-env.sh
        #|1 MM N... 100644 100644 100644 ea878840483cd37ae84d01526001c9b7f5efd61e 0ba9763380555106463c918e41f7521093fc4d7d spec/basic_spec.sh
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '2'
      The variable X_CHANGED_INDEX should equal '2'
      The variable X_CHANGED_WORKTREE should equal '2'
      The variable X_MODIFIED should equal '2'
      The variable X_MODIFIED_INDEX should equal '2'
      The variable X_MODIFIED_WORKTREE should equal '2'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for untracked files'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|? temp/
        #|? spec/temp2/
        #|? new.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal '3'
      The variable X_CHANGED should equal ''
      The variable X_CHANGED_INDEX should equal ''
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for added files'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 A. N... 000000 100644 100644 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added.txt
        #|1 A. N... 000000 100644 100644 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added2.txt
        #|1 A. N... 000000 100644 100644 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added3.txt
        #|1 .A N... 000000 000000 100644 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 intent-to-add.txt
        #|1 .A N... 000000 000000 100644 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 intent-to-add2.txt
        #|? untracked.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal '1'
      The variable X_CHANGED should equal '5'
      The variable X_CHANGED_INDEX should equal '3'
      The variable X_CHANGED_WORKTREE should equal '2'
      The variable X_ADDED should equal '5'
      The variable X_ADDED_INDEX should equal '3'
      The variable X_ADDED_WORKTREE should equal '2'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for deleted files'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 D. N... 100644 000000 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 0000000000000000000000000000000000000000 deleted.txt
        #|1 D. N... 100644 000000 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 0000000000000000000000000000000000000000 deleted-index.txt
        #|1 .D N... 100644 100644 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 deleted-worktree.txt
        #|? deleted-index.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal '1'
      The variable X_CHANGED should equal '3'
      The variable X_CHANGED_INDEX should equal '2'
      The variable X_CHANGED_WORKTREE should equal '1'
      The variable X_DELETED should equal '3'
      The variable X_DELETED_INDEX should equal '2'
      The variable X_DELETED_WORKTREE should equal '1'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for a mix of staged, unstaged, and untracked files'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|1 MD N... 100644 100755 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 empty.sh
        #|1 AD N... 000000 100644 000000 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added-deleted.txt
        #|1 AM N... 000000 100644 100644 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added-modified.txt
        #|1 A. N... 000000 100644 100644 0000000000000000000000000000000000000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 added.txt
        #|1 MM N... 100644 100644 100644 b70949b8306669496407a4d986c8c23eb353ea01 f5563da0a867d2ae0b2ef6b879bc6efb2e2fdcee git-status-in-env.sh
        #|1 .M N... 100644 100644 100644 ea878840483cd37ae84d01526001c9b7f5efd61e ea878840483cd37ae84d01526001c9b7f5efd61e spec/basic_spec.sh
        #|1 D. N... 100644 000000 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 0000000000000000000000000000000000000000 deleted.txt
        #|1 .D N... 100644 100644 000000 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 deleted-worktree.txt
        #|? new.txt
        #|! ignored.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal '1'
      The variable X_CHANGED should equal '8'
      The variable X_CHANGED_INDEX should equal '6'
      The variable X_CHANGED_WORKTREE should equal '6'
      The variable X_ADDED should equal '3'
      The variable X_ADDED_INDEX should equal '3'
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal '4'
      The variable X_DELETED_INDEX should equal '1'
      The variable X_DELETED_WORKTREE should equal '3'
      The variable X_MODIFIED should equal '4'
      The variable X_MODIFIED_INDEX should equal '2'
      The variable X_MODIFIED_WORKTREE should equal '3'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for copied and renamed files'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # mv file1.txt file1-new.txt
        # mv file2.txt file2-new.txt
        # cp fileX.txt fileA.txt
        # cp file1-new.txt fileX.txt
        # git rm file1.txt
        # git add file1-new.txt
        # git add -N file2-new.txt fileX.txt fileA.txt
        %text
        #|2 R. N... 100644 100644 100644 d00491fd7e5bb6fa28c517a0bb32b8b506539d4d d00491fd7e5bb6fa28c517a0bb32b8b506539d4d R100 file1-new.txt	file1.txt
        #|2 .R N... 100644 100644 100644 0cfbf08886fca9a91cb753ec8734c84fcbe52c9f 0cfbf08886fca9a91cb753ec8734c84fcbe52c9f R100 file2-new.txt	file2.txt
        #|2 .C N... 100644 100644 100644 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 C100 fileA.txt	fileX.txt
        #|1 .M N... 100644 100644 100644 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 e69de29bb2d1d6434b8b29ae775ad8c2e48c5391 fileX.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '4'
      The variable X_CHANGED_INDEX should equal '1'
      The variable X_CHANGED_WORKTREE should equal '3'
      The variable X_ADDED should equal ''
      The variable X_ADDED_INDEX should equal ''
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal ''
      The variable X_DELETED_INDEX should equal ''
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '1'
      The variable X_MODIFIED_INDEX should equal ''
      The variable X_MODIFIED_WORKTREE should equal '1'
      The variable X_RENAMED should equal '2'
      The variable X_RENAMED_INDEX should equal '1'
      The variable X_RENAMED_WORKTREE should equal '1'
      The variable X_COPIED should equal '1'
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal '1'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for a clean repo'
      git() {
        [[ "$2" == 'status' ]] || return 1
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal ''
      The variable X_CHANGED_INDEX should equal ''
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_CLEAN should equal '1'
    End

  End

End
