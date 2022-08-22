ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ dir
HW1  HW2  HW4

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        HW4/

nothing added to commit but untracked files present (use "git add" to track)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git add -h
usage: git add [<options>] [--] <pathspec>...

    -n, --dry-run         dry run
    -v, --verbose         be verbose

    -i, --interactive     interactive picking
    -p, --patch           select hunks interactively
    -e, --edit            edit current diff and apply
    -f, --force           allow adding otherwise ignored files
    -u, --update          update tracked files
    --renormalize         renormalize EOL of tracked files (implies -u)
    -N, --intent-to-add   record only the fact that the path will be added later
    -A, --all             add changes from all tracked and untracked files
    --ignore-removal      ignore paths removed in the working tree (same as --no-all)
    --refresh             don't add, only refresh the index
    --ignore-errors       just skip files which cannot be added because of errors
    --ignore-missing      check if - even missing - files are ignored in dry run
    --chmod (+|-)x        override the executable bit of the listed files
    --pathspec-from-file <file>
                          read pathspec from file
    --pathspec-file-nul   with --pathspec-from-file, pathspec elements are separated with NUL character


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git add -A

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git status
On branch main
Your branch is ahead of 'origin/main' by 2 commits.
  (use "git push" to publish your local commits)

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        new file:   HW4/branching/merge.sh
        new file:   HW4/branching/rebase.sh


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git commit -m 'prepare for merge and rebase'
[main 5c761df] prepare for merge and rebase
 2 files changed, 16 insertions(+)
 create mode 100644 HW4/branching/merge.sh
 create mode 100644 HW4/branching/rebase.sh

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git switch -c git-merge
Switched to a new branch 'git-merge'

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git status
On branch git-merge
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   HW4/branching/merge.sh

no changes added to commit (use "git add" and/or "git commit -a")

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git commit -h
usage: git commit [<options>] [--] <pathspec>...

    -q, --quiet           suppress summary after successful commit
    -v, --verbose         show diff in commit message template

Commit message options
    -F, --file <file>     read message from file
    --author <author>     override author for commit
    --date <date>         override date for commit
    -m, --message <message>
                          commit message
    -c, --reedit-message <commit>
                          reuse and edit message from specified commit
    -C, --reuse-message <commit>
                          reuse message from specified commit
    --fixup [(amend|reword):]commit
                          use autosquash formatted message to fixup or amend/reword specified commit
    --squash <commit>     use autosquash formatted message to squash specified commit
    --reset-author        the commit is authored by me now (used with -C/-c/--amend)
    --trailer <trailer>   add custom trailer(s)
    -s, --signoff         add a Signed-off-by trailer
    -t, --template <file>
                          use specified template file
    -e, --edit            force edit of commit
    --cleanup <mode>      how to strip spaces and #comments from message
    --status              include status in commit message template
    -S, --gpg-sign[=<key-id>]
                          GPG sign commit

Commit contents options
    -a, --all             commit all changed files
    -i, --include         add specified files to index for commit
    --interactive         interactively add files
    -p, --patch           interactively add changes
    -o, --only            commit only specified files
    -n, --no-verify       bypass pre-commit and commit-msg hooks
    --dry-run             show what would be committed
    --short               show status concisely
    --branch              show branch information
    --ahead-behind        compute full ahead/behind values
    --porcelain           machine-readable output
    --long                show status in long format (default)
    -z, --null            terminate entries with NUL
    --amend               amend previous commit
    --no-post-rewrite     bypass post-rewrite hook
    -u, --untracked-files[=<mode>]
                          show untracked files, optional modes: all, normal, no. (Default: all)
    --pathspec-from-file <file>
                          read pathspec from file
    --pathspec-file-nul   with --pathspec-from-file, pathspec elements are separated with NUL character


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git commit -a -m 'merge: @ instead *'
[git-merge 553829c] merge: @ instead *
 1 file changed, 2 insertions(+), 2 deletions(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git status
On branch git-merge
nothing to commit, working tree clean

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git status
On branch git-merge
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   HW4/branching/merge.sh

no changes added to commit (use "git add" and/or "git commit -a")

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git commit -a -m 'merge: use shift'
[git-merge 9d22ff4] merge: use shift
 1 file changed, 3 insertions(+), 2 deletions(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git status
On branch git-merge
nothing to commit, working tree clean

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-merge)
$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 3 commits.
  (use "git push" to publish your local commits)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git commit -a -m 'каждый параметр в новой строке'
[main 26afc3f] каждый параметр в новой строке
 1 file changed, 5 insertions(+), 3 deletions(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git status
On branch main
Your branch is ahead of 'origin/main' by 4 commits.
  (use "git push" to publish your local commits)

nothing to commit, working tree clean

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git log
commit 26afc3fa438d9aae47a0fe7b073ade1e247b6703 (HEAD -> main)
Author: olegdy <olegdy@yandex.ru>
Date:   Mon Aug 22 11:51:55 2022 +1000

    каждый параметр в новой строке

commit 5c761df2bd5e5f4f5070734b4b0febf75fdd750a
Author: olegdy <olegdy@yandex.ru>
Date:   Mon Aug 22 11:44:34 2022 +1000

    prepare for merge and rebase

commit d35f77c559ba4abde75d9dd625405f701d0fbfe5
Author: olegdy <olegdy@yandex.ru>
Date:   Fri Aug 19 12:01:00 2022 +1000

    HW 2.2-4

commit 4620b223bf420ceb037e791e17b3059b293d759a
Author: olegdy <olegdy@yandex.ru>
Date:   Fri Aug 19 11:59:28 2022 +1000

    1

commit 6ca232929e0d1db481d0f1c6bddeb90ad7ca8fbb (tag: v0.1, tag: v0.0, origin/main, gitlab/main, bitbucket/main)
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:44:30 2022 +1000

    1

commit ebbcf4b62ece5b54ecc49ed8046f9811c59f1da2
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:19:30 2022 +1000

    Moved and deleted

commit 19a8d44b4694b3e6be12005faafd7a512decf0aa
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:17:12 2022 +1000

    Prepare to delete and move

commit ac863442f14a75eb770da9401fc83156ed1c802d
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:13:03 2022 +1000

    Added gitignore

commit 70b74bf3f508b5fd0607e528027b3efdbff1b574
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:10:32 2022 +1000

    Added gitignore

commit 0527169c86a3c30e83851eb562944ab251c73f6c
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 15:01:11 2022 +1000

    first commit

commit 69bd141c0029a168dc8b576a4bd6e2d072d9204f
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 14:58:43 2022 +1000

    first commit

commit ec0932699eac67acdcf24d92ea3e953c41934a17
Author: olegdy <olegdy@yandex.ru>
Date:   Wed Aug 17 14:50:30 2022 +1000


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git log --one-line
fatal: unrecognized argument: --one-line

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git log --oneline
26afc3f (HEAD -> main) каждый параметр в новой строке
5c761df prepare for merge and rebase
d35f77c HW 2.2-4
4620b22 1
6ca2329 (tag: v0.1, tag: v0.0, origin/main, gitlab/main, bitbucket/main) 1
ebbcf4b Moved and deleted
19a8d44 Prepare to delete and move
ac86344 Added gitignore
70b74bf Added gitignore
0527169 first commit
69bd141 first commit
ec09326 first commit
ba071d2 first commit
e48b781 1
a97825d 1
b34cdb7 1

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git checkout 5c761df
Note: switching to '5c761df'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

  git switch -c <new-branch-name>

Or undo this operation with:

  git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 5c761df prepare for merge and rebase

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps ((5c761df...))
$ git switch -c git-rebase
Switched to a new branch 'git-rebase'

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git status
On branch git-rebase
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   HW4/branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git commit -a -m 'git-rebase 1'
[git-rebase ecfc237] git-rebase 1
 1 file changed, 5 insertions(+), 3 deletions(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git status
On branch git-rebase
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
        modified:   HW4/branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git commit -a -m 'git-rebase 2'
[git-rebase a041eaa] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git push -h
usage: git push [<options>] [<repository> [<refspec>...]]

    -v, --verbose         be more verbose
    -q, --quiet           be more quiet
    --repo <repository>   repository
    --all                 push all refs
    --mirror              mirror all refs
    -d, --delete          delete refs
    --tags                push tags (can't be used with --all or --mirror)
    -n, --dry-run         dry run
    --porcelain           machine-readable output
    -f, --force           force updates
    --force-with-lease[=<refname>:<expect>]
                          require old value of ref to be at this value
    --force-if-includes   require remote updates to be integrated locally
    --recurse-submodules (check|on-demand|no)
                          control recursive pushing of submodules
    --thin                use thin pack
    --receive-pack <receive-pack>
                          receive pack program
    --exec <receive-pack>
                          receive pack program
    -u, --set-upstream    set upstream for git pull/status
    --progress            force progress reporting
    --prune               prune locally removed refs
    --no-verify           bypass pre-push hook
    --follow-tags         push missing but relevant tags
    --signed[=(yes|no|if-asked)]
                          GPG sign the push
    --atomic              request atomic transaction on remote side
    -o, --push-option <server-specific>
                          option to transmit
    -4, --ipv4            use IPv4 addresses only
    -6, --ipv6            use IPv6 addresses only


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git push
fatal: The current branch git-rebase has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin git-rebase


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git remote
bitbucket
gitlab
origin

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git remote -v
bitbucket       https://OlegDy@bitbucket.org/olegdy/devops.git (fetch)
bitbucket       https://OlegDy@bitbucket.org/olegdy/devops.git (push)
gitlab  https://gitlab.com/OlegDy/devops.git (fetch)
gitlab  https://gitlab.com/OlegDy/devops.git (push)
origin  https://github.com/OlegDy/DevOps.git (fetch)
origin  https://github.com/OlegDy/DevOps.git (push)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git checkout main
Switched to branch 'main'
Your branch is ahead of 'origin/main' by 4 commits.
  (use "git push" to publish your local commits)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push origin
Enumerating objects: 21, done.
Counting objects: 100% (21/21), done.
Delta compression using up to 8 threads
Compressing objects: 100% (16/16), done.
Writing objects: 100% (18/18), 1.57 KiB | 805.00 KiB/s, done.
Total 18 (delta 7), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (7/7), completed with 3 local objects.
To https://github.com/OlegDy/DevOps.git
   6ca2329..26afc3f  main -> main

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push -all origin
error: did you mean `--all` (with two dashes)?

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push --all origin
Enumerating objects: 25, done.
Counting objects: 100% (24/24), done.
Delta compression using up to 8 threads
Compressing objects: 100% (16/16), done.
Writing objects: 100% (20/20), 1.89 KiB | 643.00 KiB/s, done.
Total 20 (delta 2), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (2/2), done.
To https://github.com/OlegDy/DevOps.git
 * [new branch]      git-merge -> git-merge
 * [new branch]      git-rebase -> git-rebase

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git merge 'git-merge'
Merge made by the 'recursive' strategy.
 HW4/branching/merge.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push origin
Enumerating objects: 10, done.
Counting objects: 100% (10/10), done.
Delta compression using up to 8 threads
Compressing objects: 100% (3/3), done.
Writing objects: 100% (4/4), 462 bytes | 462.00 KiB/s, done.
Total 4 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/OlegDy/DevOps.git
   26afc3f..b85435c  main -> main

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git checkout git-rebase
Switched to branch 'git-rebase'

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git rebase -i main
error: could not apply ecfc237... git-rebase 1
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply ecfc237... git-rebase 1
Auto-merging HW4/branching/rebase.sh
CONFLICT (content): Merge conflict in HW4/branching/rebase.sh

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 1/2)
$ git add rebase.sh
fatal: pathspec 'rebase.sh' did not match any files

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 1/2)
$ git add -A

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 1/2)
$ git status
interactive rebase in progress; onto b85435c
Last command done (1 command done):
   pick ecfc237 git-rebase 1
Next command to do (1 remaining command):
   pick a041eaa git-rebase 2
  (use "git rebase --edit-todo" to view and edit)
You are currently rebasing branch 'git-rebase' on 'b85435c'.
  (all conflicts fixed: run "git rebase --continue")

nothing to commit, working tree clean

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 1/2)
$ git rebase --continue
error: could not apply a041eaa... git-rebase 2
Resolve all conflicts manually, mark them as resolved with
"git add/rm <conflicted_files>", then run "git rebase --continue".
You can instead skip this commit: run "git rebase --skip".
To abort and get back to the state before "git rebase", run "git rebase --abort".
Could not apply a041eaa... git-rebase 2
Auto-merging HW4/branching/rebase.sh
CONFLICT (content): Merge conflict in HW4/branching/rebase.sh

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 2/2)
$ git status
interactive rebase in progress; onto b85435c
Last commands done (2 commands done):
   pick ecfc237 git-rebase 1
   pick a041eaa git-rebase 2
No commands remaining.
You are currently rebasing branch 'git-rebase' on 'b85435c'.
  (fix conflicts and then run "git rebase --continue")
  (use "git rebase --skip" to skip this patch)
  (use "git rebase --abort" to check out the original branch)

Unmerged paths:
  (use "git restore --staged <file>..." to unstage)
  (use "git add <file>..." to mark resolution)
        both modified:   HW4/branching/rebase.sh

no changes added to commit (use "git add" and/or "git commit -a")

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 2/2)
$ git add -A

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 2/2)
$ git status
interactive rebase in progress; onto b85435c
Last commands done (2 commands done):
   pick ecfc237 git-rebase 1
   pick a041eaa git-rebase 2
No commands remaining.
You are currently rebasing branch 'git-rebase' on 'b85435c'.
  (all conflicts fixed: run "git rebase --continue")

Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
        modified:   HW4/branching/rebase.sh


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase|REBASE 2/2)
$ git rebase --continue
[detached HEAD 18d2658] git-rebase 2
 1 file changed, 1 insertion(+), 1 deletion(-)
Successfully rebased and updated refs/heads/git-rebase.

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git push
fatal: The current branch git-rebase has no upstream branch.
To push the current branch and set the remote as upstream, use

    git push --set-upstream origin git-rebase


ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git push -u origin git-rebase
To https://github.com/OlegDy/DevOps.git
 ! [rejected]        git-rebase -> git-rebase (non-fast-forward)
error: failed to push some refs to 'https://github.com/OlegDy/DevOps.git'
hint: Updates were rejected because the tip of your current branch is behind
hint: its remote counterpart. Integrate the remote changes (e.g.
hint: 'git pull ...') before pushing again.
hint: See the 'Note about fast-forwards' in 'git push --help' for details.

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git push -u origin git-rebase -f
Enumerating objects: 9, done.
Counting objects: 100% (9/9), done.
Delta compression using up to 8 threads
Compressing objects: 100% (4/4), done.
Writing objects: 100% (5/5), 482 bytes | 482.00 KiB/s, done.
Total 5 (delta 1), reused 0 (delta 0), pack-reused 0
remote: Resolving deltas: 100% (1/1), completed with 1 local object.
To https://github.com/OlegDy/DevOps.git
 + a041eaa...18d2658 git-rebase -> git-rebase (forced update)
Branch 'git-rebase' set up to track remote branch 'git-rebase' from 'origin'.

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (git-rebase)
$ git checkout main
Switched to branch 'main'
Your branch is up to date with 'origin/main'.

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git merge git-rebase
Updating b85435c..18d2658
Fast-forward
 HW4/branching/rebase.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push origin
Total 0 (delta 0), reused 0 (delta 0), pack-reused 0
To https://github.com/OlegDy/DevOps.git
   b85435c..18d2658  main -> main

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$ git push origin --all
Everything up-to-date

ДьяченкоОА@DGT-SRV-021 MINGW64 /c/PycharmProjects/DevOps (main)
$
