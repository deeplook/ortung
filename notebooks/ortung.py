"""
Building blocks for an emerging Ortung...
"""

import os
import shutil
import tempfile
import subprocess
from os.path import exists, join, dirname


def clone_repo(url, branch=None, dest_dir=None):
    """Clone a Git repo into some destination folder.

    For now this clones a repo like https://github.com/jshttp/mime-types.git
    into a `mime-types` subdirectory, recreating it from scratch if it already
    exists. If a branch is given it is checked out after cloning, too.
    """
    dest_dir = dest_dir or "."
    
    repo_name = url.split("/")[-1]
    if repo_name.endswith(".git"):
        repo_name = repo_name[:-4] 
    
    tmp_path = tempfile.NamedTemporaryFile(dir=dest_dir).name
    cmd = ["git", "clone", url, tmp_path]
    output = subprocess.check_output(cmd).decode("utf-8")

    if branch:
        cwd = os.getcwd()
        os.chdir(tmp_path)
        cmd = ["git", "checkout", branch]
        try:
            out = subprocess.check_output(cmd).decode("utf-8")
        finally:
            os.chdir(cwd)

    repo_path = join(dirname(tmp_path), repo_name)
    if exists(repo_path):
        shutil.rmtree(repo_path)
    os.rename(tmp_path, repo_path)
    
    return output
