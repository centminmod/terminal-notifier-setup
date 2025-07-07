#!/bin/bash

# Claude Code Hooks Setup Script with terminal-notifier notifications
# Sets up proper Claude Code hooks for macOS desktop notifications

set -e

echo "🔧 Setting up Claude Code hooks with terminal-notifier..."

# Check if Homebrew is installed
if ! command -v brew &> /dev/null; then
    echo "❌ Homebrew not found. Please install Homebrew first:"
    echo "   /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
    exit 1
fi

# Check and install terminal-notifier
if ! command -v terminal-notifier &> /dev/null; then
    echo "📦 Installing terminal-notifier..."
    brew install terminal-notifier
    
    if [ $? -eq 0 ]; then
        echo "✅ terminal-notifier installed successfully"
    else
        echo "❌ Failed to install terminal-notifier"
        exit 1
    fi
else
    echo "✅ terminal-notifier already installed"
fi

# Create Claude Code config directory if it doesn't exist
CLAUDE_DIR="$HOME/.claude"
mkdir -p "$CLAUDE_DIR"

# Check if settings.json exists
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
if [ ! -f "$SETTINGS_FILE" ]; then
    echo "📄 Creating new Claude Code settings file..."
    echo '{}' > "$SETTINGS_FILE"
fi

# Backup existing settings
cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
echo "💾 Backup created: $SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"

# Read current settings and add hooks configuration
python3 -c "
import json
import sys

# Read existing settings
try:
    with open('$SETTINGS_FILE', 'r') as f:
        settings = json.load(f)
except (json.JSONDecodeError, FileNotFoundError):
    settings = {}

# Add hooks configuration
if 'hooks' not in settings:
    settings['hooks'] = {}

# Configure Stop event hook
settings['hooks']['Stop'] = [
    {
        'matcher': '*',
        'hooks': [
            {
                'type': 'command',
                'command': 'terminal-notifier -title \"Claude Code\" -subtitle \"Session Complete\" -message \"Finished working in \$(basename \"\$PWD\")\" -sound default -timeout 10'
            }
        ]
    }
]

# Write updated settings
with open('$SETTINGS_FILE', 'w') as f:
    json.dump(settings, f, indent=2)

print('✅ Claude Code hooks configuration added')
"

# Test the notification system
echo ""
echo "🧪 Testing notification system..."
terminal-notifier -title "Claude Code Setup" \
                 -subtitle "Setup Complete" \
                 -message "Your Claude Code hooks are now configured!" \
                 -sound "Glass" \
                 -timeout 5

echo ""
echo "🎉 Setup complete!"
echo ""
echo "📋 What was configured:"
echo "  • Claude Code hooks in ~/.claude/settings.json"
echo "  • Stop event notifications with terminal-notifier"
echo "  • Backup of your previous settings created"
echo ""
echo "🔔 How it works:"
echo "  • Notifications appear when Claude Code finishes any task"
echo "  • Shows project name (current directory) in the message"
echo "  • Plays default system sound"
echo "  • Works globally across all projects"
echo ""
echo "⚙️  Customization:"
echo "  • Edit ~/.claude/settings.json to customize notifications"
echo "  • Add project-specific hooks in <project>/.claude/settings.json"
echo "  • Change sounds: default, Glass, Basso, Blow, Bottle, Frog, Funk, etc."
echo ""
echo "🧪 Test it:"
echo "  • Run any claude-code command"
echo "  • You should see a notification when it completes"
echo ""
echo "📚 For more advanced configurations, check the README.md"