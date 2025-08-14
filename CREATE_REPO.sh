#!/bin/bash

echo "🚀 Creating Nilante Dev CLI Repository"
echo "======================================="

# Step 1: Create repository on GitHub (manual step)
echo "📍 Step 1: Create GitHub Repository"
echo "1. Go to: https://github.com/new"
echo "2. Repository name: Nilante-Dev-CLI"
echo "3. Description: Professional MCP Memory Service - Clean, production-ready semantic memory system for Claude Desktop"  
echo "4. Choose Public or Private"
echo "5. Do NOT initialize with README, .gitignore, or license"
echo "6. Click 'Create repository'"
echo ""
echo "Press Enter when repository is created..."
read

# Step 2: Get repository URL
echo "📍 Step 2: Enter Repository Details"
echo "What's your GitHub username?"
read -p "Username: " GITHUB_USERNAME

REPO_URL="https://github.com/${GITHUB_USERNAME}/Nilante-Dev-CLI.git"

echo "Repository URL will be: $REPO_URL"
echo "Is this correct? (y/n)"
read -p "Confirm: " confirm

if [[ $confirm != "y" && $confirm != "Y" ]]; then
    echo "Please edit this script with the correct URL"
    exit 1
fi

# Step 3: Configure git and update remote
echo "📍 Step 3: Configuring Repository"

# Set git user (update these with your details)
echo "Setting up git configuration..."
git config user.name "Nilante Dev"
git config user.email "nilante@example.com"  # Update this with your email

# Remove current remote and add new one
echo "Updating git remote..."
git remote remove origin 2>/dev/null || true
git remote add origin "$REPO_URL"

# Verify remote
echo "Current remotes:"
git remote -v

# Step 4: Push to repository
echo "📍 Step 4: Pushing to Repository"
echo "Ready to push to $REPO_URL"
echo "This will push your clean MCP Memory Service codebase."
echo "Continue? (y/n)"
read -p "Push: " push_confirm

if [[ $push_confirm == "y" || $push_confirm == "Y" ]]; then
    echo "Pushing to repository..."
    
    # Add the setup script to git
    git add CREATE_REPO.sh REPOSITORY_SETUP.md
    git commit -m "docs: add repository setup instructions and creation script"
    
    # Push to new repository
    git push -u origin main
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "🎉 SUCCESS! Repository created and code pushed!"
        echo "Repository: $REPO_URL"
        echo ""
        echo "Your Nilante Dev CLI is now available at:"
        echo "https://github.com/${GITHUB_USERNAME}/Nilante-Dev-CLI"
        echo ""
        echo "Next steps:"
        echo "1. Visit your repository on GitHub"
        echo "2. Add topics: mcp-server, claude-desktop, semantic-memory, sqlite-vec, python, ai-tools"
        echo "3. Update repository description if needed"
        echo "4. Share your clean, professional MCP Memory Service!"
    else
        echo "❌ Error pushing to repository. Please check:"
        echo "1. Repository exists and you have access"
        echo "2. Repository URL is correct"
        echo "3. You're authenticated with GitHub"
    fi
else
    echo "Setup complete. Run 'git push -u origin main' when ready to push."
fi

echo ""
echo "✅ Repository setup complete!"