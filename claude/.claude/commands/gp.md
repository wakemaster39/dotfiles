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
7. After successful commit, check if the branch has an upstream remote:
   ```bash
   git rev-parse --abbrev-ref --symbolic-full-name @{u} 2>/dev/null
   ```
8. Push to the remote:
   ```bash
   git push
   ```
9. If the push fails due to no upstream branch, set the upstream and push:
   ```bash
   git push -u origin <current-branch>
   ```
10. After pushing, check if a PR already exists for this branch:
    ```bash
    gh pr view --json url --jq '.url' 2>/dev/null
    ```
    If a PR exists, include it as a clickable markdown link in the results: `[#<number>](<url>)`
11. **Only if no PR exists** (step 10 failed), create a pull request using `gh`:
    - Use `git log main..<current-branch> --oneline` to understand the full set of commits on the branch
    - Use `git diff main...<current-branch>` to understand the full diff against the base branch
    - Generate a PR title (under 70 chars) and body summarizing **all** commits on the branch
    - **Work project detection:** Check if the repo path starts with `~/work/` (expand `~` to `$HOME`). If it is a work project, gather extra PR options:
      - Add the label `pr-review` (use `--label pr-review`)
      - Find the top 2 committers from the last 20 commits on the base branch (main/staging) to assign as reviewers:
        ```bash
        gh api "repos/{owner}/{repo}/commits?per_page=20&sha=<base-branch>" --jq '.[].author.login' | sort | uniq -c | sort -rn | head -2 | awk '{print $2}'
        ```
      - Exclude the current user (`gh api user --jq '.login'`) from the reviewer list
      - If there are eligible reviewers, add them with `--reviewer <user1> --reviewer <user2>`
    - Create the PR:
      ```bash
      gh pr create --title "<title>" --body "$(cat <<'EOF'
      ## Summary
      <bullet points summarizing the changes>

      ## Test plan
      <bulleted checklist of testing steps>
      EOF
      )" [--label pr-review] [--reviewer <user1> --reviewer <user2>]
      ```
    - Report the PR URL to the user
11. Report the results to the user, including:
    - The commit hash
    - The branch pushed to
    - The PR as a clickable markdown link: `[#<number>](<url>)` (whether existing or newly created)
    - Any relevant output or errors

## Ariadne Integration

After a successful push (whether or not a PR was created), check if there's an active Ariadne work item for the current branch. This links artifacts so the workflow state machine tracks progress.

1. **Get the current branch and repo**:
   ```bash
   branch=$(git rev-parse --abbrev-ref HEAD)
   repo=$(basename "$(git rev-parse --show-toplevel)")
   ```

2. **Check for an active work item** matching this repo:
   ```bash
   ariadne list 2>/dev/null
   ```
   Look for a work item whose `Repo` matches the current repo name. If found, note its ID.

3. **If a PR was just created** and a matching work item exists:
   ```bash
   ariadne link-pr <id> <repo>#<pr-number>
   ```
   This auto-advances the work item to `PrOpen` if it's in an earlier phase.

4. If no work item matches, skip silently — ariadne integration is optional.

## Important

- NEVER skip pre-commit hooks (no --no-verify flag)
- NEVER force push unless explicitly requested
- If the commit fails due to pre-commit hooks, report the error and do NOT retry automatically
- Always verify the current branch before pushing
- Use `git add -u` to stage modified files (not `git add .` which would include untracked files)
