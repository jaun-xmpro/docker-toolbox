# Docker Commands for Development Tools

Run popular development tools without installing them locally. Just Docker required.

## Table of Contents

- [Alias Setup Instructions](#alias-setup-instructions)
- [Build & Task Runners](#build--task-runners) - just, Make
- [Static Site Generators](#static-site-generators) - Jekyll, Hugo, MkDocs
- [Terminal Tools](#terminal-tools) - tmux, htop, ncdu, lazygit, lazydocker, ranger, fzf, bat, ripgrep, fd, jq, yq
- [Programming Languages](#programming-languages) - Python, Jupyter Notebook, Node.js, Go, Rust, Ruby
- [Development Environments & IDEs](#development-environments--ides) - VS Code Server, RStudio
- [Testing Tools](#testing-tools) - Playwright
- [Databases](#databases) - PostgreSQL, MySQL, Redis, MongoDB
- [Message Brokers & IoT](#message-brokers--iot) - Mosquitto (MQTT), MQTT Explorer
- [DevOps & Cloud CLI](#devops--cloud-cli) - AWS CLI, Azure CLI, Google Cloud, Terraform, Ansible, kubectl, Helm
- [Code Quality & Linting](#code-quality--linting) - Prettier, Black, ShellCheck, hadolint, markdownlint
- [Media & Documents](#media--documents) - Pandoc, FFmpeg, ImageMagick, yt-dlp
- [Networking & Security](#networking--security) - nmap, curl, Trivy, testssl
- [API Development](#api-development) - Swagger UI, HTTPie, Newman
- [Git Tools](#git-tools) - git, GitHub CLI
- [Tips](#tips)

---

## Alias Setup Instructions

### Naming Convention: Using the `dt` Prefix

**RECOMMENDED:** Use the `dt` (Docker Tools) prefix to avoid conflicts with natively installed tools.

**Why use `dt` prefix?**
- Prevents conflicts with existing installations (e.g., `dt python` vs native `python`)
- Makes it clear you're using Docker-based tools
- Allows you to have both native and Docker versions side-by-side
- Consistent naming pattern across all tools

**Example:**
```bash
# Without prefix (can conflict with native tools)
alias python='docker run --rm -v ${PWD}:/app python:3.12 python'

# With dt prefix (recommended - no conflicts!)
alias dt-python='docker run --rm -v ${PWD}:/app python:3.12 python'
```

Throughout this guide, aliases are shown **without** the `dt` prefix for brevity, but you should add it when setting up your own aliases.

### Linux / macOS (Bash/Zsh)
Add aliases to `~/.bashrc`, `~/.zshrc`, or `~/.bash_profile`, then run `source ~/.bashrc`

**Example with `dt` prefix:**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias dt-python='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python'
alias dt-node='docker run --rm -it -v ${PWD}:/app -w /app node:22 node'
alias dt-jupyter='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook'

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
function dt-python { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python $args }
function dt-node { docker run --rm -it -v ${PWD}:/app -w /app node:22 node $args }
function dt-jupyter { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook }

# To check if profile exists:
Test-Path $PROFILE

# To create profile if it doesn't exist:
if (!(Test-Path $PROFILE)) { New-Item -Path $PROFILE -Type File -Force }

# Reload profile after editing:
. $PROFILE
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
alias jekyll='docker run --rm -v ${PWD}:/srv/jekyll jekyll/jekyll jekyll'
alias jekyll-serve='docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll jekyll serve --watch --force_polling'
alias jekyll-serve-simple='docker run --rm -v ${PWD}:/site -p 4000:4000 bretfisher/jekyll-serve'

# PowerShell
function jekyll { docker run --rm -v ${PWD}:/srv/jekyll jekyll/jekyll jekyll $args }
function jekyll-serve { docker run --rm -v ${PWD}:/srv/jekyll -p 4000:4000 jekyll/jekyll jekyll serve --watch --force_polling }
function jekyll-serve-simple { docker run --rm -v ${PWD}:/site -p 4000:4000 bretfisher/jekyll-serve }
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
alias hugo='docker run --rm -v ${PWD}:/src klakegg/hugo'
alias hugo-serve='docker run --rm -v ${PWD}:/src -p 1313:1313 klakegg/hugo server --bind 0.0.0.0'

# PowerShell
function hugo { docker run --rm -v ${PWD}:/src klakegg/hugo $args }
function hugo-serve { docker run --rm -v ${PWD}:/src -p 1313:1313 klakegg/hugo server --bind 0.0.0.0 }
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
alias mkdocs='docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material'
alias mkdocs-serve='docker run --rm -v ${PWD}:/docs -p 8000:8000 squidfunk/mkdocs-material'

# PowerShell
function mkdocs { docker run --rm -v ${PWD}:/docs squidfunk/mkdocs-material $args }
function mkdocs-serve { docker run --rm -v ${PWD}:/docs -p 8000:8000 squidfunk/mkdocs-material }
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
alias just='docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just"'

# PowerShell
function just { docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "wget -q https://github.com/casey/just/releases/download/1.16.0/just-1.16.0-x86_64-unknown-linux-musl.tar.gz -O- | tar -xz -C /usr/local/bin && just $args" }
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
alias dmake='docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make"'

# PowerShell
function dmake { docker run --rm -v ${PWD}:/workdir -w /workdir alpine sh -c "apk add --no-cache make > /dev/null 2>&1 && make $args" }
```

---

## Terminal Tools

### tmux
Terminal multiplexer for managing multiple sessions.

```bash
# Interactive tmux session
docker run --rm -it alpine sh -c "apk add --no-cache tmux && tmux"

# Using a pre-built image
docker run --rm -it dockcross/linux-x64 tmux
```

**Aliases:**
```bash
# Linux/macOS
alias dtmux='docker run --rm -it alpine sh -c "apk add --no-cache tmux && tmux"'

# PowerShell
function dtmux { docker run --rm -it alpine sh -c "apk add --no-cache tmux && tmux" }
```

---

### htop
Interactive process viewer.

```bash
docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop"
```

**Aliases:**
```bash
# Linux/macOS
alias dhtop='docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop"'

# PowerShell
function dhtop { docker run --rm -it --pid=host alpine sh -c "apk add --no-cache htop && htop" }
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
alias dncdu='docker run --rm -it -v ${PWD}:/data alpine sh -c "apk add --no-cache ncdu && ncdu /data"'

# PowerShell
function dncdu { docker run --rm -it -v ${PWD}:/data alpine sh -c "apk add --no-cache ncdu && ncdu /data" }
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
alias lazygit='docker run --rm -it -v ${PWD}:/repo -w /repo lazyteam/lazygit'

# PowerShell
function lazygit { docker run --rm -it -v ${PWD}:/repo -w /repo lazyteam/lazygit }
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
alias lazydocker='docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker'

# PowerShell
function lazydocker { docker run --rm -it -v /var/run/docker.sock:/var/run/docker.sock lazyteam/lazydocker }
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
alias dranger='docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ranger && ranger"'

# PowerShell
function dranger { docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ranger && ranger" }
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
alias dfzf='docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fzf && find . | fzf"'

# PowerShell
function dfzf { docker run --rm -it -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fzf && find . | fzf" }
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
alias bat='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat"'

# PowerShell
function bat { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache bat > /dev/null 2>&1 && bat $args" }
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
alias rg='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg"'

# PowerShell
function rg { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache ripgrep > /dev/null 2>&1 && rg $args" }
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
alias fd='docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd"'

# PowerShell
function fd { docker run --rm -v ${PWD}:/data -w /data alpine sh -c "apk add --no-cache fd > /dev/null 2>&1 && fd $args" }
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
alias jq='docker run --rm -i ghcr.io/jqlang/jq'

# PowerShell
function jq { docker run --rm -i ghcr.io/jqlang/jq $args }
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
alias yq='docker run --rm -v ${PWD}:/workdir mikefarah/yq'

# PowerShell
function yq { docker run --rm -v ${PWD}:/workdir mikefarah/yq $args }
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
alias dpy='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python'
alias dpip='docker run --rm -v ${PWD}:/app -w /app python:3.12 pip'
alias dipython='docker run --rm -it -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -q ipython && ipython"'

# PowerShell
function dpy { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 python $args }
function dpip { docker run --rm -v ${PWD}:/app -w /app python:3.12 pip $args }
function dipython { docker run --rm -it -v ${PWD}:/app -w /app python:3.12 sh -c "pip install -q ipython && ipython" }
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
alias jupyter='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook'
alias jupyterlab='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/datascience-notebook'
alias jupyter-scipy='docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook'

# PowerShell
function jupyter { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/base-notebook }
function jupyterlab { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/datascience-notebook }
function jupyter-scipy { docker run --rm -p 8888:8888 -v ${PWD}:/home/jovyan/work jupyter/scipy-notebook }
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
alias dnode='docker run --rm -it -v ${PWD}:/app -w /app node:22 node'
alias dnpm='docker run --rm -v ${PWD}:/app -w /app node:22 npm'
alias dnpx='docker run --rm -v ${PWD}:/app -w /app node:22 npx'
alias dyarn='docker run --rm -v ${PWD}:/app -w /app node:22 yarn'

# PowerShell
function dnode { docker run --rm -it -v ${PWD}:/app -w /app node:22 node $args }
function dnpm { docker run --rm -v ${PWD}:/app -w /app node:22 npm $args }
function dnpx { docker run --rm -v ${PWD}:/app -w /app node:22 npx $args }
function dyarn { docker run --rm -v ${PWD}:/app -w /app node:22 yarn $args }
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
alias dgo='docker run --rm -v ${PWD}:/app -w /app golang:1.22 go'

# PowerShell
function dgo { docker run --rm -v ${PWD}:/app -w /app golang:1.22 go $args }
```

---

### Rust
Systems programming with Cargo.

```bash
# Build project
docker run --rm -v ${PWD}:/app -w /app rust:latest cargo build

# Run project
docker run --rm -v ${PWD}:/app -w /app rust:latest cargo run

# Run tests
docker run --rm -v ${PWD}:/app -w /app rust:latest cargo test
```

**Aliases:**
```bash
# Linux/macOS
alias dcargo='docker run --rm -v ${PWD}:/app -w /app rust:latest cargo'
alias drustc='docker run --rm -v ${PWD}:/app -w /app rust:latest rustc'

# PowerShell
function dcargo { docker run --rm -v ${PWD}:/app -w /app rust:latest cargo $args }
function drustc { docker run --rm -v ${PWD}:/app -w /app rust:latest rustc $args }
```

---

### Ruby
Ruby interpreter and gem management.

```bash
# Interactive Ruby shell
docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb

# Run script
docker run --rm -v ${PWD}:/app -w /app ruby:3.3 ruby script.rb

# Bundle install
docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle install
```

**Aliases:**
```bash
# Linux/macOS
alias druby='docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 ruby'
alias dirb='docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb'
alias dbundle='docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle'

# PowerShell
function druby { docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 ruby $args }
function dirb { docker run --rm -it -v ${PWD}:/app -w /app ruby:3.3 irb }
function dbundle { docker run --rm -v ${PWD}:/app -w /app ruby:3.3 bundle $args }
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
alias vscode-server='docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none'

# PowerShell
function vscode-server { docker run --rm -p 8080:8080 -v ${PWD}:/home/coder/project codercom/code-server --auth none }
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
alias rstudio='docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/rstudio'
alias rstudio-tidy='docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/tidyverse'

# PowerShell
function rstudio { docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/rstudio }
function rstudio-tidy { docker run --rm -p 8787:8787 -e PASSWORD=rstudio -v ${PWD}:/home/rstudio rocker/tidyverse }
```

**Note:** Access RStudio at `http://localhost:8787`. Login with username `rstudio` and password `rstudio`.

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
alias playwright='docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright'
alias pw-test='docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test'

# PowerShell
function playwright { docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright $args }
function pw-test { docker run --rm -v ${PWD}:/work -w /work mcr.microsoft.com/playwright:v1.40.0 npx playwright test $args }
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
alias postgres='docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16'
alias dpsql='docker run --rm -it postgres:16 psql'

# PowerShell
function postgres { docker run --rm -p 5432:5432 -e POSTGRES_PASSWORD=secret postgres:16 }
function dpsql { docker run --rm -it postgres:16 psql $args }
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
alias mysql-server='docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:8'
alias dmysql='docker run --rm -it mysql:8 mysql'

# PowerShell
function mysql-server { docker run --rm -p 3306:3306 -e MYSQL_ROOT_PASSWORD=secret mysql:8 }
function dmysql { docker run --rm -it mysql:8 mysql $args }
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
alias redis='docker run --rm -p 6379:6379 redis:7-alpine'
alias dredis-cli='docker run --rm -it redis:7-alpine redis-cli'

# PowerShell
function redis { docker run --rm -p 6379:6379 redis:7-alpine }
function dredis-cli { docker run --rm -it redis:7-alpine redis-cli $args }
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
alias mongo='docker run --rm -p 27017:27017 mongo:7'
alias dmongosh='docker run --rm -it mongo:7 mongosh'

# PowerShell
function mongo { docker run --rm -p 27017:27017 mongo:7 }
function dmongosh { docker run --rm -it mongo:7 mongosh $args }
```

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
```

**Aliases:**
```bash
# Linux/macOS
alias mosquitto='docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto'
alias mqtt-sub='docker run --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal'
alias mqtt-pub='docker run --rm eclipse-mosquitto mosquitto_pub -h host.docker.internal'

# PowerShell
function mosquitto { docker run --rm -p 1883:1883 -p 9001:9001 eclipse-mosquitto }
function mqtt-sub { docker run --rm eclipse-mosquitto mosquitto_sub -h host.docker.internal $args }
function mqtt-pub { docker run --rm eclipse-mosquitto mosquitto_pub -h host.docker.internal $args }
```

**Note:** Port 1883 is for MQTT, port 9001 is for WebSockets. Use `host.docker.internal` to connect to MQTT broker running on your host.

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
alias mqtt-explorer='docker run --rm -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix smeagolworms4/mqtt-explorer'

# Web-based MQTT client (cross-platform)
alias mqtt-web='docker run --rm -p 8080:8080 cedalo/management-center'

# PowerShell (web-based client)
function mqtt-web { docker run --rm -p 8080:8080 cedalo/management-center }
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
alias aws='docker run --rm -v ~/.aws:/root/.aws amazon/aws-cli'

# PowerShell
function aws { docker run --rm -v $HOME/.aws:/root/.aws amazon/aws-cli $args }
```

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
alias az='docker run --rm -v ~/.azure:/root/.azure mcr.microsoft.com/azure-cli az'

# PowerShell
function az { docker run --rm -v $HOME/.azure:/root/.azure mcr.microsoft.com/azure-cli az $args }
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
alias gcloud='docker run --rm -v ~/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud'

# PowerShell
function gcloud { docker run --rm -v $HOME/.config/gcloud:/root/.config/gcloud gcr.io/google.com/cloudsdktool/cloud-sdk gcloud $args }
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
alias terraform='docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform'
alias tf='docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform'

# PowerShell
function terraform { docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform $args }
function tf { docker run --rm -v ${PWD}:/workspace -w /workspace hashicorp/terraform $args }
```

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
alias ansible='docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible'
alias ansible-playbook='docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible-playbook'

# PowerShell
function ansible { docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible $args }
function ansible-playbook { docker run --rm -v ${PWD}:/ansible -w /ansible willhallonline/ansible ansible-playbook $args }
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
alias kubectl='docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl'
alias k='docker run --rm -v ~/.kube:/root/.kube bitnami/kubectl'

# PowerShell
function kubectl { docker run --rm -v $HOME/.kube:/root/.kube bitnami/kubectl $args }
function k { docker run --rm -v $HOME/.kube:/root/.kube bitnami/kubectl $args }
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
alias helm='docker run --rm -v ${PWD}:/apps -v ~/.kube:/root/.kube alpine/helm'

# PowerShell
function helm { docker run --rm -v ${PWD}:/apps -v $HOME/.kube:/root/.kube alpine/helm $args }
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
alias prettier='docker run --rm -v ${PWD}:/work tmknom/prettier'

# PowerShell
function prettier { docker run --rm -v ${PWD}:/work tmknom/prettier $args }
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
alias black='docker run --rm -v ${PWD}:/code cytopia/black'

# PowerShell
function black { docker run --rm -v ${PWD}:/code cytopia/black $args }
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
alias shellcheck='docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable'

# PowerShell
function shellcheck { docker run --rm -v ${PWD}:/mnt koalaman/shellcheck:stable $args }
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
alias hadolint='docker run --rm -i hadolint/hadolint'

# PowerShell
function hadolint { docker run --rm -i hadolint/hadolint }
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
alias markdownlint='docker run --rm -v ${PWD}:/workdir -w /workdir node:22-alpine sh -c "npm install -g markdownlint-cli > /dev/null 2>&1 && markdownlint"'

# PowerShell
function markdownlint { docker run --rm -v ${PWD}:/workdir -w /workdir node:22-alpine sh -c "npm install -g markdownlint-cli > /dev/null 2>&1 && markdownlint $args" }
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
alias pandoc='docker run --rm -v ${PWD}:/data pandoc/latex'

# PowerShell
function pandoc { docker run --rm -v ${PWD}:/data pandoc/latex $args }
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
alias ffmpeg='docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg'

# PowerShell
function ffmpeg { docker run --rm -v ${PWD}:/data jrottenberg/ffmpeg $args }
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
alias magick='docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick'
alias convert='docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick'

# PowerShell
function magick { docker run --rm -v ${PWD}:/imgs dpokidov/imagemagick $args }
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
alias yt-dlp='docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp'

# PowerShell
function yt-dlp { docker run --rm -v ${PWD}:/downloads jauderho/yt-dlp $args }
```

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
alias nmap='docker run --rm -it instrumentisto/nmap'

# PowerShell
function nmap { docker run --rm -it instrumentisto/nmap $args }
```

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
alias dcurl='docker run --rm curlimages/curl'

# PowerShell
function dcurl { docker run --rm curlimages/curl $args }
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
alias trivy='docker run --rm aquasec/trivy'

# PowerShell
function trivy { docker run --rm aquasec/trivy $args }
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
alias testssl='docker run --rm -it drwetter/testssl.sh'

# PowerShell
function testssl { docker run --rm -it drwetter/testssl.sh $args }
```

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
alias swagger-ui='docker run --rm -p 8080:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui'

# PowerShell
function swagger-ui { docker run --rm -p 8080:8080 -e SWAGGER_JSON=/spec/openapi.yaml -v ${PWD}:/spec swaggerapi/swagger-ui }
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
alias http='docker run --rm -it alpine/httpie'

# PowerShell
function http { docker run --rm -it alpine/httpie $args }
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
alias newman='docker run --rm -v ${PWD}:/etc/newman postman/newman'

# PowerShell
function newman { docker run --rm -v ${PWD}:/etc/newman postman/newman $args }
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
alias dgit='docker run --rm -v ${PWD}:/git -w /git alpine/git'

# PowerShell
function dgit { docker run --rm -v ${PWD}:/git -w /git alpine/git $args }
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
alias gh='docker run --rm -v ~/.config/gh:/root/.config/gh -v ${PWD}:/repo -w /repo ghcr.io/github/gh-cli gh'

# PowerShell
function gh { docker run --rm -v $HOME/.config/gh:/root/.config/gh -v ${PWD}:/repo -w /repo ghcr.io/github/gh-cli gh $args }
```

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
