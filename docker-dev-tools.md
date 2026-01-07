# Docker Commands for Development Tools

Run popular development tools without installing them locally. Just Docker required.

---

## ⚠️ Important Notice

**Use at Your Own Risk**

- ✅ We prioritize **official Docker images** from verified publishers
- ✅ Commands are **tested** but your environment may differ
- ⚠️ **Verify tools** meet your security requirements before use
- ⚠️ Review **volume mounts** (`-v`) to understand file access
- ⚠️ Check **official documentation** for complete options and details

**By using these commands, you acknowledge the risks and agree to verify tools independently.**

For detailed security considerations, see the [main README](README.md#important-notice).

---

## Table of Contents

- [⚠️ Important Notice](#️-important-notice)
- [Alias Setup Instructions](#alias-setup-instructions)
- [Build & Task Runners](#build--task-runners) - just, Make
- [Static Site Generators](#static-site-generators) - Jekyll, Hugo, MkDocs
- [Terminal Tools](#terminal-tools) - tmux, htop, ncdu, lazygit, lazydocker, ranger, fzf, bat, ripgrep, fd, jq, yq
- [Programming Languages](#programming-languages) - Python, Jupyter Notebook, Node.js, Go, Rust, Ruby
- [Development Environments & IDEs](#development-environments--ides) - VS Code Server, RStudio, Vert, Node-RED, n8n
- [Testing Tools](#testing-tools) - Playwright
- [Databases](#databases) - PostgreSQL, MySQL, Redis, MongoDB, InfluxDB, NocoDB
- [Monitoring & Visualization](#monitoring--visualization) - Grafana, Uptime Kuma, Dozzle
- [Message Brokers & IoT](#message-brokers--iot) - Mosquitto (MQTT), MQTT Explorer
- [DevOps & Cloud CLI](#devops--cloud-cli) - AWS CLI, Azure CLI, Google Cloud, LocalStack, Terraform, Vault, Ansible, kubectl, Helm
- [Code Quality & Linting](#code-quality--linting) - Prettier, Black, ShellCheck, hadolint, markdownlint
- [Media & Documents](#media--documents) - Pandoc, FFmpeg, ImageMagick, yt-dlp, Typst, LaTeX
- [Networking & Security](#networking--security) - nmap, Caddy, curl, Trivy, testssl, Vaultwarden
- [API Development](#api-development) - Swagger UI, HTTPie, Newman
- [Git Tools](#git-tools) - git, GitHub CLI
- [AI & Machine Learning](#ai--machine-learning) - Ollama, Open WebUI
- [Tips](#tips)

---

## Alias Setup Instructions

### Naming Convention: Using the `dt` Prefix

**RECOMMENDED:** Use the `dt` prefix (Docker Tools) to avoid conflicts with natively installed tools.

**Why use `dt` prefix?**
- Prevents conflicts with existing installations (e.g., `dtpython` vs native `python`)
- Makes it clear you're using Docker-based tools
- Allows you to have both native and Docker versions side-by-side
- Consistent naming pattern across all tools

**Example:**
```bash
# Without prefix (can conflict with native tools)
alias python='docker run --rm -v ${PWD}:/app python:3.12 python'

# With dt prefix (recommended - no conflicts!)
alias dtpython='docker run --rm -v ${PWD}:/app python:3.12 python'
```

**Throughout this guide:**
- Bash/Zsh examples show: `alias dtpython=...`
- PowerShell examples show: `function dtpython { ... }`
- All function names use the `dt` prefix (e.g., `dtpython`, `dtnode`, `dtjupyter`)

### Linux / macOS (Bash/Zsh)
Add aliases to `~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`, then run `source ~/.bashrc`

**Example with `dt` prefix:**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias dtpython='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python'
alias dtnode='docker run --rm -it -v ${PWD}:/app -w /app node:22 node'
alias dtjupyter='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook'

# Reload shell
source ~/.bashrc
```

### Windows PowerShell

**IMPORTANT for Persistence:**
Functions defined in PowerShell are **temporary** (only for current session) unless you add them to your PowerShell profile.

**To make aliases permanent:**
1. Open PowerShell profile: `notepad $PROFILE`
   - If file doesn't exist: `New-Item -Path $PROFILE -Type File -Force`
2. Add your functions to the file
3. Save and reload: `. $PROFILE` or restart PowerShell

**Example with `dt` prefix:**
```powershell
# Add to $PROFILE (opens with: notepad $PROFILE)
function dtpython { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python $args }
function dtnode { docker run --rm -it -v ${PWD}:/app -w /app node:22 node $args }
function dtjupyter { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook }

# To check if profile exists:
Test-Path $PROFILE

# To create profile if it doesn't exist:
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }

# Reload profile after editing:
. $PROFILE
```

**Or use the interactive installer:**
```powershell
# Clone the repo and run the installer
git clone https://github.com/yourusername/docker-toolbox.git
cd docker-toolbox
.\install-interactive.ps1
```

**PowerShell Profile Location:**
- Current User, Current Host: `~\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`
- Or use `$PROFILE` variable to find it automatically

### Windows CMD
Create `.bat` files in a PATH folder (e.g., `C:\bin\`). Use `%CD%` instead of `${PWD}` and `%*` for args.

**Example:**
```batch
@echo off
docker run --rm -v %CD%:/app -w /app python:3.12 python %*
```

---

## Static Site Generators

### Jekyll
Ruby-based static site generator, popular for GitHub Pages.

```bash
# Serve with live reload
docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll jekyll serve --watch --force_polling

# Pinned version (more stable)
docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll:4.2.0 jekyll serve --watch --force_polling

# Alternative: bretfisher image (works well for complex setups)
docker run --rm -v ${PWD}:/site -p 4000:4000 bretfisher/jekyll-serve

# Build only
docker run --rm -v ${PWD}:/srv/jekyll jekyll/jekyll jekyll build
```

**Note:** The `bretfisher/jekyll-serve` image is particularly useful for repositories with complex dependencies (like the xmpro blueprints repo). It auto-runs `bundle install` and starts the server with sensible defaults.

**Aliases:**
```bash
# Linux/macOS
alias dtjekyll='docker run --rm -v ${PWD}:/srv/jekyll jekyll/jekyll jekyll'
alias dtjekyllserve='docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll jekyll serve --watch --force_polling'
alias dtjekyllsimple='docker run --rm -v ${PWD}:/site -p 4000:4000 bretfisher/jekyll-serve'

# PowerShell
function dtjekyll { docker run --rm -v ${PWD}:/srv/jekyll jekyll/jekyll jekyll $args }
function dtjekyllserve { docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll jekyll serve --watch --force_polling }
function dtjekyllsimple { docker run --rm -v ${PWD}:/site -p 4000:4000 bretfisher/jekyll-serve }
```

---

### Hugo
Fast static site generator written in Go.

```bash
# Serve with live reload
docker run --rm -v ${PWD}:/src -p 1313:1313 klakegg/hugo server --bind 0.0.0.0

# Build site
docker run --rm -v ${PWD}:/src klakegg/hugo

# Create new site
docker run --rm -v ${PWD}:/src klakegg/hugo new site mysite
```

**Aliases:**
```bash
# Linux/macOS
alias dthugo='docker run --rm -v ${PWD}:/src klakegg/hugo'
alias dthugoserve='docker run --rm -v ${PWD}:/src -p 1313:1313 klakegg/hugo server --bind 0.0.0.0'

# PowerShell
function dthugo { docker run --rm -v ${PWD}:/src klakegg/hugo $args }
function dthugoserve { docker run --rm -v ${PWD}:/src -p 1313:1313 klakegg/hugo server --bind 0.0.0.0 }
```

---

### MkDocs (Material Theme)
Python documentation generator with beautiful Material theme.

```bash
# Serve docs with live reload
docker run --rm -v ${PWD}:/docs -p 8000:8000 squidfunk/mkdocs-material

# Build static site
docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material build

# Create new project
docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material new .
```

**Aliases:**
```bash
# Linux/macOS
alias dtmkdocs='docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material'
alias dtmkdocsserve='docker run --rm -v ${PWD}:/docs -p 8000:8000 squidfunk/mkdocs-material'

# PowerShell
function dtmkdocs { docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material $args }
function dtmkdocsserve { docker run --rm -v ${PWD}:/docs -p 8000:8000 squidfunk/mkdocs-material }
```

---

## Build & Task Runners

### just
Command runner for executing project-specific tasks and recipes.

```bash
# Using Rust image with just pre-compiled
docker run --rm -v ${PWD}:/workdir -w /workdir rust:alpine sh -c "cargo install just > /dev/null 2>&1 && just"

# Or use prebuilt binary approach
docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just --list"

# Simpler: Run specific recipe
docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just build"
```

**Aliases:**
```bash
# Linux/macOS
alias dtjust='docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just"'

# PowerShell
function dtjust { docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just $args" }
```

**Note:** The just binary download adds startup time. For frequent use, consider installing just natively.

---

### Make
GNU Make for traditional Makefile execution.

```bash
# Run make (using Alpine Linux with make pre-installed)
docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make"

# Run specific target
docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make build"

# Parallel execution
docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make -j4"
```

**Aliases:**
```bash
# Linux/macOS
alias dtmake='docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make"'

# PowerShell
function dtmake { docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make $args" }
```

---

## Terminal Tools

### tmux
Terminal multiplexer for managing multiple sessions.

```bash
# Simple tmux session (ephemeral)
docker run --rm -it alpine sh -c "apk add --no-cache tmux && tmux"

# With mounted working directory (access your files)
docker run --rm -it -v ${PWD}:/workspace -w /workspace alpine sh -c "apk add --no-cache tmux bash git && tmux"

# With your own tmux config (mount from home directory)
docker run --rm -it -v ${PWD}:/workspace -v ~/.tmux.conf:/root/.tmux.conf -w /workspace alpine sh -c "apk add --no-cache tmux bash git && tmux"

# Persistent tmux environment (named container, keeps sessions)
docker run -it --name tmux-dev -v ${PWD}:/workspace -w /workspace alpine sh -c "apk add --no-cache tmux bash git vim && tmux"

# Reconnect to existing tmux container
docker start -ai tmux-dev

# Full development environment with common tools
docker run --rm -it -v ${PWD}:/workspace -w /workspace alpine sh -c "apk add --no-cache tmux bash git vim curl python3 nodejs && tmux"
```

**Aliases:**
```bash
# Linux/macOS (mounts ~/.tmux.conf if it exists)
alias dttmux='docker run --rm -it -v ${PWD}:/workspace -v ~/.tmux.conf:/root/.tmux.conf -w /workspace alpine sh -c "apk add --no-cache tmux bash git && tmux"'
alias dttmuxdev='docker run -it --name tmux-dev -v ${PWD}:/workspace -v ~/.tmux.conf:/root/.tmux.conf -w /workspace alpine sh -c "apk add --no-cache tmux bash git vim && tmux"'

# PowerShell (mounts ~/.tmux.conf if it exists)
function dttmux { docker run --rm -it -v ${PWD}:/workspace -v ~/.tmux.conf:/root/.tmux.conf -w /workspace alpine sh -c "apk add --no-cache tmux bash git && tmux" }
function dttmuxdev { docker run -it --name tmux-dev -v ${PWD}:/workspace -v ~/.tmux.conf:/root/.tmux.conf -w /workspace alpine sh -c "apk add --no-cache tmux bash git vim && tmux" }
```

**Notes:**
- **With `--rm`**: Container and tmux sessions are deleted when you exit (good for temporary work)
- **Without `--rm`**: Use a named container (e.g., `--name tmux-dev`) to persist sessions. Reconnect with `docker start -ai tmux-dev`
- **Windows**: Works well via Docker - mount your project directory to work on files inside the containerized tmux environment
- **Use case**: Great for containerized development environments where you want multiple panes/windows working on the same project
- **Custom config**: Mount your own `~/.tmux.conf` with `-v ~/.tmux.conf:/root/.tmux.conf` to use your personal tmux settings

---

### htop
Interactive process viewer.

```bash
docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop"
```

**Aliases:**
```bash
# Linux/macOS
alias dthtop='docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop"'

# PowerShell
function dthtop { docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop" }
```

---

### ncdu
Disk usage analyzer with ncurses interface.

```bash
docker run --rm -it -v ${PWD}:/data alpine sh -c "apk add --no-cache ncdu && ncdu /data"
```

**Aliases:**
```bash
# Linux/macOS
alias dtncdu='docker run --rm -it -v ${PWD}:/data alpine sh -c "apk add --no-cache ncdu && ncdu /data"'

# PowerShell
function dtncdu { docker run --rm -it -v ${PWD}:/data alpine sh -c "apk add --no-cache ncdu && ncdu /data" }
```

---

### lazygit
Simple terminal UI for git commands.

```bash
docker run --rm -it -v ${PWD}:/repo -w /repo lazyteam/lazygit
```

**Aliases:**
```bash
# Linux/macOS
alias dtlazygit='docker run --rm -it -v ${PWD}:/repo -w /repo lazyteam/lazygit'

# PowerShell
function dtlazygit { docker run --rm -it -v ${PWD}:/repo -w /repo lazyteam/lazygit }
```

---

### lazydocker
Simple terminal UI for Docker management.

```bash
docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker
```

**Aliases:**
```bash
# Linux/macOS
alias dtlazydocker='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker'

# PowerShell
function dtlazydocker { docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker }
```

---

### ranger
Console file manager with vi-like keybindings.

```bash
docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ranger && ranger"
```

**Aliases:**
```bash
# Linux/macOS
alias dtranger='docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ranger && ranger"'

# PowerShell
function dtranger { docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ranger && ranger" }
```

---

### fzf
Fuzzy finder for the terminal.

```bash
# Find files
docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fzf && find . | fzf"
```

**Aliases:**
```bash
# Linux/macOS
alias dtfzf='docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fzf && find . | fzf"'

# PowerShell
function dtfzf { docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fzf && find . | fzf" }
```

---

### bat
Cat clone with syntax highlighting.

```bash
# View file with syntax highlighting
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat filename.py"

# With line numbers
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat -n filename.py"

# Show non-printable characters
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat -A filename.py"
```

**Aliases:**
```bash
# Linux/macOS
alias dtbat='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat"'

# PowerShell
function dtbat { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat $args" }
```

---

### ripgrep (rg)
Lightning-fast search tool (better than grep).

```bash
# Search for pattern in current directory
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg pattern"

# Case-insensitive search
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg -i pattern"

# Search only in specific file types
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg -t py 'import'"

# Show context lines
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg -C 3 pattern"
```

**Aliases:**
```bash
# Linux/macOS
alias dtrg='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg"'

# PowerShell
function dtrg { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg $args" }
```

---

### fd
Fast and user-friendly alternative to find.

```bash
# Find files by name
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd pattern"

# Find with extension
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd -e js"

# Find directories only
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd -t d"

# Execute command on results
docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd pattern -x echo"
```

**Aliases:**
```bash
# Linux/macOS
alias dtfd='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd"'

# PowerShell
function dtfd { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd $args" }
```

---

### jq
Lightweight JSON processor.

```bash
# Pretty print JSON
docker run --rm -i ghcr.io/jqlang/jq '.' < file.json

# Query JSON
echo '{"name":"test"}' | docker run --rm -i ghcr.io/jqlang/jq '.name'
```

**Aliases:**
```bash
# Linux/macOS
alias dtjq='docker run --rm -i ghcr.io/jqlang/jq'

# PowerShell
function dtjq { docker run --rm -i ghcr.io/jqlang/jq $args }
```

---

### yq
YAML/JSON/XML processor (like jq for YAML).

```bash
docker run --rm -v ${PWD}:/workdir mikefarah/yq '.key' file.yaml
```

**Aliases:**
```bash
# Linux/macOS
alias dtyq='docker run --rm -v ${PWD}:/workdir mikefarah/yq'

# PowerShell
function dtyq { docker run --rm -v ${PWD}:/workdir mikefarah/yq $args }
```

---

## Programming Languages

### Python
Run Python scripts or interactive shell.

```bash
# Interactive shell
docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python

# Run script
docker run --rm -v ${PWD}:/app -w /app python:3.12 python script.py

# With pip install
docker run --rm -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -r requirements.txt && python app.py"

# IPython
docker run --rm -it -v ${PWD}:/app -w /app python:3.12 sh -c "pip install ipython && ipython"
```

**Aliases:**
```bash
# Linux/macOS
alias dtpython='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python'
alias dtipython='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -q ipython && ipython"'

# PowerShell
function dtpython { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python $args }
function dtipython { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -q ipython && ipython" }
```

**Note:** There's no `dtpip` alias because pip installs in ephemeral containers are lost immediately. Instead, combine install + run:
```bash
docker run --rm -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -r requirements.txt && python app.py"
```

---

### Jupyter Notebook
Interactive notebooks for data science, analysis, and documentation.

```bash
# Start Jupyter Notebook server
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook

# Start JupyterLab (modern interface)
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/datascience-notebook

# With specific token for security
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work -e JUPYTER_TOKEN=mysecret jupyter/base-notebook

# Start with no authentication (local development only!)
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook start-notebook.sh --NotebookApp.token=''

# Scipy stack (includes NumPy, Pandas, Matplotlib, SciPy)
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook

# With TensorFlow & Keras
docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/tensorflow-notebook

# Convert notebook to HTML
docker run --rm -v ${PWD}:/home/jovyan/work jupyter/base-notebook jupyter nbconvert --to html /home/jovyan/work/notebook.ipynb

# Convert notebook to PDF (requires LaTeX)
docker run --rm -v ${PWD}:/home/jovyan/work jupyter/base-notebook jupyter nbconvert --to pdf /home/jovyan/work/notebook.ipynb
```

**Aliases:**
```bash
# Linux/macOS
alias dtjupyter='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook'
alias dtjupyterlab='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/datascience-notebook'
alias dtjupyterscipy='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook'

# PowerShell
function dtjupyter { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook }
function dtjupyterlab { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/datascience-notebook }
function dtjupyterscipy { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook }
```

**Available Jupyter Stacks:**
- `jupyter/base-notebook` - Minimal notebook (smallest size)
- `jupyter/scipy-notebook` - Scientific Python stack (NumPy, Pandas, Matplotlib, SciPy)
- `jupyter/datascience-notebook` - Data science tools (Julia, Python, R)
- `jupyter/tensorflow-notebook` - TensorFlow & Keras for deep learning
- `jupyter/pyspark-notebook` - PySpark for big data processing
- `jupyter/all-spark-notebook` - Spark with Python, R, and Scala

**Note:** Notebooks are saved in your current directory under the `work` folder. The server will display a URL with a token - copy it to your browser to access Jupyter.

---

### Node.js
JavaScript runtime.

```bash
# Interactive REPL
docker run --rm -it -v ${PWD}:/app -w /app node:22 node

# Run script
docker run --rm -v ${PWD}:/app -w /app node:22 node script.js

# npm commands
docker run --rm -v ${PWD}:/app -w /app node:22 npm install
docker run --rm -v ${PWD}:/app -w /app node:22 npm run build

# npx (run packages without installing)
docker run --rm -v ${PWD}:/app -w /app node:22 npx create-react-app my-app
```

**Aliases:**
```bash
# Linux/macOS
alias dtnode='docker run --rm -it -v ${PWD}:/app -w /app node:22 node'
alias dtnpm='docker run --rm -v ${PWD}:/app -w /app node:22 npm'
alias dtnpx='docker run --rm -v ${PWD}:/app -w /app node:22 npx'
alias dtyarn='docker run --rm -v ${PWD}:/app -w /app node:22 yarn'

# PowerShell
function dtnode { docker run --rm -it -v ${PWD}:/app -w /app node:22 node $args }
function dtnpm { docker run --rm -v ${PWD}:/app -w /app node:22 npm $args }
function dtnpx { docker run --rm -v ${PWD}:/app -w /app node:22 npx $args }
function dtyarn { docker run --rm -v ${PWD}:/app -w /app node:22 yarn $args }
```

---

### Go
Compile and run Go applications.

```bash
# Run Go file
docker run --rm -v ${PWD}:/app -w /app golang:1.22 go run main.go

# Build binary
docker run --rm -v ${PWD}:/app -w /app golang:1.22 go build -o myapp

# Run tests
docker run --rm -v ${PWD}:/app -w /app golang:1.22 go test ./...
```

**Aliases:**
```bash
# Linux/macOS
alias dtgo='docker run --rm -v ${PWD}:/app -w /app golang:1.22 go'

# PowerShell
function dtgo { docker run --rm -v ${PWD}:/app -w /app golang:1.22 go $args }
```

---

### Rust
Systems programming with Cargo.

```bash
# Build project (with persistent cargo cache)
docker run --rm -v ${PWD}:/app -v cargo-cache:/usr/local/cargo -w /app rust:latest cargo build

# Run project
docker run --rm -v ${PWD}:/app -v cargo-cache:/usr/local/cargo -w /app rust:latest cargo run

# Run tests
docker run --rm -v ${PWD}:/app -v cargo-cache:/usr/local/cargo -w /app rust:latest cargo test
```

**Aliases:**
```bash
# Linux/macOS
alias dtcargo='docker run --rm -v ${PWD}:/app -v cargo-cache:/usr/local/cargo -w /app rust:latest cargo'
alias dtrustc='docker run --rm -v ${PWD}:/app -w /app rust:latest rustc'

# PowerShell
function dtcargo { docker run --rm -v ${PWD}:/app -v cargo-cache:/usr/local/cargo -w /app rust:latest cargo $args }
function dtrustc { docker run --rm -v ${PWD}:/app -w /app rust:latest rustc $args }
```

**Note:** The `cargo-cache` volume persists downloaded dependencies between runs, making builds much faster.

---

### Ruby
Ruby interpreter and gem management.

```bash
# Interactive Ruby shell
docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb

# Run script
docker run --rm -v ${PWD}:/app -w /app ruby:3.3 ruby script.rb

# Bundle install (installs gems to vendor/bundle in your project)
docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle install --path vendor/bundle

# Run with bundler
docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle exec ruby script.rb
```

**Aliases:**
```bash
# Linux/macOS
alias dtruby='docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 ruby'
alias dtirb='docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb'
alias dtbundle='docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle'

# PowerShell
function dtruby { docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 ruby $args }
function dtirb { docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb }
function dtbundle { docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle $args }
```

**Note:** When using `dtbundle install`, always add `--path vendor/bundle` to install gems locally to your project directory:
```bash
dtbundle install --path vendor/bundle
dtbundle exec ruby script.rb
```

---

## Development Environments & IDEs

### VS Code Server (code-server)
Full VS Code experience in your browser.

```bash
# Start VS Code server
docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none

# With password protection
docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project -e PASSWORD=mysecret codercom/code-server

# With extensions pre-installed
docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none --install-extension ms-python.python
```

**Aliases:**
```bash
# Linux/macOS
alias dtvscode='docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none'

# PowerShell
function dtvscode { docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none }
```

**Note:** Access VS Code at `http://localhost:8080`. All your VS Code settings and extensions will be saved in the mounted directory.

---

### RStudio
IDE for R programming and data analysis.

```bash
# Start RStudio Server
docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/rstudio

# With tidyverse packages
docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/tidyverse

# With verse (tidyverse + publishing tools)
docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/verse
```

**Aliases:**
```bash
# Linux/macOS
alias dtrstudio='docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/rstudio'
alias dtrstudiotidy='docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/tidyverse'

# PowerShell
function dtrstudio { docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/rstudio }
function dtrstudiotidy { docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/tidyverse }
```

**Note:** Access RStudio at `http://localhost:8787`. Login with username `rstudio` and password `rstudio`.

---

### Vert
Web-based terminal and development environment.

```bash
# Basic commands
docker run -d --restart unless-stopped -p 3000:80 --name vert ghcr.io/vert-sh/vert:latest
docker start vert
docker stop vert
docker rm -f vert
```

**Smart Aliases (handles already-running containers and opens browser):**

```bash
# Linux/macOS
dtvert() {
  local port=${1:-3000}
  local container_name="vert-${port}"

  if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
    if ! docker ps --format '{{.Names}}' | grep -q "^${container_name}$"; then
      echo "Starting existing Vert container on port ${port}..."
      docker start "$container_name"
    else
      echo "Vert is already running on port ${port}"
    fi
  else
    echo "Creating new Vert container on port ${port}..."
    docker run -d --restart unless-stopped -p "${port}:80" --name "$container_name" ghcr.io/vert-sh/vert:latest
  fi
  echo "Opening Vert at http://localhost:${port}"
  if command -v xdg-open > /dev/null; then
    xdg-open "http://localhost:${port}"
  elif command -v open > /dev/null; then
    open "http://localhost:${port}"
  fi
}

dtvertstop() {
  local port=${1:-3000}
  local container_name="vert-${port}"
  docker stop "$container_name"
  echo "Vert on port ${port} stopped"
}

# PowerShell
function dtvert {
  param([int]$port = 3000)

  $containerName = "vert-$port"
  $containerExists = docker ps -a --format "{{.Names}}" | Select-String -Pattern "^$containerName$" -Quiet

  if ($containerExists) {
    $isRunning = docker ps --format "{{.Names}}" | Select-String -Pattern "^$containerName$" -Quiet
    if (-not $isRunning) {
      Write-Host "Starting existing Vert container on port $port..."
      docker start $containerName
    } else {
      Write-Host "Vert is already running on port $port"
    }
  } else {
    Write-Host "Creating new Vert container on port $port..."
    docker run -d --restart unless-stopped -p "${port}:80" --name $containerName ghcr.io/vert-sh/vert:latest
  }
  Write-Host "Opening Vert at http://localhost:$port"
  Start-Process "http://localhost:$port"
}

function dtvertstop {
  param([int]$port = 3000)

  $containerName = "vert-$port"
  docker stop $containerName
  Write-Host "Vert on port $port stopped"
}
```

**Usage:**
- `dtvert` - Starts Vert on default port 3000 and opens browser
- `dtvert 8080` - Starts Vert on port 8080 and opens browser
- `dtvertstop` - Stops Vert on port 3000
- `dtvertstop 8080` - Stops Vert on port 8080

**Note:**
- Container name is based on port (e.g., `vert-3000`, `vert-8080`)
- Multiple instances can run on different ports simultaneously
- The container persists and restarts automatically unless stopped

---
### Node-RED
Flow-based programming tool for IoT, home automation, and API integration.

```bash
# Start Node-RED (ephemeral)
docker run --rm -p 1880:1880 nodered/node-red

# With persistent data
docker run --rm -p 1880:1880 -v nodered-data:/data nodered/node-red

# With custom settings file
docker run --rm -p 1880:1880 -v ${PWD}/settings.js:/data/settings.js -v nodered-data:/data nodered/node-red

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 1880:1880 -v nodered-data:/data --name nodered nodered/node-red

# Stop the daemon
docker stop nodered

# Start existing container
docker start nodered

# View logs
docker logs nodered -f
```

**Aliases:**
```bash
# Linux/macOS
alias dtnodered='docker run --rm -p 1880:1880 -v nodered-data:/data nodered/node-red'
alias dtnoderedstart='docker start nodered'
alias dtnoderedstop='docker stop nodered'
alias dtnoderedlogs='docker logs nodered -f'

# PowerShell
function dtnodered { docker run --rm -p 1880:1880 -v nodered-data:/data nodered/node-red }
function dtnoderedstart { docker start nodered }
function dtnoderedstop { docker stop nodered }
function dtnoderedlogs { docker logs nodered -f }
```

**Note:** Access Node-RED at `http://localhost:1880`. Flows and settings are stored in the `nodered-data` volume. Use the daemon mode for long-running instances.

---



## Testing Tools

### n8n
Workflow automation tool for connecting apps and services (alternative to Zapier/Make).

```bash
# Start n8n (ephemeral)
docker run --rm -p 5678:5678 n8nio/n8n

# With persistent data
docker run --rm -p 5678:5678 -v n8n-data:/home/node/.n8n n8nio/n8n

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 5678:5678 -v n8n-data:/home/node/.n8n --name n8n n8nio/n8n

# With custom timezone
docker run -d --restart unless-stopped -p 5678:5678 -v n8n-data:/home/node/.n8n -e TZ=America/New_York --name n8n n8nio/n8n

# With webhook URL (for production)
docker run -d --restart unless-stopped -p 5678:5678 -v n8n-data:/home/node/.n8n -e WEBHOOK_URL=https://yourdomain.com --name n8n n8nio/n8n

# Stop the daemon
docker stop n8n

# Start existing container
docker start n8n

# View logs
docker logs n8n -f
```

**Aliases:**
```bash
# Linux/macOS
alias dtn8n='docker run --rm -p 5678:5678 -v n8n-data:/home/node/.n8n n8nio/n8n'
alias dtn8nstart='docker start n8n'
alias dtn8nstop='docker stop n8n'
alias dtn8nlogs='docker logs n8n -f'

# PowerShell
function dtn8n { docker run --rm -p 5678:5678 -v n8n-data:/home/node/.n8n n8nio/n8n }
function dtn8nstart { docker start n8n }
function dtn8nstop { docker stop n8n }
function dtn8nlogs { docker logs n8n -f }
```

**Note:** Access n8n at `http://localhost:5678`. Workflows are stored in the `n8n-data` volume. Supports 200+ integrations including APIs, databases, and cloud services.

---


## Testing Tools

### Playwright
Modern end-to-end testing framework for web applications.

```bash
# Run tests
docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test

# Run tests in headed mode (requires X11/display forwarding)
docker run --rm -v ${PWD}:/work -w /work -e DISPLAY mcr.microsoft.com/playwright:v1.40.0 npx playwright test --headed

# Generate tests
docker run --rm -it -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright codegen https://example.com

# Run specific test file
docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test tests/example.spec.ts

# Show test report
docker run --rm -v ${PWD}:/work -w /work -p 9323:9323 mcr.microsoft.com/playwright:v1.40.0 npx playwright show-report

# Install dependencies in project
docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npm install
```

**Aliases:**
```bash
# Linux/macOS
alias dtplaywright='docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright'
alias dtplaywrighttest='docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test'

# PowerShell
function dtplaywright { docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright $args }
function dtplaywrighttest { docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test $args }
```

**Note:** For headed mode (viewing browser), you'll need to set up X11 forwarding:
- Linux: Add `-e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix`
- macOS: Install XQuartz and configure X11 forwarding
- Windows: Use WSL2 with X server (VcXsrv or similar)

---

## Databases

### PostgreSQL
Relational database.

```bash
# Run server (ephemeral)
docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16

# Run server (persistent)
docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret -v pgdata:/var/lib/postgresql/data postgres:16

# psql client
docker run --rm -it postgres:16 psql -h host.docker.internal -U postgres
```

**Aliases:**
```bash
# Linux/macOS
alias dtpostgres='docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16'
alias dtpsql='docker run --rm -it postgres:16 psql'

# PowerShell
function dtpostgres { docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16 }
function dtpsql { docker run --rm -it postgres:16 psql $args }
```

---

### MySQL
Relational database.

```bash
# Run server
docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:8

# mysql client
docker run --rm -it mysql:8 mysql -h host.docker.internal -u root -p
```

**Aliases:**
```bash
# Linux/macOS
alias dtmysql='docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:8'
alias dtmysqlclient='docker run --rm -it mysql:8 mysql'

# PowerShell
function dtmysql { docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:8 }
function dtmysqlclient { docker run --rm -it mysql:8 mysql $args }
```

---

### Redis
In-memory data store.

```bash
# Run server
docker run --rm -p 6379:6379 redis:7-alpine

# redis-cli
docker run --rm -it redis:7-alpine redis-cli -h host.docker.internal
```

**Aliases:**
```bash
# Linux/macOS
alias dtredis='docker run --rm -p 6379:6379 redis:7-alpine'
alias dtrediscli='docker run --rm -it redis:7-alpine redis-cli'

# PowerShell
function dtredis { docker run --rm -p 6379:6379 redis:7-alpine }
function dtrediscli { docker run --rm -it redis:7-alpine redis-cli $args }
```

---

### MongoDB
NoSQL document database.

```bash
# Run server
docker run --rm -p 27017:27017 mongo:7

# mongosh client
docker run --rm -it mongo:7 mongosh --host host.docker.internal
```

**Aliases:**
```bash
# Linux/macOS
alias dtmongo='docker run --rm -p 27017:27017 mongo:7'
alias dtmongosh='docker run --rm -it mongo:7 mongosh'

# PowerShell
function dtmongo { docker run --rm -p 27017:27017 mongo:7 }

### InfluxDB
Time-series database optimized for IoT sensors, metrics, and real-time analytics.

```bash
# Start InfluxDB 2.x (ephemeral)
docker run --rm -p 8086:8086 influxdb:2

# With persistent data
docker run --rm -p 8086:8086 -v influxdb-data:/var/lib/influxdb2 influxdb:2

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 8086:8086 -v influxdb-data:/var/lib/influxdb2 --name influxdb influxdb:2

# With initial setup (username, password, org, bucket)
docker run -d --restart unless-stopped -p 8086:8086 -v influxdb-data:/var/lib/influxdb2 -e DOCKER_INFLUXDB_INIT_MODE=setup -e DOCKER_INFLUXDB_INIT_USERNAME=admin -e DOCKER_INFLUXDB_INIT_PASSWORD=mypassword -e DOCKER_INFLUXDB_INIT_ORG=myorg -e DOCKER_INFLUXDB_INIT_BUCKET=mybucket --name influxdb influxdb:2

# Run InfluxDB CLI
docker exec -it influxdb influx

# Stop the daemon
docker stop influxdb

# Start existing container
docker start influxdb
```

**Aliases:**
```bash
# Linux/macOS
alias dtinfluxdb='docker run --rm -p 8086:8086 -v influxdb-data:/var/lib/influxdb2 influxdb:2'
alias dtinfluxstart='docker start influxdb'
alias dtinfluxstop='docker stop influxdb'
alias dtinfluxcli='docker exec -it influxdb influx'

# PowerShell
function dtinfluxdb { docker run --rm -p 8086:8086 -v influxdb-data:/var/lib/influxdb2 influxdb:2 }
function dtinfluxstart { docker start influxdb }
function dtinfluxstop { docker stop influxdb }
function dtinfluxcli { docker exec -it influxdb influx }
```

**Note:** Access InfluxDB UI at `http://localhost:8086`. Perfect for storing time-series data from IoT sensors, system metrics, and application performance monitoring. Works great with Grafana for visualization.


## Monitoring & Visualization

### Grafana
Beautiful dashboards for metrics, logs, and time-series data visualization.

```bash
# Start Grafana (ephemeral)
docker run --rm -p 3000:3000 grafana/grafana

# With persistent data
docker run --rm -p 3000:3000 -v grafana-data:/var/lib/grafana grafana/grafana

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 3000:3000 -v grafana-data:/var/lib/grafana --name grafana grafana/grafana

# With custom admin password
docker run -d --restart unless-stopped -p 3000:3000 -v grafana-data:/var/lib/grafana -e GF_SECURITY_ADMIN_PASSWORD=mysecret --name grafana grafana/grafana

# With anonymous access enabled
docker run -d --restart unless-stopped -p 3000:3000 -v grafana-data:/var/lib/grafana -e GF_AUTH_ANONYMOUS_ENABLED=true --name grafana grafana/grafana

# Stop the daemon
docker stop grafana

# Start existing container
docker start grafana
```

**Aliases:**
```bash
# Linux/macOS
alias dtgrafana='docker run --rm -p 3000:3000 -v grafana-data:/var/lib/grafana grafana/grafana'
alias dtgrafanastart='docker start grafana'
alias dtgrafanastop='docker stop grafana'
alias dtgrafanalogs='docker logs grafana -f'

# PowerShell
function dtgrafana { docker run --rm -p 3000:3000 -v grafana-data:/var/lib/grafana grafana/grafana }
function dtgrafanastart { docker start grafana }
function dtgrafanastop { docker stop grafana }
function dtgrafanalogs { docker logs grafana -f }
```

**Note:** Access Grafana at `http://localhost:3000`. Default credentials are `admin`/`admin` (you'll be prompted to change on first login). Works great with InfluxDB, Prometheus, PostgreSQL, and other data sources.

---

### Uptime Kuma
Self-hosted uptime monitoring tool with beautiful UI and notifications.

```bash
# Start Uptime Kuma (ephemeral)
docker run --rm -p 3001:3001 louislam/uptime-kuma

# With persistent data
docker run --rm -p 3001:3001 -v uptime-kuma-data:/app/data louislam/uptime-kuma

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 3001:3001 -v uptime-kuma-data:/app/data --name uptime-kuma louislam/uptime-kuma

# With custom port
docker run -d --restart unless-stopped -p 3002:3001 -v uptime-kuma-data:/app/data --name uptime-kuma louislam/uptime-kuma

# Stop the daemon
docker stop uptime-kuma

# Start existing container
docker start uptime-kuma
```

**Aliases:**
```bash
# Linux/macOS
alias dtuptime='docker run --rm -p 3001:3001 -v uptime-kuma-data:/app/data louislam/uptime-kuma'
alias dtuptimestart='docker start uptime-kuma'
alias dtuptimestop='docker stop uptime-kuma'
alias dtuptimelogs='docker logs uptime-kuma -f'

# PowerShell
function dtuptime { docker run --rm -p 3001:3001 -v uptime-kuma-data:/app/data louislam/uptime-kuma }
function dtuptimestart { docker start uptime-kuma }
function dtuptimestop { docker stop uptime-kuma }
function dtuptimelogs { docker logs uptime-kuma -f }
```

**Note:** Access Uptime Kuma at `http://localhost:3001`. Monitor HTTP/HTTPS, TCP, Ping, DNS, and more. Supports notifications via Discord, Telegram, Slack, email, and 50+ other services.

---

## Message Brokers & IoT

### Dozzle
Real-time Docker container log viewer with beautiful web UI.

```bash
# Start Dozzle (read-only access to Docker)
docker run --rm -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro amir20/dozzle

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro --name dozzle amir20/dozzle

# With custom port
docker run -d --restart unless-stopped -p 9999:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro --name dozzle amir20/dozzle

# With authentication enabled
docker run -d --restart unless-stopped -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro -e DOZZLE_USERNAME=admin -e DOZZLE_PASSWORD=secret --name dozzle amir20/dozzle

# Filter to show only specific containers
docker run -d --restart unless-stopped -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro -e DOZZLE_FILTER="name=postgres|name=redis" --name dozzle amir20/dozzle

# Stop the daemon
docker stop dozzle

# Start existing container
docker start dozzle
```

**Aliases:**
```bash
# Linux/macOS
alias dtdozzle='docker run --rm -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro amir20/dozzle'
alias dtdozzlestart='docker start dozzle'
alias dtdozzlestop='docker stop dozzle'

# PowerShell (Windows requires npipe mount)
function dtdozzle { docker run --rm -p 8080:8080 -v /var/run/docker.sock:/var/run/docker.sock:ro amir20/dozzle }
function dtdozzlestart { docker start dozzle }
function dtdozzlestop { docker stop dozzle }
```

**Note:** Access Dozzle at `http://localhost:8080`. Automatically discovers all running containers. Features include live log streaming, container stats, search/filter, and dark mode. Zero configuration needed!

---

## Message Brokers & IoT

### Mosquitto (MQTT Broker)
Lightweight MQTT broker for IoT messaging.

```bash
# Start MQTT broker with default config
docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto

# With persistent data
docker run --rm -p 1883:1883 -p 9001:9001 -v mosquitto-data:/mosquitto/data eclipse-mosquitto

# With custom config
docker run --rm -p 1883:1883 -p 9001:9001 -v ${PWD}/mosquitto.conf:/mosquitto/config/mosquitto.conf eclipse-mosquitto

# Enable WebSockets (port 9001)
docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto

# Subscribe to topic
docker run --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal -t "test/topic"

# Publish message
docker run --rm eclipse-mosquitto mosquitto_pub -h host.docker.internal -t "test/topic" -m "Hello MQTT"

# Manage password files with mosquitto_passwd
# Create new password file with user
docker run --rm -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd -c /mosquitto/config/passwd username

# Add user to existing password file
docker run --rm -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd /mosquitto/config/passwd username

# Delete user from password file
docker run --rm -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd -D /mosquitto/config/passwd username

# Batch mode (provide password via stdin, useful for automation)
echo "mypassword" | docker run --rm -i -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd -b /mosquitto/config/passwd username
```

**Aliases:**
```bash
# Linux/macOS
alias dtmosquitto='docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto'
alias dtmqttsub='docker run --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal'
alias dtmqttpub='docker run --rm eclipse-mosquitto mosquitto_pub -h host.docker.internal'
alias dtmosquittopasswd='docker run --rm -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd'

# PowerShell
function dtmosquitto { docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto }
function dtmqttsub { docker run --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal $args }
function dtmqttpub { docker run --rm eclipse-mosquitto mosquitto_pub -h host.docker.internal $args }
function dtmosquittopasswd { docker run --rm -v ${PWD}:/mosquitto/config eclipse-mosquitto mosquitto_passwd $args }
```

**Note:** Port 1883 is for MQTT, port 9001 is for WebSockets. Use `host.docker.internal` to connect to MQTT broker running on your host. The password file created by `mosquitto_passwd` is used for authentication in your Mosquitto broker configuration.

---

### MQTT Explorer
Visual MQTT client for exploring topics and messages.

```bash
# Run MQTT Explorer (GUI app)
docker run --rm -p 4000:4000 -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix smeagolworms4/mqtt-explorer

# Alternative: Use web-based MQTT client (HiveMQ)
docker run --rm -p 8080:8080 hivemq/hivemq-mqtt-web-client
```

**Note:** MQTT Explorer is a GUI application and requires X11 forwarding on Linux. For easier access, consider:
- **Windows/macOS**: Use native MQTT Explorer app from [mqtt-explorer.com](http://mqtt-explorer.com/)
- **Web-based alternative**: HiveMQ Web Client (shown above)
- **CLI alternative**: Use mosquitto_sub/mosquitto_pub commands

**Web-Based MQTT Clients (easier alternative):**
```bash
# HiveMQ Web Client
docker run --rm -p 8080:8080 cedalo/management-center

# Access at http://localhost:8080
```

**Aliases:**
```bash
# Linux/macOS (with X11)
alias dtmqttexplorer='docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix smeagolworms4/mqtt-explorer'

# Web-based MQTT client (cross-platform)
alias dtmqttweb='docker run --rm -p 8080:8080 cedalo/management-center'

# PowerShell (web-based client)
function dtmqttweb { docker run --rm -p 8080:8080 cedalo/management-center }
```

---

## DevOps & Cloud CLI

### AWS CLI
Interact with AWS services.

```bash
# Using host credentials
docker run --rm -v ~/.aws:/root/.aws amazon/aws-cli s3 ls

# Configure
docker run --rm -it -v ~/.aws:/root/.aws amazon/aws-cli configure

# With environment variables
docker run --rm -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY amazon/aws-cli s3 ls
```

**Aliases:**
```bash
# Linux/macOS
alias dtaws='docker run --rm -v ~/.aws:/root/.aws amazon/aws-cli'

# PowerShell
function dtaws { docker run --rm -v $HOME/.aws:/root/.aws amazon/aws-cli $args }
```

---

### Azure CLI

### LocalStack
Fully functional local AWS cloud stack for testing (S3, Lambda, DynamoDB, SQS, SNS, and more).

```bash
# Start LocalStack (basic services)
docker run --rm -p 4566:4566 -p 4510-4559:4510-4559 localstack/localstack

# With persistent data
docker run --rm -p 4566:4566 -p 4510-4559:4510-4559 -v localstack-data:/var/lib/localstack localstack/localstack

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 4566:4566 -p 4510-4559:4510-4559 -v localstack-data:/var/lib/localstack --name localstack localstack/localstack

# With specific services enabled
docker run -d --restart unless-stopped -p 4566:4566 -e SERVICES=s3,lambda,dynamodb,sqs -v localstack-data:/var/lib/localstack --name localstack localstack/localstack

# With Docker socket (for Lambda containers)
docker run -d --restart unless-stopped -p 4566:4566 -v /var/run/docker.sock:/var/run/docker.sock -v localstack-data:/var/lib/localstack --name localstack localstack/localstack

# Stop the daemon
docker stop localstack

# Start existing container
docker start localstack
```

**Aliases:**
```bash
# Linux/macOS
alias dtlocalstack='docker run --rm -p 4566:4566 -v localstack-data:/var/lib/localstack localstack/localstack'
alias dtlocalstackstart='docker start localstack'
alias dtlocalstackstop='docker stop localstack'
alias dtlocalstacklogs='docker logs localstack -f'

# PowerShell
function dtlocalstack { docker run --rm -p 4566:4566 -v localstack-data:/var/lib/localstack localstack/localstack }
function dtlocalstackstart { docker start localstack }
function dtlocalstackstop { docker stop localstack }
function dtlocalstacklogs { docker logs localstack -f }
```

**Note:** All services accessible at `http://localhost:4566`. Use AWS CLI with `--endpoint-url=http://localhost:4566`. Free tier supports core services; Pro tier adds more advanced services. Perfect for testing without AWS costs.

---

### Azure CLI
Interact with Azure services.

```bash
docker run --rm -it -v ~/.azure:/root/.azure mcr.microsoft.com/azure-cli az login
docker run --rm -v ~/.azure:/root/.azure mcr.microsoft.com/azure-cli az vm list
```

**Aliases:**
```bash
# Linux/macOS
alias dtaz='docker run --rm -v ~/.azure:/root/.azure mcr.microsoft.com/azure-cli az'

# PowerShell
function dtaz { docker run --rm -v $HOME/.azure:/root/.azure mcr.microsoft.com/azure-cli az $args }
```

---

### Google Cloud CLI
Interact with GCP services.

```bash
docker run --rm -it -v ~/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud auth login
docker run --rm -v ~/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud compute instances list
```

**Aliases:**
```bash
# Linux/macOS
alias dtgcloud='docker run --rm -v ~/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud'

# PowerShell
function dtgcloud { docker run --rm -v $HOME/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud $args }
```

---

### Terraform
Infrastructure as code.

```bash
docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform init
docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform plan
docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform apply
```

**Aliases:**
```bash
# Linux/macOS
alias dtterraform='docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform'
alias dttf='docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform'

# PowerShell
function dtterraform { docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform $args }
function dttf { docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform $args }
```

---

### Ansible

### Vault
Secrets management, encryption as a service, and privileged access management by HashiCorp.

```bash
# Start Vault in development mode (WARNING: Not for production!)
docker run --rm -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID=myroot hashicorp/vault

# With persistent data (server mode)
docker run --rm -p 8200:8200 -v vault-data:/vault/file --cap-add=IPC_LOCK hashicorp/vault server

# Run as daemon in dev mode (testing only)
docker run -d --restart unless-stopped -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID=myroot --name vault hashicorp/vault

# Run Vault CLI commands
docker exec -it vault vault status
docker exec -it vault vault kv put secret/myapp password=secret123

# Access Vault shell
docker exec -it vault sh

# Stop the daemon
docker stop vault

# Start existing container
docker start vault
```

**Aliases:**
```bash
# Linux/macOS
alias dtvault='docker run --rm -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID=myroot hashicorp/vault'
alias dtvaultstart='docker start vault'
alias dtvaultstop='docker stop vault'
alias dtvaultcli='docker exec -it vault vault'

# PowerShell
function dtvault { docker run --rm -p 8200:8200 -e VAULT_DEV_ROOT_TOKEN_ID=myroot hashicorp/vault }
function dtvaultstart { docker start vault }
function dtvaultstop { docker stop vault }
function dtvaultcli { docker exec -it vault vault $args }
```

**Note:** Access Vault UI at `http://localhost:8200`. Development mode uses in-memory storage and auto-unseals (root token: `myroot`). For production, use proper configuration with persistent storage and real secrets. Never use dev mode in production!

---

### Ansible
Configuration management and automation.

```bash
docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible-playbook playbook.yml
docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible --version
```

**Aliases:**
```bash
# Linux/macOS
alias dtansible='docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible'
alias dtansibleplaybook='docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible-playbook'

# PowerShell
function dtansible { docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible $args }
function dtansibleplaybook { docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible-playbook $args }
```

---

### kubectl
Kubernetes CLI.

```bash
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl get pods
docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl get nodes
```

**Aliases:**
```bash
# Linux/macOS
alias dtkubectl='docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl'
alias dtk='docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl'

# PowerShell
function dtkubectl { docker run --rm -v $HOME/.kube:/root/.kube bitnami/kubectl $args }
function dtk { docker run --rm -v $HOME/.kube:/root/.kube bitnami/kubectl $args }
```

---

### Helm
Kubernetes package manager.

```bash
docker run --rm -v ${PWD}:/apps -v ~/.kube:/root/.kube alpine/helm install myapp ./chart
docker run --rm -v ~/.kube:/root/.kube alpine/helm list
```

**Aliases:**
```bash
# Linux/macOS
alias dthelm='docker run --rm -v ${PWD}:/apps -v ~/.kube:/root/.kube alpine/helm'

# PowerShell
function dthelm { docker run --rm -v ${PWD}:/apps -v $HOME/.kube:/root/.kube alpine/helm $args }
```

---

## Code Quality & Linting

### Prettier
Code formatter for JS, CSS, HTML, Markdown, etc.

```bash
# Format files
docker run --rm -v ${PWD}:/work tmknom/prettier --write .

# Check formatting
docker run --rm -v ${PWD}:/work tmknom/prettier --check .
```

**Aliases:**
```bash
# Linux/macOS
alias dtprettier='docker run --rm -v ${PWD}:/work tmknom/prettier'

# PowerShell
function dtprettier { docker run --rm -v ${PWD}:/work tmknom/prettier $args }
```

---

### Black
Python code formatter.

```bash
# Format files
docker run --rm -v ${PWD}:/code cytopia/black .

# Check only
docker run --rm -v ${PWD}:/code cytopia/black --check .
```

**Aliases:**
```bash
# Linux/macOS
alias dtblack='docker run --rm -v ${PWD}:/code cytopia/black'

# PowerShell
function dtblack { docker run --rm -v ${PWD}:/code cytopia/black $args }
```

---

### ShellCheck
Shell script linter.

```bash
docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable script.sh
docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable *.sh
```

**Aliases:**
```bash
# Linux/macOS
alias dtshellcheck='docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable'

# PowerShell
function dtshellcheck { docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable $args }
```

---

### hadolint
Dockerfile linter.

```bash
docker run --rm -i hadolint/hadolint < Dockerfile
docker run --rm -v ${PWD}:/data -w /data hadolint/hadolint hadolint Dockerfile
```

**Aliases:**
```bash
# Linux/macOS
alias dthadolint='docker run --rm -i hadolint/hadolint'

# PowerShell
function dthadolint { docker run --rm -i hadolint/hadolint }
```

---

### markdownlint
Markdown linter.

```bash
docker run --rm -v ${PWD}:/workdir -w /workdir node:22-alpine sh -c "npm install -g markdownlint-cli > /dev/null 2>&1 && markdownlint '**/*.md'"
```

**Aliases:**
```bash
# Linux/macOS
alias dtmarkdownlint='docker run --rm -v ${PWD}:/workdir -w /workdir node:22-alpine sh -c "npm install -g markdownlint-cli > /dev/null 2>&1 && markdownlint"'

# PowerShell
function dtmarkdownlint { docker run --rm -v ${PWD}:/workdir -w /workdir node:22-alpine sh -c "npm install -g markdownlint-cli > /dev/null 2>&1 && markdownlint $args" }
```

---

## Media & Documents

### Pandoc
Universal document converter.

```bash
# Markdown to PDF
docker run --rm -v ${PWD}:/data pandoc/latex input.md -o output.pdf

# Markdown to DOCX
docker run --rm -v ${PWD}:/data pandoc/core input.md -o output.docx

# HTML to Markdown
docker run --rm -v ${PWD}:/data pandoc/core input.html -o output.md
```

**Aliases:**
```bash
# Linux/macOS
alias dtpandoc='docker run --rm -v ${PWD}:/data pandoc/latex'

# PowerShell
function dtpandoc { docker run --rm -v ${PWD}:/data pandoc/latex $args }
```

---

### FFmpeg
Video/audio processing.

```bash
# Convert video
docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg -i /data/input.mp4 /data/output.webm

# Extract audio
docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg -i /data/video.mp4 -vn /data/audio.mp3

# Compress video
docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg -i /data/input.mp4 -crf 28 /data/output.mp4
```

**Aliases:**
```bash
# Linux/macOS
alias dtffmpeg='docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg'

# PowerShell
function dtffmpeg { docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg $args }
```

---

### ImageMagick
Image manipulation.

```bash
# Resize image
docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick /imgs/input.png -resize 50% /imgs/output.png

# Convert format
docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick /imgs/input.png /imgs/output.jpg

# Create thumbnail
docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick /imgs/input.jpg -thumbnail 100x100 /imgs/thumb.jpg
```

**Aliases:**
```bash
# Linux/macOS
alias dtmagick='docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick'
alias dtconvert='docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick'

# PowerShell
function dtmagick { docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick $args }
```

---

### yt-dlp
Download videos from YouTube and other sites.

```bash
docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp "https://youtube.com/watch?v=xxx"

# Audio only
docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp -x --audio-format mp3 "https://youtube.com/watch?v=xxx"
```

**Aliases:**
```bash
# Linux/macOS
alias dtytdlp='docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp'

# PowerShell
function dtytdlp { docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp $args }
```

---

### Typst
Modern markup-based typesetting system (alternative to LaTeX).

```bash
# Compile document to PDF
docker run --rm -v ${PWD}:/data ghcr.io/typst/typst compile /data/document.typ

# Watch mode (recompile on changes)
docker run --rm -v ${PWD}:/data ghcr.io/typst/typst watch /data/document.typ

# Custom output path
docker run --rm -v ${PWD}:/data ghcr.io/typst/typst compile /data/document.typ /data/output.pdf

# Get version
docker run --rm ghcr.io/typst/typst --version

# Get help
docker run --rm ghcr.io/typst/typst --help
```

**Aliases:**
```bash
# Linux/macOS
alias dttypst='docker run --rm -v ${PWD}:/data ghcr.io/typst/typst'
alias dttypstcompile='docker run --rm -v ${PWD}:/data ghcr.io/typst/typst compile'
alias dttypstwatch='docker run --rm -v ${PWD}:/data ghcr.io/typst/typst watch'

# PowerShell
function dttypst { docker run --rm -v ${PWD}:/data ghcr.io/typst/typst $args }
function dttypstcompile { docker run --rm -v ${PWD}:/data ghcr.io/typst/typst compile $args }
function dttypstwatch { docker run --rm -v ${PWD}:/data ghcr.io/typst/typst watch $args }
```

**Note:** Typst files use the `.typ` extension. Compiled output is PDF by default. Visit [typst.app](https://typst.app) for documentation and examples.

---

### LaTeX
Traditional document preparation system for high-quality typesetting.

```bash
# Compile LaTeX document to PDF
docker run --rm -v ${PWD}:/data texlive/texlive pdflatex -output-directory=/data /data/document.tex

# Compile with bibliography
docker run --rm -v ${PWD}:/data texlive/texlive sh -c "cd /data && pdflatex document.tex && bibtex document && pdflatex document.tex && pdflatex document.tex"

# Compile XeLaTeX (for Unicode and custom fonts)
docker run --rm -v ${PWD}:/data texlive/texlive xelatex -output-directory=/data /data/document.tex

# Compile LuaLaTeX
docker run --rm -v ${PWD}:/data texlive/texlive lualatex -output-directory=/data /data/document.tex

# Get version
docker run --rm texlive/texlive pdflatex --version
```

**Aliases:**
```bash
# Linux/macOS
alias dtlatex='docker run --rm -v ${PWD}:/data texlive/texlive'
alias dtpdflatex='docker run --rm -v ${PWD}:/data texlive/texlive pdflatex -output-directory=/data'
alias dtxelatex='docker run --rm -v ${PWD}:/data texlive/texlive xelatex -output-directory=/data'
alias dtlualatex='docker run --rm -v ${PWD}:/data texlive/texlive lualatex -output-directory=/data'
alias dtbibtex='docker run --rm -v ${PWD}:/data texlive/texlive bibtex'

# PowerShell
function dtlatex { docker run --rm -v ${PWD}:/data texlive/texlive $args }
function dtpdflatex { docker run --rm -v ${PWD}:/data texlive/texlive pdflatex -output-directory=/data $args }
function dtxelatex { docker run --rm -v ${PWD}:/data texlive/texlive xelatex -output-directory=/data $args }
function dtlualatex { docker run --rm -v ${PWD}:/data texlive/texlive lualatex -output-directory=/data $args }
function dtbibtex { docker run --rm -v ${PWD}:/data texlive/texlive bibtex $args }
```

**Note:** LaTeX files use the `.tex` extension. The TeXLive distribution includes all major packages. For smaller image size, consider `texlive/texlive:TL2023-historic-small` (basic packages only).

---

## Networking & Security

### nmap
Network scanner.

```bash
docker run --rm -it instrumentisto/nmap -sP 192.168.1.0/24
docker run --rm -it instrumentisto/nmap -sV target.com
```

**Aliases:**
```bash
# Linux/macOS
alias dtnmap='docker run --rm -it instrumentisto/nmap'

# PowerShell
function dtnmap { docker run --rm -it instrumentisto/nmap $args }
```

---

### curl

### Caddy
Modern web server with automatic HTTPS via Let's Encrypt.

```bash
# Serve files from current directory
docker run --rm -p 80:80 -p 443:443 -v ${PWD}:/usr/share/caddy caddy

# With custom Caddyfile
docker run --rm -p 80:80 -p 443:443 -v ${PWD}/Caddyfile:/etc/caddy/Caddyfile -v ${PWD}/site:/usr/share/caddy caddy

# Run as daemon with persistent data and config
docker run -d --restart unless-stopped -p 80:80 -p 443:443 -v caddy-data:/data -v caddy-config:/config -v ${PWD}:/usr/share/caddy --name caddy caddy

# Reverse proxy example (proxy to localhost:3000)
docker run --rm -p 80:80 caddy caddy reverse-proxy --from :80 --to host.docker.internal:3000

# File server on custom port
docker run --rm -p 8080:8080 -v ${PWD}:/usr/share/caddy caddy caddy file-server --listen :8080 --root /usr/share/caddy

# Stop the daemon
docker stop caddy

# Start existing container
docker start caddy

# Reload Caddy config (without restart)
docker exec -w /etc/caddy caddy caddy reload
```

**Example Caddyfile:**
```
localhost

file_server browse
```

**Aliases:**
```bash
# Linux/macOS
alias dtcaddy='docker run --rm -p 80:80 -p 443:443 -v ${PWD}:/usr/share/caddy caddy'
alias dtcaddystart='docker start caddy'
alias dtcaddystop='docker stop caddy'
alias dtcaddyreload='docker exec -w /etc/caddy caddy caddy reload'

# PowerShell
function dtcaddy { docker run --rm -p 80:80 -p 443:443 -v ${PWD}:/usr/share/caddy caddy }
function dtcaddystart { docker start caddy }
function dtcaddystop { docker stop caddy }
function dtcaddyreload { docker exec -w /etc/caddy caddy caddy reload }
```

**Note:** Caddy automatically obtains and renews SSL certificates from Let's Encrypt. Simpler configuration than Nginx. Perfect for reverse proxying, static sites, and API gateways. Config reloads with zero downtime.

---

### curl (with extras)
Advanced curl with HTTP/3 support.

```bash
docker run --rm curlimages/curl https://api.github.com
docker run --rm curlimages/curl -s https://api.github.com | jq .
```

**Aliases:**
```bash
# Linux/macOS
alias dtcurl='docker run --rm curlimages/curl'

# PowerShell
function dtcurl { docker run --rm curlimages/curl $args }
```

---

### Trivy
Container vulnerability scanner.

```bash
docker run --rm aquasec/trivy image python:3.12
docker run --rm -v ${PWD}:/src aquasec/trivy fs /src
```

**Aliases:**
```bash
# Linux/macOS
alias dttrivy='docker run --rm aquasec/trivy'

# PowerShell
function dttrivy { docker run --rm aquasec/trivy $args }
```

---

### testssl
SSL/TLS testing tool.

```bash
docker run --rm -it drwetter/testssl.sh https://example.com
```

**Aliases:**
```bash
# Linux/macOS
alias dttestssl='docker run --rm -it drwetter/testssl.sh'

# PowerShell
function dttestssl { docker run --rm -it drwetter/testssl.sh $args }
```

---

## API Development

### Vaultwarden
Lightweight self-hosted Bitwarden password manager server.

```bash
# Start Vaultwarden (ephemeral)
docker run --rm -p 8080:80 vaultwarden/server

# With persistent data
docker run --rm -p 8080:80 -v vaultwarden-data:/data vaultwarden/server

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 8080:80 -v vaultwarden-data:/data --name vaultwarden vaultwarden/server

# With admin panel enabled
docker run -d --restart unless-stopped -p 8080:80 -v vaultwarden-data:/data -e ADMIN_TOKEN=your_secure_token --name vaultwarden vaultwarden/server

# Disable new user registration (after creating your account)
docker run -d --restart unless-stopped -p 8080:80 -v vaultwarden-data:/data -e SIGNUPS_ALLOWED=false --name vaultwarden vaultwarden/server

# With custom domain (for mobile apps)
docker run -d --restart unless-stopped -p 8080:80 -v vaultwarden-data:/data -e DOMAIN=https://vault.yourdomain.com --name vaultwarden vaultwarden/server

# Enable WebSocket notifications (for real-time sync)
docker run -d --restart unless-stopped -p 8080:80 -p 3012:3012 -v vaultwarden-data:/data -e WEBSOCKET_ENABLED=true --name vaultwarden vaultwarden/server

# Stop the daemon
docker stop vaultwarden

# Start existing container
docker start vaultwarden
```

**Aliases:**
```bash
# Linux/macOS
alias dtvaultwarden='docker run --rm -p 8080:80 -v vaultwarden-data:/data vaultwarden/server'
alias dtvaultwardenstart='docker start vaultwarden'
alias dtvaultwardenstop='docker stop vaultwarden'
alias dtvaultwardenlogs='docker logs vaultwarden -f'

# PowerShell
function dtvaultwarden { docker run --rm -p 8080:80 -v vaultwarden-data:/data vaultwarden/server }
function dtvaultwardenstart { docker start vaultwarden }
function dtvaultwardenstop { docker stop vaultwarden }
function dtvaultwardenlogs { docker logs vaultwarden -f }
```

**Note:** Access Vaultwarden at `http://localhost:8080`. Compatible with official Bitwarden clients (browser extensions, mobile apps, desktop apps). Admin panel at `/admin` (requires ADMIN_TOKEN). IMPORTANT: Use HTTPS in production! Supports 2FA, organizations, and emergency access.

---

## API Development

### Swagger UI
Interactive API documentation viewer.

```bash
docker run --rm -p 8080:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui
```

**Aliases:**
```bash
# Linux/macOS
alias dtswagger='docker run --rm -p 8080:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui'

# PowerShell
function dtswagger { docker run --rm -p 8080:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui }
```

---

### HTTPie
Modern HTTP client.

```bash
docker run --rm -it alpine/httpie https://api.github.com/users/octocat
docker run --rm -it alpine/httpie POST https://httpbin.org/post name=test
```

**Aliases:**
```bash
# Linux/macOS
alias dthttp='docker run --rm -it alpine/httpie'

# PowerShell
function dthttp { docker run --rm -it alpine/httpie $args }
```

---

### Newman
Run Postman collections.

```bash
docker run --rm -v ${PWD}:/etc/newman postman/newman run collection.json
docker run --rm -v ${PWD}:/etc/newman postman/newman run collection.json -e environment.json
```

**Aliases:**
```bash
# Linux/macOS
alias dtnewman='docker run --rm -v ${PWD}:/etc/newman postman/newman'

# PowerShell
function dtnewman { docker run --rm -v ${PWD}:/etc/newman postman/newman $args }
```

---

## Git Tools

### git
Git with all features.

```bash
docker run --rm -v ${PWD}:/git -w /git alpine/git clone https://github.com/user/repo.git
docker run --rm -v ${PWD}:/git -w /git alpine/git status
```

**Aliases:**
```bash
# Linux/macOS
alias dtgit='docker run --rm -v ${PWD}:/git -w /git alpine/git'

# PowerShell
function dtgit { docker run --rm -v ${PWD}:/git -w /git alpine/git $args }
```

---

### GitHub CLI
Official GitHub CLI.

```bash
docker run --rm -v ~/.config/gh:/root/.config/gh ghcr.io/github/gh-cli gh auth login
docker run --rm -v ~/.config/gh:/root/.config/gh -v ${PWD}:/repo -w /repo ghcr.io/github/gh-cli gh pr list
```

**Aliases:**
```bash
# Linux/macOS
alias dtgh='docker run --rm -v ~/.config/gh:/root/.config/gh -v ${PWD}:/repo -w /repo ghcr.io/github/gh-cli gh'

# PowerShell
function dtgh { docker run --rm -v $HOME/.config/gh:/root/.config/gh -v ${PWD}:/repo -w /repo ghcr.io/github/gh-cli gh $args }
```

---

## Tips

## AI & Machine Learning

### Ollama
Run large language models locally (Llama, Mistral, CodeLlama, and more).

```bash
# Start Ollama server
docker run -d --restart unless-stopped -p 11434:11434 -v ollama-data:/root/.ollama --name ollama ollama/ollama

# Run Ollama with GPU support (NVIDIA)
docker run -d --gpus=all --restart unless-stopped -p 11434:11434 -v ollama-data:/root/.ollama --name ollama ollama/ollama

# Pull a model (run after server is started)
docker exec -it ollama ollama pull llama3.2

# Run a model interactively
docker exec -it ollama ollama run llama3.2

# List installed models
docker exec -it ollama ollama list

# Chat with a model
docker exec -it ollama ollama run llama3.2 "Explain quantum computing in simple terms"

# Run CodeLlama for coding
docker exec -it ollama ollama run codellama "Write a Python function to reverse a string"

# Stop the daemon
docker stop ollama

# Start existing container
docker start ollama
```

**Available Models (examples):**
- `llama3.2` - Meta's Llama 3.2 (3B, 8B)
- `llama3.1` - Meta's Llama 3.1 (8B, 70B, 405B)
- `mistral` - Mistral 7B
- `codellama` - Code-specialized Llama
- `phi3` - Microsoft's Phi-3 (small but powerful)
- `gemma2` - Google's Gemma 2
- `qwen2.5` - Alibaba's Qwen 2.5
- `deepseek-coder` - Specialized coding model

**Aliases:**
```bash
# Linux/macOS
alias dtollama='docker exec -it ollama ollama'
alias dtollamastart='docker start ollama'
alias dtollamastop='docker stop ollama'
alias dtollamarun='docker exec -it ollama ollama run'
alias dtollamapull='docker exec -it ollama ollama pull'
alias dtollamalist='docker exec -it ollama ollama list'

# PowerShell
function dtollama { docker exec -it ollama ollama $args }
function dtollamastart { docker start ollama }
function dtollamastop { docker stop ollama }
function dtollamarun { docker exec -it ollama ollama run $args }
function dtollamapull { docker exec -it ollama ollama pull $args }
function dtollamalist { docker exec -it ollama ollama list }
```

**Note:** Ollama server runs at `http://localhost:11434`. Models are large (1-45GB depending on size). First use `dtollamapull llama3.2` to download a model, then use `dtollamarun llama3.2` to chat. API compatible with OpenAI format for easy integration.

---

## Tips

### Open WebUI
ChatGPT-style web interface for Ollama and other LLM providers.

```bash
# Start Open WebUI (connects to Ollama on host)
docker run --rm -p 3000:8080 -v open-webui-data:/app/backend/data --add-host=host.docker.internal:host-gateway ghcr.io/open-webui/open-webui

# Run as daemon with auto-restart
docker run -d --restart unless-stopped -p 3000:8080 -v open-webui-data:/app/backend/data --add-host=host.docker.internal:host-gateway --name open-webui ghcr.io/open-webui/open-webui

# With custom port
docker run -d --restart unless-stopped -p 8080:8080 -v open-webui-data:/app/backend/data --add-host=host.docker.internal:host-gateway --name open-webui ghcr.io/open-webui/open-webui

# With OpenAI API key (use both Ollama and OpenAI)
docker run -d --restart unless-stopped -p 3000:8080 -v open-webui-data:/app/backend/data -e OPENAI_API_KEY=your_key --add-host=host.docker.internal:host-gateway --name open-webui ghcr.io/open-webui/open-webui

# Stop the daemon
docker stop open-webui

# Start existing container
docker start open-webui
```

**Aliases:**
```bash
# Linux/macOS
alias dtopenwebui='docker run --rm -p 3000:8080 -v open-webui-data:/app/backend/data --add-host=host.docker.internal:host-gateway ghcr.io/open-webui/open-webui'
alias dtopenwebuistart='docker start open-webui'
alias dtopenwebuistop='docker stop open-webui'
alias dtopenwebuilogs='docker logs open-webui -f'

# PowerShell
function dtopenwebui { docker run --rm -p 3000:8080 -v open-webui-data:/app/backend/data --add-host=host.docker.internal:host-gateway ghcr.io/open-webui/open-webui }
function dtopenwebuistart { docker start open-webui }
function dtopenwebuistop { docker stop open-webui }
function dtopenwebuilogs { docker logs open-webui -f }
```

**Note:** Access Open WebUI at `http://localhost:3000`. Automatically discovers Ollama running on `localhost:11434`. Features include chat history, multiple models, document upload (RAG), image generation, and multi-user support. First user to register becomes admin.

---


## Tips

1. **Pull images ahead of time** to avoid delays:
   ```bash
   docker pull python:3.12 && docker pull node:22 && docker pull jekyll/jekyll
   ```

2. **Use specific tags** instead of `latest` for reproducibility.

3. **The `--rm` flag** removes the container when it exits (keeps things clean).

4. **Interactive mode** (`-it`) is needed for REPLs, shells, and TUI apps.

5. **Volume mounts** (`-v ${PWD}:/app`) share your current directory with the container.

6. **Host networking** (`--network host`) can help when containers need to reach host services.
