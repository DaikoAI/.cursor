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
    ├── cloudflare-worker.mdc              ├── cloudflare-worker.mdc
    ├── general.mdc                        ├── general.mdc
    ├── mermaid.mdc                        ├── mermaid.mdc
    ├── techstack.mdc                      ├── techstack.mdc
    ├── telegram.mdc                       ├── telegram.mdc
    ├── test.mdc                           ├── test.mdc
    └── typescript.mdc                     └── typescript.mdc
```

## Quick Start (Recommended)

**Install** (one command):

```bash
curl -fsSL https://raw.githubusercontent.com/DaikoAI/.cursor/main/scripts/cursor-config.sh | bash -s -- install
```

**Update** to latest:

```bash
curl -fsSL https://raw.githubusercontent.com/DaikoAI/.cursor/main/scripts/cursor-config.sh | bash -s -- update
```

This copies the shared configuration into your project's `.cursor/` directory and:

- Syncs `commands/` and `rules/` directories completely
- Applies upstream deletions automatically
- Preserves your project-specific files outside managed directories

After running install/update, review changes and commit:

```bash
git add .cursor
git commit -m "chore: sync cursor configuration"
```

### 💡 Pro Tip: Add Shell Aliases

Make syncing effortless by adding these to your `~/.zshrc` or `~/.bashrc`:

```bash
# Cursor config sync shortcuts
alias cursor-install='curl -fsSL https://raw.githubusercontent.com/DaikoAI/.cursor/main/scripts/cursor-config.sh | bash -s -- install'
alias cursor-update='curl -fsSL https://raw.githubusercontent.com/DaikoAI/.cursor/main/scripts/cursor-config.sh | bash -s -- update'
```

Then simply run:

```bash
cursor-update  # Stay in sync with team knowledge
```

## 🚀 Building an AI-Native Engineering Team

This shared configuration is more than just tooling—it's **team knowledge as code**.

### What's Inside

- **`commands/`**: Reusable AI workflows for spec-driven development, debugging, refactoring, and more
- **`rules/`**: Coding standards, architecture patterns, and context that guide AI to write code the way your team does

### Why It Matters

Traditional teams document standards in wikis that get outdated. **AI-native teams** encode knowledge directly into their development environment:

- ✅ **Consistency**: Every team member (and AI) follows the same patterns
- ✅ **Onboarding**: New engineers inherit team knowledge instantly
- ✅ **Evolution**: Update once, propagate everywhere
- ✅ **Velocity**: AI generates code that matches your standards from day one

### Keep It Fresh

This configuration evolves with your team. When you discover a better pattern or workflow:

1. Update this repository
2. Team members run `cursor-update`
3. Everyone benefits immediately

**The goal:** Build a living, breathing knowledge base that makes your entire team—human and AI—more effective every day.

## Alternative Installation Methods

### Method 1: Git Submodule

Best for pinning to specific versions. Since this repo is named `.cursor`, the submodule command naturally creates the correct folder structure.

**Install:**

```bash
git submodule add -b main https://github.com/DaikoAI/.cursor.git .cursor
git commit -m "chore: add shared cursor configuration"
```

**Update:**

```bash
git submodule update --remote --merge .cursor
git add .cursor
git commit -m "chore: update cursor configuration"
```

**Cloning a repo with submodules:**

```bash
git clone --recurse-submodules https://github.com/DaikoAI/your-repo.git

# Or if already cloned:
git submodule update --init --recursive
```

### Method 2: Git Subtree

Best for vendoring the configuration into your repo (no submodule dependencies).

> **Note:** `git subtree` is not installed by default on some systems.

**Install:**

```bash
git remote add cursor-config https://github.com/DaikoAI/.cursor.git
git fetch cursor-config
git subtree add --prefix=.cursor cursor-config main --squash
```

**Update:**

```bash
git fetch cursor-config
git subtree pull --prefix=.cursor cursor-config main --squash
```

### Method 3: Direct Clone

For one-time setup without tracking updates.

```bash
git clone https://github.com/DaikoAI/.cursor.git .cursor
rm -rf .cursor/.git
git add .cursor
git commit -m "chore: add shared cursor configuration"
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

To regenerate `commands/kiro/` (generated by `cc-sdd`):

```bash
npx cc-sdd@latest --cursor --lang ja
```

Changes will be available to all DaikoAI projects that sync with this repository.

## Related Documentation

- [Cursor IDE Documentation](https://cursor.sh/docs)
