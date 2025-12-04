# Contributing to Docker Toolbox

Thank you for considering contributing to Docker Toolbox! This document provides guidelines and instructions for contributing.

## Table of Contents

- [Ways to Contribute](#ways-to-contribute)
- [Getting Started](#getting-started)
- [Adding a New Tool](#adding-a-new-tool)
- [Contribution Standards](#contribution-standards)
- [Testing Your Changes](#testing-your-changes)
- [Submitting Changes](#submitting-changes)
- [Style Guide](#style-guide)
- [Questions or Problems](#questions-or-problems)

## Ways to Contribute

There are many ways to contribute to Docker Toolbox:

### 1. Add New Tools
Add Docker commands for tools not yet in the collection. Great candidates:
- Popular development tools
- CLI utilities developers use frequently
- Tools with official Docker images
- Cross-platform tools that are hard to install natively

### 2. Improve Existing Tools
- Suggest better Docker images (more official, smaller, faster)
- Add missing command examples
- Improve existing documentation
- Fix broken commands or outdated versions

### 3. Documentation
- Fix typos and grammatical errors
- Clarify confusing instructions
- Add more usage examples
- Document edge cases or workarounds
- Improve platform-specific instructions

### 4. Report Issues
- Tools that don't work as expected
- Missing information in documentation
- Platform-specific problems
- Limitations or edge cases

## Getting Started

1. **Fork the repository** on GitHub
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/docker-toolbox.git
   cd docker-toolbox
   ```
3. **Create a feature branch**:
   ```bash
   git checkout -b feature/add-tool-name
   # or
   git checkout -b fix/issue-description
   ```

## Adding a New Tool

### Step 1: Find a Suitable Docker Image

Look for official or well-maintained Docker images:
- Check [Docker Hub](https://hub.docker.com/)
- Check [GitHub Container Registry](https://github.com/features/packages)
- Prefer official images when available
- Check image size and update frequency
- Verify the image works on multiple platforms

### Step 2: Test the Docker Command

Test your Docker command thoroughly:

```bash
# Example: Testing a new tool
docker run --rm -v ${PWD}:/work tool-image:version command

# Test with actual files
docker run --rm -v ${PWD}:/work tool-image:version --help

# Test interactive mode if applicable
docker run --rm -it -v ${PWD}:/work tool-image:version
```

### Step 3: Add to docker-dev-tools.md

Add your tool following the existing format:

```markdown
### Tool Name
Brief description of what the tool does.

​```bash
# Example usage 1
docker run --rm -v ${PWD}:/workdir tool-image:version command

# Example usage 2 (if applicable)
docker run --rm -it -v ${PWD}:/workdir tool-image:version interactive-mode

# Common use case
docker run --rm -v ${PWD}:/workdir tool-image:version --help
​```

**Aliases:**
​```bash
# Linux/macOS
alias toolname='docker run --rm -v ${PWD}:/workdir tool-image:version'

# PowerShell
function toolname { docker run --rm -v ${PWD}:/workdir tool-image:version $args }
​```

---
```

### Step 4: Add to Table of Contents

Update the Table of Contents in `docker-dev-tools.md` if adding to an existing category, or create a new category if needed.

### Step 5: Update README.md

If you're adding a new category or a particularly significant tool, update the feature table in README.md.

## Contribution Standards

### Required Elements

Every tool entry must include:
1. **Tool name as heading** (`### Tool Name`)
2. **Brief description** (one sentence explaining what it does)
3. **At least 2 usage examples** showing common use cases
4. **Aliases** for both Linux/macOS and Windows PowerShell
5. **Separator** (`---`) at the end

### Docker Command Guidelines

- **Use `--rm` flag** to auto-remove containers
- **Use `-v ${PWD}:/workdir`** for volume mounts (adjust path as needed)
- **Use `-w /workdir`** to set working directory when needed
- **Use `-it` flags** for interactive tools
- **Pin version tags** (e.g., `python:3.12` not `python:latest`)
- **Use specific tags** for reproducibility

### Image Selection Criteria

Prefer Docker images that are:
- Official images from the tool maintainers
- Regularly updated
- Well documented
- Reasonable size (< 2GB if possible)
- Multi-platform (amd64, arm64)

### Alias Guidelines

- **Linux/macOS aliases** should use `${PWD}` for current directory
- **PowerShell functions** should use `${PWD}` and `$args` for arguments
- **Prefix aliases** with `d` if there's a native command conflict (e.g., `dpy` for Python)
- **Keep aliases simple** and memorable

## Testing Your Changes

### Test on Your Platform

At minimum, test on your own platform:

```bash
# Test the raw Docker command
docker run --rm -v ${PWD}:/workdir tool-image:version --help

# Test with a real file/project
docker run --rm -v ${PWD}:/workdir tool-image:version actual-command

# Test the alias (after setting it up)
source ~/.bashrc  # or reload your shell
toolname --help
```

### Cross-Platform Testing (Optional but Appreciated)

If you have access to multiple platforms, test on:
- Linux (Ubuntu/Debian)
- macOS
- Windows (PowerShell)

### What to Verify

- [ ] Command runs without errors
- [ ] Volume mount works correctly
- [ ] Output is displayed properly
- [ ] Interactive mode works (if applicable)
- [ ] Aliases work as expected
- [ ] No unintended side effects (file permissions, etc.)

## Submitting Changes

### Before Submitting

- [ ] Test your Docker commands
- [ ] Follow the existing format
- [ ] Check for typos and grammar
- [ ] Verify all links work
- [ ] Update table of contents if needed
- [ ] Test aliases on your platform

### Commit Message Format

Use clear, descriptive commit messages:

```bash
# Good examples:
git commit -m "Add Deno runtime to Programming Languages section"
git commit -m "Fix PostgreSQL connection example"
git commit -m "Update Node.js to version 22"
git commit -m "Improve documentation for Windows users"

# Avoid vague messages:
git commit -m "Update file"
git commit -m "Fix stuff"
git commit -m "Changes"
```

### Creating a Pull Request

1. **Push to your fork**:
   ```bash
   git push origin feature/add-tool-name
   ```

2. **Open a Pull Request** on GitHub with:
   - **Clear title**: "Add [Tool Name] to [Category]"
   - **Description** including:
     - What tool you added/changed
     - Why it's useful
     - What you tested
     - Any limitations or notes

3. **Example PR description**:
   ```markdown
   ## Summary
   Adds Deno runtime to the Programming Languages section.

   ## Changes
   - Added Deno Docker commands with examples
   - Added aliases for Linux/macOS and PowerShell
   - Updated table of contents

   ## Testing
   - Tested on macOS with Deno 1.40
   - Verified volume mounts work correctly
   - Tested both script execution and REPL

   ## Notes
   Using official `denoland/deno` image which is ~100MB
   ```

## Style Guide

### Formatting

- Use **markdown formatting** consistently
- Use `code blocks` for commands and code
- Use **bold** for emphasis on important terms
- Use proper heading levels (### for tools, ## for categories)

### Writing Style

- Be concise and clear
- Use imperative mood for commands ("Run", "Execute", not "Running", "Executes")
- Provide context when needed
- Include examples that show real-world usage
- Assume basic Docker knowledge but explain non-obvious flags

### Example Documentation Style

```markdown
### ToolName
Brief, clear description of what it does (one line).

​```bash
# Common use case - explain what this does
docker run --rm -v ${PWD}:/work image:tag command

# Another use case - explain the difference
docker run --rm -it -v ${PWD}:/work image:tag interactive-mode
​```

**Aliases:**
​```bash
# Linux/macOS
alias name='docker run --rm -v ${PWD}:/work image:tag'

# PowerShell
function name { docker run --rm -v ${PWD}:/work image:tag $args }
​```
```

## Code of Conduct

### Our Standards

- Be respectful and considerate
- Welcome newcomers and beginners
- Accept constructive criticism gracefully
- Focus on what's best for the community
- Show empathy towards others

### Unacceptable Behavior

- Harassment or discriminatory language
- Trolling or insulting comments
- Personal or political attacks
- Publishing others' private information
- Other conduct inappropriate in a professional setting

## Questions or Problems?

### Getting Help

- **Documentation issues**: Open an issue describing what's unclear
- **Tool not working**: Open an issue with:
  - Your platform (OS, Docker version)
  - The command you tried
  - The error message
  - What you expected to happen

### Discussion

- Open an issue for feature requests
- Start a discussion for broader topics
- Ask questions in issues

## License

By contributing, you agree that your contributions will be licensed under the same MIT License that covers this project.

---

Thank you for contributing to Docker Toolbox! Your efforts help developers worldwide work more efficiently.
