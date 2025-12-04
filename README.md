# Docker Toolbox

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Required-2496ED?logo=docker&logoColor=white)](https://www.docker.com/)
[![Platform](https://img.shields.io/badge/Platform-Linux%20%7C%20macOS%20%7C%20Windows-lightgrey)](https://github.com/yourusername/docker-toolbox)
[![Tools](https://img.shields.io/badge/Tools-100%2B-brightgreen)](docker-dev-tools.md)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

> Run 100+ development tools via Docker without installing them locally

A curated collection of Docker commands and aliases to run popular development tools without local installation. Perfect for developers who want a clean system while maintaining access to every tool they need.

```
    ____             __                ______            __ __
   / __ \____  _____/ /_____  _____   /_  __/___  ____  / / /_  ____  _  __
  / / / / __ \/ ___/ //_/ _ \/ ___/    / / / __ \/ __ \/ / __ \/ __ \| |/_/
 / /_/ / /_/ / /__/ ,< /  __/ /       / / / /_/ / /_/ / / /_/ / /_/ />  <
/_____/\____/\___/_/|_|\___/_/       /_/  \____/\____/_/_.___/\____/_/|_|
```

## Why Docker Toolbox?

**The Problem:**
Installing development tools directly on your system leads to:
- Version conflicts between projects
- Bloated system with rarely-used tools
- Complex setup procedures
- Different installation methods across operating systems
- Dependency hell and conflicting requirements

**The Solution:**
Docker Toolbox provides ready-to-use Docker commands for 100+ development tools:
- **No local installation** required (just Docker)
- **Consistent behavior** across Linux, macOS, and Windows
- **Isolated environments** prevent conflicts
- **Easy to try** new tools without commitment
- **Clean uninstall** - just remove the container
- **Version pinning** for reproducible environments

## What's Inside?

### 100+ Tools Across 15 Categories

| Category | Tools |
|----------|-------|
| **Build & Task Runners** | just, Make |
| **Static Site Generators** | Jekyll, Hugo, MkDocs |
| **Terminal Tools** | tmux, htop, ncdu, lazygit, lazydocker, ranger, fzf, bat, ripgrep, fd, jq, yq |
| **Programming Languages** | Python, Jupyter Notebook, Node.js, Go, Rust, Ruby |
| **Development Environments** | VS Code Server, RStudio |
| **Testing Tools** | Playwright |
| **Databases** | PostgreSQL, MySQL, Redis, MongoDB |
| **Message Brokers & IoT** | Mosquitto (MQTT), MQTT Explorer |
| **DevOps & Cloud** | AWS CLI, Azure CLI, Google Cloud, Terraform, Ansible, kubectl, Helm |
| **Code Quality** | Prettier, Black, ShellCheck, hadolint, markdownlint |
| **Media & Documents** | Pandoc, FFmpeg, ImageMagick, yt-dlp |
| **Networking & Security** | nmap, curl, Trivy, testssl |
| **API Development** | Swagger UI, HTTPie, Newman |
| **Git Tools** | git, GitHub CLI |

See [docker-dev-tools.md](docker-dev-tools.md) for the complete list with usage examples.

---

## Quick Start

### Prerequisites

- [Docker](https://docs.docker.com/get-docker/) installed and running
- Basic familiarity with command line

### Example Usage

```bash
# Run Python script without installing Python
docker run --rm -v ${PWD}:/app -w /app python:3.12 python script.py

# Start Jupyter Notebook for data science
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook

# Start VS Code in browser
docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none

# Run MQTT broker for IoT
docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto

# Format code with Prettier
docker run --rm -v ${PWD}:/work tmknom/prettier --write .

# Run Node.js application
docker run --rm -v ${PWD}:/app -w /app node:22 node app.js

# Search code with ripgrep
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg -i 'TODO'"

# Run Playwright tests
docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test
```

### Using Aliases (Recommended)

Instead of typing long Docker commands, set up aliases.

**💡 Pro Tip:** Use the `dt-` prefix (Docker Tools) to avoid conflicts with natively installed tools!

#### Linux / macOS (Bash/Zsh)

Add to `~/.bashrc` or `~/.zshrc`:

```bash
# Recommended: with dt- prefix (no conflicts!)
alias dt-python='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python'
alias dt-node='docker run --rm -it -v ${PWD}:/app -w /app node:22 node'
alias dt-jupyter='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook'
alias dt-rg='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg"'
```

Then reload: `source ~/.bashrc`

Usage: `dt-python script.py`, `dt-node app.js`, `dt-jupyter`

#### Windows PowerShell

Add to your PowerShell profile (`notepad $PROFILE`):

```powershell
# Recommended: with dt- prefix (no conflicts!)
function dt-python { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python $args }
function dt-node { docker run --rm -it -v ${PWD}:/app -w /app node:22 node $args }
function dt-jupyter { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook }
function dt-rg { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg $args" }
```

**Important:** Save the file, then reload: `. $PROFILE` (or restart PowerShell)

**Note:** Functions in PowerShell are temporary unless added to your profile file. The profile persists across sessions.

Usage: `dt-python script.py`, `dt-node app.js`, `dt-jupyter`

---

## Limitations

### Known Constraints

**1. Performance Overhead**
- First run downloads images (can be slow depending on internet)
- Container startup adds ~0.5-1 second overhead
- I/O operations slightly slower than native

**2. File System Access**
- Only mounted directories are accessible
- Can't access files outside mounted volumes
- Windows path handling requires special attention
- File permissions may differ from host

**3. Networking**
- Use `host.docker.internal` to reach host services (from inside container)
- Port mapping required for server applications
- VPN/proxy configurations may need adjustments
- Some tools need `--network host` flag

**4. Interactive Applications**
- Some TUI apps have terminal size detection issues
- Keyboard shortcuts might be captured by terminal emulator
- Copy/paste behavior may vary

**5. Credentials & Configuration**
- Must explicitly mount config directories (e.g., `~/.aws`, `~/.kube`, `~/.ssh`)
- SSH keys need explicit mounting and permission fixes
- Environment variables must be passed with `-e` flag

**6. Platform-Specific Issues**
- **Windows**: Must use PowerShell or Git Bash for `${PWD}` variable
- **Windows**: Path format differences (`C:\` vs `/`)
- **macOS**: Filesystem performance can be slower with volumes
- **Linux**: User ID mapping may cause permission issues

**7. Resource Usage**
- Each container uses memory (10-100MB typical)
- Docker images consume disk space (50MB-2GB per tool)
- Need to run `docker system prune` periodically for cleanup

### When NOT to Use Docker Toolbox

- Performance-critical applications (use native installation)
- Tools requiring deep system integration (kernel modules, etc.)
- GUI applications (Docker primarily for CLI tools)
- Tools needing real-time performance
- Complex volume mount scenarios
- When you need the tool frequently (better to install natively)

---

## Installation

### Option 1: Use Directly (No Installation)

Just run the Docker commands directly from [docker-dev-tools.md](docker-dev-tools.md). No installation needed.

### Option 2: Quick Install Script (Linux/macOS)

Use our automated installer to set up aliases:

```bash
curl -fsSL https://raw.githubusercontent.com/yourusername/docker-toolbox/main/install.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/yourusername/docker-toolbox.git
cd docker-toolbox
./install.sh
```

The script will:
- Detect your shell (bash/zsh)
- Let you choose which tools to install
- Backup your config file
- Add aliases automatically

### Option 3: Manual Alias Setup

1. Browse [docker-dev-tools.md](docker-dev-tools.md)
2. Copy the aliases for tools you need
3. Add to your shell config file:
   - Linux/macOS: `~/.bashrc` or `~/.zshrc`
   - Windows: PowerShell profile (`$PROFILE`)
4. Reload your shell

### Option 4: Clone & Browse

```bash
git clone https://github.com/yourusername/docker-toolbox.git
cd docker-toolbox

# Browse documentation
cat docker-dev-tools.md
```

---

## Contributing

We welcome contributions! Whether it's adding new tools, improving documentation, or fixing bugs.

### How to Contribute

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/add-new-tool
   ```
3. **Add your tool** to `docker-dev-tools.md` following the existing format:
   - Tool description
   - Docker command examples
   - Aliases for Linux/macOS and PowerShell
4. **Test your commands** on your platform
5. **Submit a pull request** with a clear description

### Contribution Guidelines

- **Follow the existing format** for consistency
- **Use official Docker images** when available
- **Include both Linux/macOS and PowerShell** aliases
- **Test commands** before submitting
- **Add to table of contents** if creating a new category
- **Pin version tags** (e.g., `python:3.12` instead of `python:latest`)
- **Keep descriptions concise** and informative

### What to Contribute

- **New tools**: Add tools not yet in the collection
- **Better Docker images**: Suggest more efficient/official images
- **Platform-specific fixes**: Improve Windows/macOS/Linux compatibility
- **Documentation**: Clarify usage, add examples, fix typos
- **Limitations**: Document edge cases or workarounds

---

## Tips & Best Practices

1. **Pre-pull images** to avoid delays during first use:
   ```bash
   docker pull python:3.12
   docker pull node:22
   docker pull postgres:16
   ```

2. **Use specific version tags** for reproducibility:
   - Good: `python:3.12`, `node:22`, `postgres:16`
   - Avoid: `python:latest`, `node:latest`

3. **The `--rm` flag** automatically removes containers after use (keeps things clean)

4. **Interactive mode** (`-it` flags) needed for REPLs, shells, and TUI apps

5. **Volume mounts** (`-v ${PWD}:/app`) share your current directory with container

6. **Clean up periodically**:
   ```bash
   # Remove stopped containers
   docker container prune

   # Remove unused images
   docker image prune

   # Remove everything unused
   docker system prune -a
   ```

7. **Create project-specific alias files** that your team can share

8. **Check disk usage**:
   ```bash
   docker system df
   ```

---

## Troubleshooting

### Common Issues

**Command not found / Permission denied**
- Ensure Docker is running
- Check Docker is in your PATH
- On Linux, add user to docker group: `sudo usermod -aG docker $USER`

**Volume mount doesn't work**
- Windows: Use PowerShell or Git Bash
- Check path format matches your OS
- Verify directory exists

**Can't access host services from container**
- Use `host.docker.internal` as hostname
- Example: `psql -h host.docker.internal -U postgres`

**Image pull is slow**
- Normal for first time (images can be 100MB-2GB)
- Consider pre-pulling images you'll use frequently

**Permission issues on Linux**
- Add `--user $(id -u):$(id -g)` to Docker commands
- Example: `docker run --rm --user $(id -u):$(id -g) -v ${PWD}:/app python:3.12 python script.py`

---

## Star History

If you find this project useful, please consider giving it a star! It helps others discover the project.

[![Star History Chart](https://api.star-history.com/svg?repos=yourusername/docker-toolbox&type=Date)](https://star-history.com/#yourusername/docker-toolbox&Date)

---

## Documentation

- **[docker-dev-tools.md](docker-dev-tools.md)** - Complete reference with all tools and examples
- **[CONTRIBUTING.md](CONTRIBUTING.md)** - Detailed contribution guidelines

---

## License

MIT License - Feel free to use, modify, and distribute.

## Acknowledgments

Thanks to:
- All the Docker image maintainers
- The open-source community
- Contributors who add new tools and improvements

---

<div align="center">

**Found this useful?** [⭐ Star the repo](https://github.com/yourusername/docker-toolbox) and share it with your team!

**Have a tool to add?** [PRs welcome!](CONTRIBUTING.md)

**Found a bug?** [Open an issue](https://github.com/yourusername/docker-toolbox/issues)

Made with ❤️ by the community

</div>
