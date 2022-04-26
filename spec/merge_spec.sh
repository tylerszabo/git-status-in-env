Describe 'git-status-in-env.sh'
  Include ./git-status-in-env.sh

  Describe 'Set changes info for merges'

    It 'sets vars for added/deleted in merge'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # git init --initial-branch="initial"
        # git commit --message "Initial commit" --allow-empty
        # git branch main
        # git checkout main

        # echo "text1" > file_a.txt
        # git add file_a.txt
        # git commit --message "Add file_a.txt"

        # echo "text2" > file_b.txt
        # git add file_b.txt
        # git commit --message "Add file_b.txt"

        # echo "text3" > file_c.txt
        # git add file_c.txt
        # git commit --message "Add file_c.txt"

        # git branch alt
        # git checkout alt
        # git mv file_b.txt file_x.txt
        # git commit --message "Rename file_b.txt to file_x.txt"

        # git rm file_a.txt
        # git commit --message "Remove file_a.txt"

        # git checkout main
        # git mv file_b.txt file_d.txt
        # git commit --message "Rename file_b.txt to file_d.txt"

        # git mv file_a.txt file_e.txt
        # git commit --message "Rename file_a.txt to file_e.txt"

        # git merge --no-commit alt
        %text
        #|u DD N... 100644 000000 000000 000000 f483c776c42f8ef2aa00d827805dfeaf7d9ce02b 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 file_b.txt
        #|u AU N... 000000 100644 000000 100644 0000000000000000000000000000000000000000 f483c776c42f8ef2aa00d827805dfeaf7d9ce02b 0000000000000000000000000000000000000000 file_d.txt
        #|u UD N... 100644 100644 000000 100644 ad1a4f341d4f1cd0f5ad1da45e17e1ee03d1bac4 ad1a4f341d4f1cd0f5ad1da45e17e1ee03d1bac4 0000000000000000000000000000000000000000 file_e.txt
        #|u UA N... 000000 000000 100644 100644 0000000000000000000000000000000000000000 0000000000000000000000000000000000000000 f483c776c42f8ef2aa00d827805dfeaf7d9ce02b file_x.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '4'
      The variable X_CHANGED_INDEX should equal '4'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_ADDED should equal '2'
      The variable X_ADDED_INDEX should equal '2'
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal '2'
      The variable X_DELETED_INDEX should equal '2'
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '3'
      The variable X_MODIFIED_INDEX should equal '3'
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_RENAMED should equal ''
      The variable X_RENAMED_INDEX should equal ''
      The variable X_RENAMED_WORKTREE should equal ''
      The variable X_COPIED should equal ''
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal ''
      The variable X_MERGED should equal '4'
      The variable X_MERGE_ADDED_THEM should equal '1'
      The variable X_MERGE_ADDED_US should equal '1'
      The variable X_MERGE_DELETED_THEM should equal '2'
      The variable X_MERGE_DELETED_US should equal '1'
      The variable X_MERGE_MODIFIED_THEM should equal '1'
      The variable X_MERGE_MODIFIED_US should equal '2'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for conflicting adds in merge'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # git init --initial-branch="initial"
        # git commit --message "Initial commit" --allow-empty
        # git branch main
        # git checkout main

        # git branch alt

        # echo "text3" > file_c.txt
        # git add file_c.txt
        # git commit --message "Add file_c.txt"

        # git checkout alt
        # echo "text4" > file_c.txt
        # git add file_c.txt
        # git commit --message "Add file_c.txt"

        # git checkout main
        # git merge --no-commit alt
        %text
        #|u AA N... 000000 100644 100644 100644 0000000000000000000000000000000000000000 1664584d9a5168247c12877b7fdd2f5549d1d1dd 9e9d6c3d83f973a03c508b354af0d383aca94cb5 file_c.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '1'
      The variable X_CHANGED_INDEX should equal '1'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_ADDED should equal '1'
      The variable X_ADDED_INDEX should equal '1'
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal ''
      The variable X_DELETED_INDEX should equal ''
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal ''
      The variable X_MODIFIED_INDEX should equal ''
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_RENAMED should equal ''
      The variable X_RENAMED_INDEX should equal ''
      The variable X_RENAMED_WORKTREE should equal ''
      The variable X_COPIED should equal ''
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal ''
      The variable X_MERGED should equal '1'
      The variable X_MERGE_ADDED_THEM should equal '1'
      The variable X_MERGE_ADDED_US should equal '1'
      The variable X_MERGE_DELETED_THEM should equal ''
      The variable X_MERGE_DELETED_US should equal ''
      The variable X_MERGE_MODIFIED_THEM should equal ''
      The variable X_MERGE_MODIFIED_US should equal ''
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for conflicting modifications in merge'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # git init --initial-branch="initial"
        # git commit --message "Initial commit" --allow-empty
        # git branch main
        # git checkout main

        # echo "text1" > file_a.txt
        # git add file_a.txt
        # git commit --message "Add file_a.txt"

        # git branch alt

        # echo "text2" >> file_a.txt
        # git add file_a.txt
        # git commit --message "Edit file_a.txt"

        # git checkout alt
        # echo "text3" >> file_a.txt
        # git add file_a.txt
        # git commit --message "Edit file_a.txt"

        # git checkout main
        # git merge alt --no-commit
        %text
        #|u UU N... 100644 100644 100644 100644 ad1a4f341d4f1cd0f5ad1da45e17e1ee03d1bac4 1294840905f10805aa29490c5cdd05f048251587 93a984cfca873b8767298486aa42f6c0c488bb69 file_a.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '1'
      The variable X_CHANGED_INDEX should equal '1'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_ADDED should equal ''
      The variable X_ADDED_INDEX should equal ''
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal ''
      The variable X_DELETED_INDEX should equal ''
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '1'
      The variable X_MODIFIED_INDEX should equal '1'
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_RENAMED should equal ''
      The variable X_RENAMED_INDEX should equal ''
      The variable X_RENAMED_WORKTREE should equal ''
      The variable X_COPIED should equal ''
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal ''
      The variable X_MERGED should equal '1'
      The variable X_MERGE_ADDED_THEM should equal ''
      The variable X_MERGE_ADDED_US should equal ''
      The variable X_MERGE_DELETED_THEM should equal ''
      The variable X_MERGE_DELETED_US should equal ''
      The variable X_MERGE_MODIFIED_THEM should equal '1'
      The variable X_MERGE_MODIFIED_US should equal '1'
      The variable X_CLEAN should equal ''
    End

    It 'sets vars for conflicting modified-us deleted-them in merge'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # git init --initial-branch="initial"
        # git commit --message "Initial commit" --allow-empty
        # git branch main
        # git checkout main

        # echo "text1" > file_a.txt
        # git add file_a.txt
        # git commit --message "Add file_a.txt"

        # git branch alt

        # echo "text2" >> file_a.txt
        # git add file_a.txt
        # git commit --message "Edit file_a.txt"

        # git checkout alt
        # git rm file_a.txt
        # git commit --message "Remove file_a.txt"

        # git checkout main
        # git merge alt --no-commit
        %text
        #|u UD N... 100644 100644 000000 100644 ad1a4f341d4f1cd0f5ad1da45e17e1ee03d1bac4 1294840905f10805aa29490c5cdd05f048251587 0000000000000000000000000000000000000000 file_a.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '1'
      The variable X_CHANGED_INDEX should equal '1'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_ADDED should equal ''
      The variable X_ADDED_INDEX should equal ''
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal '1'
      The variable X_DELETED_INDEX should equal '1'
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '1'
      The variable X_MODIFIED_INDEX should equal '1'
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_RENAMED should equal ''
      The variable X_RENAMED_INDEX should equal ''
      The variable X_RENAMED_WORKTREE should equal ''
      The variable X_COPIED should equal ''
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal ''
      The variable X_MERGED should equal '1'
      The variable X_MERGE_ADDED_THEM should equal ''
      The variable X_MERGE_ADDED_US should equal ''
      The variable X_MERGE_DELETED_THEM should equal '1'
      The variable X_MERGE_DELETED_US should equal ''
      The variable X_MERGE_MODIFIED_THEM should equal ''
      The variable X_MERGE_MODIFIED_US should equal '1'
      The variable X_CLEAN should equal ''
    End


    It 'sets vars for conflicting deleted-us modified-them in merge'
      git() {
        [[ "$2" == 'status' ]] || return 1
        # git init --initial-branch="initial"
        # git commit --message "Initial commit" --allow-empty
        # git branch main
        # git checkout main

        # echo "text1" > file_a.txt
        # git add file_a.txt
        # git commit --message "Add file_a.txt"

        # git branch alt

        # git rm file_a.txt
        # git commit --message "Remove file_a.txt"

        # git checkout alt
        # echo "text2" >> file_a.txt
        # git add file_a.txt
        # git commit --message "Edit file_a.txt"

        # git checkout main
        # git merge alt --no-commit
        %text
        #|u DU N... 100644 000000 100644 100644 ad1a4f341d4f1cd0f5ad1da45e17e1ee03d1bac4 0000000000000000000000000000000000000000 1294840905f10805aa29490c5cdd05f048251587 file_a.txt
        return 0
      }
      When call set_git_status_vars X
      The variable X_UNTRACKED should equal ''
      The variable X_CHANGED should equal '1'
      The variable X_CHANGED_INDEX should equal '1'
      The variable X_CHANGED_WORKTREE should equal ''
      The variable X_ADDED should equal ''
      The variable X_ADDED_INDEX should equal ''
      The variable X_ADDED_WORKTREE should equal ''
      The variable X_DELETED should equal '1'
      The variable X_DELETED_INDEX should equal '1'
      The variable X_DELETED_WORKTREE should equal ''
      The variable X_MODIFIED should equal '1'
      The variable X_MODIFIED_INDEX should equal '1'
      The variable X_MODIFIED_WORKTREE should equal ''
      The variable X_RENAMED should equal ''
      The variable X_RENAMED_INDEX should equal ''
      The variable X_RENAMED_WORKTREE should equal ''
      The variable X_COPIED should equal ''
      The variable X_COPIED_INDEX should equal ''
      The variable X_COPIED_WORKTREE should equal ''
      The variable X_MERGED should equal '1'
      The variable X_MERGE_ADDED_THEM should equal ''
      The variable X_MERGE_ADDED_US should equal ''
      The variable X_MERGE_DELETED_THEM should equal ''
      The variable X_MERGE_DELETED_US should equal '1'
      The variable X_MERGE_MODIFIED_THEM should equal '1'
      The variable X_MERGE_MODIFIED_US should equal ''
      The variable X_CLEAN should equal ''
    End

  End

End
