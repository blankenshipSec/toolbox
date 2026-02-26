# new-project.sh

A shell script that automates the full setup of a new Python security tool project for blankenshipSec.

## What It Does

Running this script handles everything in one command:

- Creates a public GitHub repository with a custom description
- Clones it locally into the correct folder
- Renames the branch from master to main
- Creates a Python virtual environment
- Adds .gitignore, LICENSE, and README to GitHub automatically
- Generates a starter Python file with shebang and docstring pre-filled
- Commits and pushes the starter file to GitHub

## Usage
```bash
~/Projects/toolbox/new-project/new-project.sh <project-name>
```

## Example
```bash
~/Projects/toolbox/new-project/new-project.sh log-analyzer
```

You will be prompted for:
1. A short description for the GitHub repository
2. The main Python filename (without .py)

## Requirements

- Git
- GitHub CLI (`gh`) — authenticated with your GitHub account
- Python 3.10+

## Notes

- Requires GitHub CLI to be authenticated via `gh auth login`
- Virtual environment must be activated manually after setup
- Add packages with `pip install` then freeze with `pip freeze > requirements.txt`