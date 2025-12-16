# DaikoAI Cursor Configuration

This repository contains shared Cursor IDE configuration files for the DaikoAI organization. It includes commands, rules, and workflows that can be used across all DaikoAI projects.

## Repository Structure

```
.cursor/
├── commands/           # Cursor slash commands
│   ├── kiro/          # Kiro spec-driven development workflow
│   │   ├── spec-init.md
│   │   ├── spec-requirements.md
│   │   ├── spec-design.md
│   │   ├── spec-tasks.md
│   │   ├── spec-impl.md
│   │   ├── spec-status.md
│   │   ├── steering.md
│   │   ├── steering-custom.md
│   │   ├── validate-design.md
│   │   ├── validate-gap.md
│   │   └── validate-impl.md
│   ├── bug-fix.md
│   ├── check-script.md
│   ├── check-simirarity.md
│   ├── commit.md
│   ├── final-check.md
│   ├── linear.md
│   ├── refactor.md
│   └── understand.md
└── rules/              # Cursor rules for AI assistance
    ├── agents-architecture.md
    ├── cloudflare-worker.mdc
    ├── general.mdc
    ├── mermaid.mdc
    ├── onboarding-flow.md
    ├── techstack.mdc
    ├── telegram.mdc
    ├── test.mdc
    └── typescript.mdc
```

## Migrating to a New Repository

There are several ways to add this shared Cursor configuration to a new repository in the DaikoAI organization.

### Method 1: Using Git Subtree (Recommended)

Git subtree allows you to include this repository as a subdirectory while keeping the ability to pull updates.

#### Initial Setup

```bash
# Navigate to your target repository
cd /path/to/your-repo

# Add this repository as a remote
git remote add cursor-config https://github.com/DaikoAI/.cursor.git

# Fetch the remote
git fetch cursor-config

# Add the subtree (this will create the .cursor directory)
git subtree add --prefix=.cursor cursor-config main --squash
```

#### Pulling Updates

When this shared configuration is updated, you can pull the changes:

```bash
git fetch cursor-config
git subtree pull --prefix=.cursor cursor-config main --squash
```

### Method 2: Using Git Submodule

Git submodules keep a reference to this repository at a specific commit.

#### Initial Setup

```bash
# Navigate to your target repository
cd /path/to/your-repo

# Add as a submodule
git submodule add https://github.com/DaikoAI/.cursor.git .cursor

# Commit the submodule reference
git commit -m "chore: add shared cursor configuration as submodule"
```

#### Pulling Updates

```bash
# Update the submodule to the latest commit
cd .cursor
git pull origin main
cd ..

# Commit the updated reference
git commit -am "chore: update cursor configuration submodule"
```

#### Cloning a Repository with Submodules

When cloning a repository that uses submodules:

```bash
git clone --recurse-submodules https://github.com/DaikoAI/your-repo.git

# Or if already cloned without submodules:
git submodule update --init --recursive
```

### Method 3: Direct Copy (Simple but Manual)

For a one-time setup without automatic updates:

```bash
# Navigate to your target repository
cd /path/to/your-repo

# Clone this repository temporarily
git clone https://github.com/DaikoAI/.cursor.git temp-cursor

# Copy the contents (excluding .git)
cp -r temp-cursor/commands .cursor/commands
cp -r temp-cursor/rules .cursor/rules

# Clean up
rm -rf temp-cursor

# Add and commit
git add .cursor
git commit -m "chore: add shared cursor configuration"
```

### Method 4: Using a Script

Create a script in your repository to automate the sync process:

```bash
#!/bin/bash
# sync-cursor-config.sh

REPO_URL="https://github.com/DaikoAI/.cursor.git"
TEMP_DIR=$(mktemp -d)

echo "Fetching latest cursor configuration..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR"

echo "Syncing configuration..."
rm -rf .cursor/commands .cursor/rules
cp -r "$TEMP_DIR/commands" .cursor/
cp -r "$TEMP_DIR/rules" .cursor/

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Done! Don't forget to commit the changes."
```

## Customizing for Your Project

After migrating, you may want to customize certain rules for your specific project:

1. **Tech Stack Rules**: Update `rules/techstack.mdc` to reflect your project's specific dependencies and documentation links.

2. **Project-Specific Rules**: Add new `.mdc` files in the `rules/` directory for project-specific conventions.

3. **Custom Commands**: Add project-specific commands in the `commands/` directory.

## Contributing

To contribute improvements to the shared configuration:

1. Clone this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Changes will be available to all DaikoAI projects that sync with this repository.

## Related Documentation

- [Cursor IDE Documentation](https://cursor.sh/docs)
- [Kiro Spec-Driven Development](./commands/kiro/README.md)
