# Commit and Push

Commit changes with the provided message and push to the remote repository.

## Instructions

1. This skill should be run after `/commit` has generated a recommended commit message
2. If the user provides a commit message (either directly or from a previous `/commit` output), use that message
3. If no message is provided, ask the user for the commit message or suggest running `/commit` first
4. Check if there are staged changes with `git diff --staged --quiet`
5. If no staged changes, automatically stage all modified tracked files with `git add -u`
6. Execute the commit using the message with a HEREDOC for proper formatting:
   ```bash
   git commit -m "$(cat <<'EOF'
   <commit message here>
   EOF
   )"
   ```
7. After successful commit, push to the remote:
   ```bash
   git push
   ```
8. If the push fails due to no upstream branch, set the upstream and push:
   ```bash
   git push -u origin <current-branch>
   ```
9. Report the results to the user, including:
   - The commit hash
   - The branch pushed to
   - Any relevant output or errors

## Important

- NEVER skip pre-commit hooks (no --no-verify flag)
- NEVER force push unless explicitly requested
- If the commit fails due to pre-commit hooks, report the error and do NOT retry automatically
- Always verify the current branch before pushing
- Use `git add -u` to stage modified files (not `git add .` which would include untracked files)
