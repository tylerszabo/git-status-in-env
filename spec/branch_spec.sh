Describe 'git-status-in-env.sh'
  Include ./git-status-in-env.sh

  Describe 'Set branch info'
    It 'sets vars for an initial repo'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid (initial)
        #|# branch.head main
        return 0
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '(initial)'
      The variable X_UPSTREAM should equal ''
      The variable X_AHEAD should equal ''
      The variable X_BEHIND should equal ''
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for an up-to-date repo'
      git() {
        if [[ "$2" == 'status' ]]; then
          %text
          #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
          #|# branch.head main
          #|# branch.upstream origin/main
          #|# branch.ab +0 -0
          return 0
        elif [[ "$2" == 'rev-parse' ]]; then
          if [[ "$5" == 'origin/main^{commit}' ]]; then
            echo 60ffebbec0f5dd33d6ed81ba5035e0e5d91986b1
            return 0
          else
            echo 'fatal: Needed a single revision' >&2
            return 128
          fi
        else
          return 1
        fi
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal 'origin/main'
      The variable X_AHEAD should equal ''
      The variable X_BEHIND should equal ''
      The variable X_EQUAL should equal '1'
    End

    It 'sets vars for a divergent repo'
      git() {
        if [[ "$2" == 'status' ]]; then
          %text
          #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
          #|# branch.head main
          #|# branch.upstream origin/main
          #|# branch.ab +1 -2
          return 0
        elif [[ "$2" == 'rev-parse' ]]; then
          if [[ "$5" == 'origin/main^{commit}' ]]; then
            echo 60ffebbec0f5dd33d6ed81ba5035e0e5d91986b1
            return 0
          else
            echo 'fatal: Needed a single revision' >&2
            return 128
          fi
        else
          return 1
        fi
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal 'origin/main'
      The variable X_AHEAD should equal '1'
      The variable X_BEHIND should equal '2'
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for an ahead repo'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
        #|# branch.head main
        #|# branch.upstream origin/main
        #|# branch.ab +1 -0
        return 0
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal 'origin/main'
      The variable X_AHEAD should equal '1'
      The variable X_BEHIND should equal ''
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for a behind repo'
      git() {
        if [[ "$2" == 'status' ]]; then
          %text
          #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
          #|# branch.head main
          #|# branch.upstream origin/main
          #|# branch.ab +0 -1
          return 0
        elif [[ "$2" == 'rev-parse' ]]; then
          if [[ "$5" == 'origin/main^{commit}' ]]; then
            echo 60ffebbec0f5dd33d6ed81ba5035e0e5d91986b1
            return 0
          else
            echo 'fatal: Needed a single revision' >&2
            return 128
          fi
        else
          return 1
        fi
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal 'origin/main'
      The variable X_AHEAD should equal ''
      The variable X_BEHIND should equal '1'
      The variable X_GONE should equal ''
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for a detached repo'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
        #|# branch.head (detached)
        return 0
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal '(detached)'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal ''
      The variable X_AHEAD should equal ''
      The variable X_BEHIND should equal ''
      The variable X_GONE should equal ''
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for a missing upstream'
      git() {
        if [[ "$2" == 'status' ]]; then
          %text
          #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
          #|# branch.head main
          #|# branch.upstream origin/main
          return 0
        elif [[ "$2" == 'rev-parse' ]]; then
          echo 'fatal: Needed a single revision' >&2
          return 128
        else
          return 1
        fi
      }
      When call set_git_status_vars X
      The variable X_BRANCH should equal 'main'
      The variable X_COMMIT should equal '73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9'
      The variable X_UPSTREAM should equal 'origin/main'
      The variable X_AHEAD should equal ''
      The variable X_BEHIND should equal ''
      The variable X_GONE should equal '1'
      The variable X_EQUAL should equal ''
    End

    It 'sets vars for a stash present'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
        #|# branch.head main
        #|# branch.upstream origin/main
        #|# branch.ab +0 -0
        #|# stash 1
        return 0
      }
      When call set_git_status_vars X
      The variable X_STASH should equal '1'
    End

    It 'sets vars for multiple stashed'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
        #|# branch.head main
        #|# branch.upstream origin/main
        #|# branch.ab +0 -0
        #|# stash 2
        return 0
      }
      When call set_git_status_vars X
      The variable X_STASH should equal '2'
    End

    It 'sets vars for a stash absent'
      git() {
        [[ "$2" == 'status' ]] || return 1
        %text
        #|# branch.oid 73c0b7af0ca1a3977dedd62bfe4f3c4d45a853a9
        #|# branch.head main
        #|# branch.upstream origin/main
        #|# branch.ab +0 -0
        return 0
      }
      When call set_git_status_vars X
      The variable X_STASH should equal ''
    End
  End

End
