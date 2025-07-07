# Claude Code Hooks with Terminal Notifications 🔔

Get macOS desktop notifications when Claude Code finishes working using the official Claude Code hooks feature.

![Claude Code Hooks](https://img.shields.io/badge/Claude%20Code-Hooks-blue?logo=anthropic&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-Compatible-blue?logo=apple&logoColor=white)
![Terminal Notifier](https://img.shields.io/badge/terminal--notifier-Required-green)

## 🎯 What This Does

This setup configures **Claude Code hooks** to send native macOS notifications when Claude Code completes any task. No wrapper scripts, no complexity—just proper integration with Claude Code's official hooks system.

### ✨ Features

- 🔔 **Native macOS notifications** when Claude Code stops
- 📂 **Project context** included in notifications
- 🎵 **Customizable sounds** (default, Glass, Basso, etc.)
- 🌍 **Global setup** works across all projects
- 🎯 **Per-project customization** available
- 📦 **Simple one-script setup**

## 🚀 Quick Setup

### Prerequisites

- macOS with [Homebrew](https://brew.sh) installed
- [Claude Code](https://claude.ai/code) CLI tool
- Terminal access

### Installation

1. **Clone this repository**:
   ```bash
   git clone https://github.com/centminmod/terminal-notifier-setup.git
   cd terminal-notifier-setup
   ```

2. **Run the setup script**:
   ```bash
   chmod +x terminal_notifier_setup.sh
   ./terminal_notifier_setup.sh
   ```

That's it! 🎉

## 📋 What The Setup Does

1. **Installs terminal-notifier** via Homebrew (if not already installed)
2. **Creates/updates** `~/.claude/settings.json` with hooks configuration
3. **Backs up** your existing settings
4. **Tests** the notification system
5. **Provides** customization guidance

## 🔔 How It Works

### User-Level Hooks (Global)

The setup configures a **Stop** event hook in `~/.claude/settings.json`:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title \"Claude Code\" -subtitle \"Session Complete\" -message \"Finished working in $(basename \"$PWD\")\" -sound default -timeout 10"
          }
        ]
      }
    ]
  }
}
```

This hook:
- Triggers when **any** Claude Code session completes
- Shows the **project name** (current directory) in the notification
- Plays the **default system sound**
- Works in **all projects** automatically

## ⚙️ Customization

### Change Notification Sound

Edit `~/.claude/settings.json` and modify the `sound` parameter:

```json
"command": "terminal-notifier -title \"Claude Code\" -subtitle \"Session Complete\" -message \"Finished working in $(basename \"$PWD\")\" -sound Glass -timeout 10"
```

**Available sounds**: default, Basso, Blow, Bottle, Frog, Funk, Glass, Hero, Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink

### Change Notification Message

Customize the title, subtitle, and message:

```json
"command": "terminal-notifier -title \"🤖 Claude\" -subtitle \"Task Done\" -message \"Completed work in $(basename \"$PWD\")\" -sound Glass -timeout 10"
```

### Add Notification Timeout

Make notifications disappear after a specific time:

```json
"command": "terminal-notifier -title \"Claude Code\" -subtitle \"Session Complete\" -message \"Finished working in $(basename \"$PWD\")\" -sound default -timeout 10"
```

## 🎯 Per-Project Notifications

For **project-specific** notifications, create `.claude/settings.json` in your project directory:

```bash
# In your project directory
mkdir -p .claude
cat > .claude/settings.json << 'EOF'
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title \"My Project\" -subtitle \"Build Complete\" -message \"Finished working on $(basename \"$PWD\")\" -sound Glass -timeout 10"
          }
        ]
      }
    ]
  }
}
EOF
```

Project-level hooks **override** user-level hooks for that specific project.

## 📚 Advanced Examples

### Multiple Hook Types

You can set up hooks for different Claude Code events:

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title \"Claude Code\" -subtitle \"Session Complete\" -message \"Finished working in $(basename \"$PWD\")\" -sound default -timeout 10"
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "terminal-notifier -title \"Claude Code\" -subtitle \"Running Command\" -message \"Executing bash command...\" -sound Purr -timeout 3"
          }
        ]
      }
    ]
  }
}
```

### Conditional Notifications

Use shell conditionals for smarter notifications:

```json
{
  "type": "command",
  "command": "if [ -f package.json ]; then terminal-notifier -title \"Node.js Project\" -message \"Claude finished working on $(basename \"$PWD\")\" -sound Glass -timeout 10; else terminal-notifier -title \"Claude Code\" -message \"Finished working in $(basename \"$PWD\")\" -sound default -timeout 10; fi"
}
```

## 🔧 Troubleshooting

### Notifications Not Appearing

1. **Check System Preferences** → Notifications
2. **Grant terminal-notifier permission** to send notifications
3. **Test manually**: `terminal-notifier -message "Test"`

### Settings Not Taking Effect

1. **Restart Claude Code** after changing settings
2. **Check JSON syntax** in your settings file
3. **Verify file path**: `~/.claude/settings.json`

### Command Not Found

If you get "command not found" errors, ensure terminal-notifier is installed:

```bash
brew install terminal-notifier
```

### Permission Denied

Make sure the setup script is executable:

```bash
chmod +x terminal_notifier_setup.sh
```

## 🔍 Understanding Claude Code Hooks

Claude Code hooks are **event-driven commands** that execute at specific points in Claude's lifecycle:

- **PreToolUse**: Before Claude uses a tool
- **PostToolUse**: After Claude uses a tool  
- **Stop**: When Claude finishes responding
- **Notification**: On Claude Code notifications

Hooks are configured in:
- `~/.claude/settings.json` (user-level, applies globally)
- `<project>/.claude/settings.json` (project-level, applies to that project only)

## 📖 Learn More

- [Claude Code Hooks Documentation](https://docs.anthropic.com/en/docs/claude-code/hooks)
- [terminal-notifier GitHub](https://github.com/julienXX/terminal-notifier)
- [Claude Code CLI Reference](https://docs.anthropic.com/en/docs/claude-code/cli-reference)

## 🤝 Contributing

1. Fork this repository
2. Create a feature branch
3. Make your changes
4. Test on macOS
5. Submit a pull request

## 📝 License

MIT License - see LICENSE file for details.