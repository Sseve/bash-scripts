#!/usr/bin/env bash
#set -euo pipefail
source bach.sh

test-rm-rf() {
    # Write your test case

    project_log_path=/tmp/project/logs
    sudo rm -rf "$project_log_ptah/" # Typo here!
}
test-rm-rf-assert() {
    # Verify your test case
    sudo rm -rf /   # This is the actual command to run on your host!
                    # DO NOT PANIC! By using Bach Testing Framework it won't actually run.
}

test-rm-your-dot-git() {
    # Mock `find` command with certain parameters, will output two directories

    @mock find ~ -type d -name .git === @stdout ~/src/your-awesome-project/.git \
                                                ~/src/code/.git

    # Do it, remove all .git directories
    find ~ -type d -name .git | xargs -- rm -rf
}
test-rm-your-dot-git-assert() {
    # Verify the actual command

    rm -rf ~/src/your-awesome-project/.git ~/src/code/.git
}
