#!/usr/bin/env bash
# new-project.sh - Automates new Python project setup for blankenshipSec
# Usage: ./new-project.sh <project-name>
# Author: Joshua Blankenship (blankenshipSec)

set -e # Exit immediately if any command fails

# ------ Input Validation ------
PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
    echo "Error: No project name provided."
    echo "Usage: ./new-project.sh <project-name>"
    exit 1
fi

echo ""
echo "================================"
echo "  blankenshipSec Project Setup"
echo "  Project: $PROJECT_NAME"
echo "================================"
echo ""

# ------ Create GitHub Repository ------
echo "Enter a short description for the GitHub repository:"
read -r REPO_DESCRIPTION

echo "Creating GitHub repository..."
gh repo create "blankenshipSec/$PROJECT_NAME" --public \
    --description "$REPO_DESCRIPTION" \
    --clone

cd "$PROJECT_NAME"
git branch -M main

echo "Repository created and cloned."
echo ""

# ------ Set Up Virtual Python Environment ------
echo "Creating virtual environment..."
python -m venv venv

echo "Virtual environment created."
echo ""

# ------ Add GitHub Files ------
echo "Adding .gitignore, LICENSE, and README to repository..."

gh api repos/blankenshipSec/$PROJECT_NAME/contents/.gitignore \
    -X PUT \
    -f message="Add .gitignore" \
    -f content="$(printf 'venv/\n__pycache__/\n*.pyc\n.env\n*.txt' | base64)" \
    > /dev/null 2>&1

gh api repos/blankenshipSec/$PROJECT_NAME/contents/LICENSE \
    -X PUT \
    -f message="Add MIT License" \
    -f content="$(printf 'MIT License\n\nCopyright (c) 2026 Joshua Blankenship (blankenshipSec)\n\nPermission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n\nThe above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n\nTHE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.' | base64)" \
    > /dev/null 2>&1

gh api repos/blankenshipSec/$PROJECT_NAME/contents/README.md \
    -X PUT \
    -f message="Add placeholder README" \
    -f content="$(printf "# $PROJECT_NAME\n\n> **Status:** Active Development" | base64)" \
    > /dev/null 2>&1

echo "Files added to GitHub."
echo ""

# ------ Pull Everything Locally ------
echo "Pulling files from GitHub..."
git pull origin main

echo ""
echo "========================================"
echo "  Setup Complete!"
echo "  Project: $PROJECT_NAME"
echo "  Location: $(pwd)"
echo ""
echo "  Next steps:"
echo "  1. Activate venv: source venv/Scripts/activate"
echo "  2. Install packages: pip install rich"
echo "  3. Freeze deps: pip freeze > requirements.txt"
echo "  4. Start coding!"
echo "========================================"
echo ""