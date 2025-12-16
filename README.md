# .cursor

Shared Cursor IDE configuration for the DaikoAI organization. This repository is named `.cursor` so that when cloned into a project, it creates the exact `.cursor/` directory structure that Cursor IDE expects.

## How It Works

This repository's root directory maps directly to your project's `.cursor/` folder:

```
DaikoAI/.cursor (this repo)     →     your-project/.cursor/
├── commands/                          ├── commands/
│   ├── kiro/                          │   ├── kiro/
│   │   ├── spec-init.md               │   │   ├── spec-init.md
│   │   ├── spec-requirements.md       │   │   ├── spec-requirements.md
│   │   ├── spec-design.md             │   │   ├── spec-design.md
│   │   ├── spec-tasks.md              │   │   ├── spec-tasks.md
│   │   ├── spec-impl.md               │   │   ├── spec-impl.md
│   │   ├── spec-status.md             │   │   ├── spec-status.md
│   │   ├── steering.md                │   │   ├── steering.md
│   │   ├── steering-custom.md         │   │   ├── steering-custom.md
│   │   ├── validate-design.md         │   │   ├── validate-design.md
│   │   ├── validate-gap.md            │   │   ├── validate-gap.md
│   │   └── validate-impl.md           │   │   └── validate-impl.md
│   ├── bug-fix.md                     │   ├── bug-fix.md
│   ├── check-script.md                │   ├── check-script.md
│   ├── check-simirarity.md            │   ├── check-simirarity.md
│   ├── commit.md                      │   ├── commit.md
│   ├── final-check.md                 │   ├── final-check.md
│   ├── linear.md                      │   ├── linear.md
│   ├── refactor.md                    │   ├── refactor.md
│   └── understand.md                  │   └── understand.md
└── rules/                             └── rules/
    ├── agents-architecture.md             ├── agents-architecture.md
    ├── cloudflare-worker.mdc              ├── cloudflare-worker.mdc
    ├── general.mdc                        ├── general.mdc
    ├── mermaid.mdc                        ├── mermaid.mdc
    ├── onboarding-flow.md                 ├── onboarding-flow.md
    ├── techstack.mdc                      ├── techstack.mdc
    ├── telegram.mdc                       ├── telegram.mdc
    ├── test.mdc                           ├── test.mdc
    └── typescript.mdc                     └── typescript.mdc
```

## Installation

Choose one of the following methods to add this configuration to your project. Replace `<branch>` with the default branch name (check the repository's default branch on GitHub).

### Method 1: Git Submodule (Recommended)

Best for pinning to specific versions and easy updates. Since this repo is named `.cursor`, the submodule command naturally creates the correct folder structure.

```bash
cd /path/to/your-repo

# Add as submodule - creates .cursor/ directory automatically
git submodule add https://github.com/DaikoAI/.cursor.git .cursor

git commit -m "chore: add shared cursor configuration"
```

**Updating to latest:**

```bash
cd .cursor
git pull origin <branch>
cd ..
git commit -am "chore: update cursor configuration"
```

**Cloning a repo with submodules:**

```bash
git clone --recurse-submodules https://github.com/DaikoAI/your-repo.git

# Or if already cloned:
git submodule update --init --recursive
```

### Method 2: Git Subtree

Best for vendoring the configuration into your repo (no submodule dependencies).

```bash
cd /path/to/your-repo

# Add remote
git remote add cursor-config https://github.com/DaikoAI/.cursor.git
git fetch cursor-config

# Import as subtree - repo root becomes .cursor/
git subtree add --prefix=.cursor cursor-config <branch> --squash
```

**Pulling updates:**

```bash
git fetch cursor-config
git subtree pull --prefix=.cursor cursor-config <branch> --squash
```

### Method 3: Direct Clone

For one-time setup without tracking updates. Be careful not to create nested `.cursor/.cursor/` directories.

```bash
cd /path/to/your-repo

# Clone directly as .cursor folder
git clone https://github.com/DaikoAI/.cursor.git .cursor

# Remove git history to make it a regular folder
rm -rf .cursor/.git

git add .cursor
git commit -m "chore: add shared cursor configuration"
```

### Method 4: Sync Script

For automated syncing without git submodules/subtrees:

```bash
#!/bin/bash
# scripts/sync-cursor-config.sh

REPO_URL="https://github.com/DaikoAI/.cursor.git"
TEMP_DIR=$(mktemp -d)

echo "Fetching latest cursor configuration..."
git clone --depth 1 "$REPO_URL" "$TEMP_DIR"

echo "Syncing to .cursor/..."
mkdir -p .cursor
rm -rf .cursor/commands .cursor/rules
cp -r "$TEMP_DIR/commands" .cursor/
cp -r "$TEMP_DIR/rules" .cursor/

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Done! Run 'git add .cursor && git commit' to save changes."
```

## Customization

After installation, customize for your project:

- **Tech Stack**: Update `rules/techstack.mdc` with your project's dependencies and documentation links
- **Project Rules**: Add new `.mdc` files in `rules/` for project-specific conventions
- **Custom Commands**: Add project-specific commands in `commands/`

## Contributing

1. Clone this repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

Changes will be available to all DaikoAI projects that sync with this repository.

## Related Documentation

- [Cursor IDE Documentation](https://cursor.sh/docs)
