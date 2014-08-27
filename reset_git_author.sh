#!/bin/bash 

git filter-branch --commit-filter "
  GIT_AUTHOR_NAME='$1';
  GIT_AUTHOR_EMAIL=$2;
  GIT_COMMITTER_NAME='$1';
  GIT_COMMITTER_EMAIL=$2;
  git commit-tree "\$@"
" -- --all 

git update-ref -d refs/original/refs/heads/master
