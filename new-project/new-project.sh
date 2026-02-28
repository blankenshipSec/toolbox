#!/usr/bin/env bash
# new-project.sh - Automates new Python project setup for blankenshipSec
# Usage: source ~/Projects/toolbox/new-project/new-project.sh
# Author: Joshua Blankenship (blankenshipSec)

new-project() {

    # ------ Input Validation ------
    local PROJECT_NAME=$1

    if [ -z "$PROJECT_NAME" ]; then
        echo "Error: No project name provided."
        echo "Usage: new-project <project-name>"
        return 1
    fi

    echo ""
    echo "================================"
    echo "  blankenshipSec Project Setup"
    echo "  Project: $PROJECT_NAME"
    echo "================================"
    echo ""

    # ------ Workflow Selection ------
    echo "What are you creating?"
    echo "  1) New security tool (new GitHub repo)"
    echo "  2) New toolbox script (add to toolbox)"
    echo ""
    echo "Enter 1 or 2:"
    read -r WORKFLOW

    if [ "$WORKFLOW" = "1" ]; then
        _new_security_tool "$PROJECT_NAME"
    elif [ "$WORKFLOW" = "2" ]; then
        _new_toolbox_script "$PROJECT_NAME"
    else
        echo "Error: Invalid selection. Enter 1 or 2."
        return 1
    fi
}

# ------ Workflow 1: New Security Tool ------
_new_security_tool() {
    local PROJECT_NAME=$1
    local BASE_DIR=~/Projects/blankenshipSec

    echo "Enter a short description for the GitHub repository:"
    read -r REPO_DESCRIPTION

    echo "Enter the main Python filename (without .py):"
    read -r PYTHON_FILENAME

    echo "Creating GitHub repository..."
    gh repo create "blankenshipSec/$PROJECT_NAME" --public \
        --description "$REPO_DESCRIPTION"

    cd "$BASE_DIR" || return 1
    gh repo clone "blankenshipSec/$PROJECT_NAME"
    cd "$PROJECT_NAME" || return 1
    git branch -M main

    echo "Repository created and cloned."
    echo ""

    # ------ Virtual Environment ------
    echo "Creating virtual environment..."
    python -m venv venv
    echo "Virtual environment created."
    echo ""

    # ------ Add GitHub Files ------
    echo "Adding .gitignore, LICENSE, and README to repository..."

    gh api repos/blankenshipSec/$PROJECT_NAME/contents/.gitignore \
        -X PUT \
        -f message="Add .gitignore" \
        -f content="$(printf 'venv/\n__pycache__/\n*.pyc\n.env' | base64)" \
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

    # ------ Pull and Generate Starter File ------
    echo "Pulling files from GitHub..."
    git pull origin main

    cat > "$PYTHON_FILENAME.py" << EOF
#!/usr/bin/env python3
"""
$PROJECT_NAME - $REPO_DESCRIPTION
Author: Joshua Blankenship (blankenshipSec)
GitHub: https://github.com/blankenshipSec/$PROJECT_NAME
License: MIT
"""

EOF

    echo "Created $PYTHON_FILENAME.py"

    git add "$PYTHON_FILENAME.py"
    git commit -m "Add starter Python file"
    git push origin main

    # ------ Activate Venv ------
    source venv/Scripts/activate

    echo ""
    echo "========================================"
    echo "  Setup Complete!"
    echo "  Project: $PROJECT_NAME"
    echo "  Location: $(pwd)"
    echo ""
    echo "  Next steps:"
    echo "  1. Install packages: pip install <packages>"
    echo "  2. Freeze deps:      pip freeze > requirements.txt"
    echo "  3. Start coding:     code $PYTHON_FILENAME.py"
    echo "========================================"
    echo ""
}

# ------ Workflow 2: New Toolbox Script ------
_new_toolbox_script() {
    local SCRIPT_NAME=$1
    local TOOLBOX_DIR=~/Projects/toolbox

    echo "Enter a short description of what this script does:"
    read -r SCRIPT_DESCRIPTION

    echo "Enter the script filename (without extension, e.g. setup or deploy):"
    read -r SCRIPT_FILENAME

    echo "Enter the file extension (sh or py):"
    read -r SCRIPT_EXT

    # ------ Create Subfolder and Files ------
    mkdir -p "$TOOLBOX_DIR/$SCRIPT_NAME"

    cat > "$TOOLBOX_DIR/$SCRIPT_NAME/$SCRIPT_FILENAME.$SCRIPT_EXT" << EOF
#!/usr/bin/env bash
# $SCRIPT_FILENAME.$SCRIPT_EXT - $SCRIPT_DESCRIPTION
# Author: Joshua Blankenship (blankenshipSec)
EOF

    chmod +x "$TOOLBOX_DIR/$SCRIPT_NAME/$SCRIPT_FILENAME.$SCRIPT_EXT"

    cat > "$TOOLBOX_DIR/$SCRIPT_NAME/README.md" << EOF
# $SCRIPT_NAME

$SCRIPT_DESCRIPTION

## Usage

\`\`\`bash
source ~/Projects/toolbox/new-project/new-project.sh
$SCRIPT_NAME
\`\`\`

## Author

Joshua Blankenship (blankenshipSec)
EOF

    # ------ Update Root README Table ------
    # ------ Commit and Push ------
    cd "$TOOLBOX_DIR" || return 1

    git add .
    git commit -m "Add $SCRIPT_NAME script to toolbox"
    git push origin main

    cd "$TOOLBOX_DIR/$SCRIPT_NAME" || return 1

    echo ""
    echo "========================================"
    echo "  Toolbox Script Created!"
    echo "  Script: $SCRIPT_NAME"
    echo "  Location: $(pwd)"
    echo ""
    echo "  Next steps:"
    echo "  1. Open script:  code $SCRIPT_FILENAME.$SCRIPT_EXT"
    echo "  2. Edit README:  code README.md"
    echo "========================================"
    echo ""
}