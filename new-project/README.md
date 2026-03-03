# new-project

A shell function that automates project setup for blankenshipSec. Supports two workflows — creating a new security tool repository or adding a new script to the toolbox.

## Setup

Add this line to your `.bashrc` to load the function into your shell:
```bash
source ~/Projects/toolbox/new-project/new-project.sh
```

Then reload your shell:
```bash
source ~/.bashrc
```

## Usage
```bash
new-project <name>
```

You will be prompted to select a workflow:
```
What are you creating?
  1) New security tool (new GitHub repo)
  2) New toolbox script (add to toolbox)
```

## Workflow 1 — New Security Tool

Creates a new public GitHub repository under blankenshipSec, clones it into `~/Projects/blankenshipSec/`, sets up a Python virtual environment, adds .gitignore, LICENSE, and README, generates a starter Python file with shebang and docstring pre-filled, and navigates into the project folder with the venv activated.

You will be prompted for:
1. A short description for the GitHub repository
2. The main Python filename (without .py)

## Workflow 2 — New PowerShell Security Tool

Creates a new public GitHub repository under blankenshipSec, clones it into `~/Projects/blankenshipSec/`, adds .gitignore, LICENSE, and README, generates a starter PowerShell file with comment-based help header pre-filled, and navigates into the project folder.

You will be prompted for:
1. A short description for the GitHub repository
2. The main PowerShell filename (without .ps1)

## Workflow 3 — New Toolbox Script

Creates a new subfolder inside `~/Projects/toolbox/` with a starter script file and README, then commits and pushes to the toolbox repository.

You will be prompted for:
1. A short description of what the script does
2. The script filename (without extension)
3. The file extension (sh or py)

## Requirements

- Git
- GitHub CLI (`gh`) — authenticated with your GitHub account
- Python 3.10+ (for Python projects)
- PowerShell 7+ (for PowerShell projects)

## Author

Joshua Blankenship (blankenshipSec)