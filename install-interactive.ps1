#Requires -Version 5.1
<#
.SYNOPSIS
    Docker Toolbox - Interactive Setup Script for Windows
.DESCRIPTION
    Add Docker Toolbox functions to your PowerShell profile
.NOTES
    Run with: .\install-interactive.ps1
#>

# Colors
$Colors = @{
    Red = 'Red'; Green = 'Green'; Yellow = 'Yellow'
    Blue = 'Cyan'; Magenta = 'Magenta'; White = 'White'
}

# Tool definitions with descriptions
$AllTools = @(
    @{ Category = 'Terminal Tools'; Name = 'tmux'; Description = 'Terminal multiplexer with session management' }
    @{ Category = 'Terminal Tools'; Name = 'htop'; Description = 'Interactive process viewer' }
    @{ Category = 'Terminal Tools'; Name = 'lazygit'; Description = 'Simple terminal UI for git commands' }
    @{ Category = 'Terminal Tools'; Name = 'lazydocker'; Description = 'Terminal UI for Docker management' }
    @{ Category = 'Terminal Tools'; Name = 'rg'; Description = 'ripgrep - Fast code search tool' }
    @{ Category = 'Terminal Tools'; Name = 'fd'; Description = 'Fast find alternative' }
    @{ Category = 'Terminal Tools'; Name = 'bat'; Description = 'Cat with syntax highlighting' }
    @{ Category = 'Terminal Tools'; Name = 'jq'; Description = 'JSON processor' }
    @{ Category = 'Terminal Tools'; Name = 'yq'; Description = 'YAML/JSON/XML processor' }
    @{ Category = 'Programming Languages'; Name = 'python'; Description = 'Python 3.12 interpreter' }
    @{ Category = 'Programming Languages'; Name = 'node'; Description = 'Node.js 22 runtime' }
    @{ Category = 'Programming Languages'; Name = 'npm'; Description = 'Node package manager' }
    @{ Category = 'Programming Languages'; Name = 'npx'; Description = 'Node package runner' }
    @{ Category = 'Programming Languages'; Name = 'go'; Description = 'Go language compiler' }
    @{ Category = 'Programming Languages'; Name = 'ruby'; Description = 'Ruby interpreter' }
    @{ Category = 'Programming Languages'; Name = 'cargo'; Description = 'Rust package manager' }
    @{ Category = 'Development Environments'; Name = 'jupyter'; Description = 'Jupyter Notebook for data science' }
    @{ Category = 'Development Environments'; Name = 'jupyterlab'; Description = 'JupyterLab interface' }
    @{ Category = 'Development Environments'; Name = 'vscode'; Description = 'VS Code Server in browser' }
    @{ Category = 'Development Environments'; Name = 'rstudio'; Description = 'RStudio for R programming' }
    @{ Category = 'Development Environments'; Name = 'vert'; Description = 'Web-based terminal environment' }
    @{ Category = 'Development Environments'; Name = 'nodered'; Description = 'Node-RED flow programming' }
    @{ Category = 'Development Environments'; Name = 'noderedstart'; Description = 'Start Node-RED container' }
    @{ Category = 'Development Environments'; Name = 'noderedstop'; Description = 'Stop Node-RED container' }
    @{ Category = 'Development Environments'; Name = 'noderedlogs'; Description = 'View Node-RED logs' }
    @{ Category = 'Development Environments'; Name = 'n8n'; Description = 'Workflow automation (Zapier alternative)' }
    @{ Category = 'Development Environments'; Name = 'n8nstart'; Description = 'Start n8n container' }
    @{ Category = 'Development Environments'; Name = 'n8nstop'; Description = 'Stop n8n container' }
    @{ Category = 'Development Environments'; Name = 'n8nlogs'; Description = 'View n8n logs' }
    @{ Category = 'Static Site Generators'; Name = 'jekyll'; Description = 'Ruby-based static site generator' }
    @{ Category = 'Static Site Generators'; Name = 'hugo'; Description = 'Fast Go-based site generator' }
    @{ Category = 'Static Site Generators'; Name = 'mkdocs'; Description = 'Python documentation generator' }
    @{ Category = 'Code Quality'; Name = 'prettier'; Description = 'Code formatter for JS/CSS/HTML' }
    @{ Category = 'Code Quality'; Name = 'black'; Description = 'Python code formatter' }
    @{ Category = 'Code Quality'; Name = 'shellcheck'; Description = 'Shell script linter' }
    @{ Category = 'DevOps & Cloud'; Name = 'aws'; Description = 'AWS CLI' }
    @{ Category = 'DevOps & Cloud'; Name = 'az'; Description = 'Azure CLI' }
    @{ Category = 'DevOps & Cloud'; Name = 'gcloud'; Description = 'Google Cloud CLI' }
    @{ Category = 'DevOps & Cloud'; Name = 'terraform'; Description = 'Infrastructure as code' }
    @{ Category = 'DevOps & Cloud'; Name = 'kubectl'; Description = 'Kubernetes CLI' }
    @{ Category = 'DevOps & Cloud'; Name = 'helm'; Description = 'Kubernetes package manager' }
    @{ Category = 'Databases'; Name = 'postgres'; Description = 'PostgreSQL server' }
    @{ Category = 'Databases'; Name = 'psql'; Description = 'PostgreSQL client' }
    @{ Category = 'Databases'; Name = 'mysql'; Description = 'MySQL server' }
    @{ Category = 'Databases'; Name = 'redis'; Description = 'Redis cache server' }
    @{ Category = 'Databases'; Name = 'mongo'; Description = 'MongoDB server' }
    @{ Category = 'Message Brokers & IoT'; Name = 'mosquitto'; Description = 'MQTT broker for IoT messaging' }
    @{ Category = 'Message Brokers & IoT'; Name = 'mqttsub'; Description = 'MQTT subscribe client' }
    @{ Category = 'Message Brokers & IoT'; Name = 'mqttpub'; Description = 'MQTT publish client' }
    @{ Category = 'Message Brokers & IoT'; Name = 'mosquittopasswd'; Description = 'Mosquitto password file manager' }
    @{ Category = 'Security & Networking'; Name = 'trivy'; Description = 'Container vulnerability scanner' }
    @{ Category = 'Security & Networking'; Name = 'nmap'; Description = 'Network scanner' }
    @{ Category = 'Media & Documents'; Name = 'pandoc'; Description = 'Universal document converter' }
    @{ Category = 'Media & Documents'; Name = 'ffmpeg'; Description = 'Video/audio processing' }
    @{ Category = 'Media & Documents'; Name = 'typst'; Description = 'Modern typesetting system' }
    @{ Category = 'Media & Documents'; Name = 'latex'; Description = 'LaTeX document preparation system' }
    @{ Category = 'Media & Documents'; Name = 'pdflatex'; Description = 'LaTeX PDF compiler' }
    @{ Category = 'Media & Documents'; Name = 'xelatex'; Description = 'XeLaTeX compiler (Unicode support)' }
    @{ Category = 'Media & Documents'; Name = 'lualatex'; Description = 'LuaLaTeX compiler' }
    @{ Category = 'Media & Documents'; Name = 'bibtex'; Description = 'BibTeX bibliography processor' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollama'; Description = 'Run LLMs locally (Llama, Mistral, etc)' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollamastart'; Description = 'Start Ollama server' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollamastop'; Description = 'Stop Ollama server' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollamarun'; Description = 'Run an Ollama model' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollamapull'; Description = 'Pull an Ollama model' }
    @{ Category = 'AI & Machine Learning'; Name = 'ollamalist'; Description = 'List Ollama models' }
    @{ Category = 'AI & Machine Learning'; Name = 'openwebui'; Description = 'ChatGPT-style UI for Ollama' }
    @{ Category = 'AI & Machine Learning'; Name = 'openwebuistart'; Description = 'Start Open WebUI container' }
    @{ Category = 'AI & Machine Learning'; Name = 'openwebuistop'; Description = 'Stop Open WebUI container' }
    @{ Category = 'AI & Machine Learning'; Name = 'openwebuilogs'; Description = 'View Open WebUI logs' }
)

# Parse docker-dev-tools.md to extract tool definitions
function Get-ToolDefinitions {
    $mdPath = Join-Path $PSScriptRoot "docker-dev-tools.md"

    if (-not (Test-Path $mdPath)) {
        Write-Host "Error: docker-dev-tools.md not found" -ForegroundColor Red
        exit 1
    }

    $content = Get-Content $mdPath -Raw
    $definitions = @{}

    # Pattern for single-line functions (everything on one line, closing brace on same line as opening)
    $singlelinePattern = '^function\s+(dt\w+)\s*\{[^\r\n]+\}\s*$'
    $singlelineMatches = [regex]::Matches($content, $singlelinePattern, [System.Text.RegularExpressions.RegexOptions]::Multiline)

    # Pattern for multiline functions (opening brace followed by newline, closing brace on its own line)
    # Must have opening { at end of line (only whitespace after), and closing } on its own line
    $multilinePattern = '(?ms)^function\s+(dt\w+)\s*\{\s*\r?\n.+?^\}\s*$'
    $multilineMatches = [regex]::Matches($content, $multilinePattern)

    # Add single-line functions FIRST (these are unambiguous)
    foreach ($match in $singlelineMatches) {
        $fullFunction = $match.Value
        $functionName = $match.Groups[1].Value
        $toolName = $functionName -replace '^dt', ''
        $definitions[$toolName] = $fullFunction
    }

    # Add multiline functions (only if not already added as single-line)
    foreach ($match in $multilineMatches) {
        $fullFunction = $match.Value
        $functionName = $match.Groups[1].Value
        $toolName = $functionName -replace '^dt', ''
        if (-not $definitions.ContainsKey($toolName)) {
            # Additional validation: ensure function is reasonable size (< 100 lines)
            $lineCount = ($fullFunction -split "`n").Count
            if ($lineCount -lt 100) {
                $definitions[$toolName] = $fullFunction
            }
        }
    }

    return $definitions
}

# Banner
function Show-Banner {
    Clear-Host
    Write-Host @"
    ____             __                ______            __ __
   / __ \____  _____/ /_____  _____   /_  __/___  ____  / / /_  ____  _  __
  / / / / __ \/ ___/ //_/ _ \/ ___/    / / / __ \/ __ \/ / __ \/ __ \| |/_/
 / /_/ / /_/ / /__/ ,< /  __/ /       / / / /_/ / /_/ / / /_/ / /_/ />  <
/_____/\____/\___/_/|_|\___/_/       /_/  \____/\____/_/_.___/\____/_/|_|

"@ -ForegroundColor $Colors.Blue
    Write-Host 'Docker Toolbox - Interactive Setup (Windows)' -ForegroundColor $Colors.Blue
    Write-Host ''
}

# Show tool selection using Out-GridView
function Show-ToolSelection {
    Write-Host 'Opening tool selection window...' -ForegroundColor $Colors.Yellow
    Write-Host 'Tip: Hold Ctrl to select multiple tools' -ForegroundColor $Colors.Blue
    Write-Host ''

    $toolsForGrid = $AllTools | ForEach-Object {
        [PSCustomObject]@{
            'Tool Name' = "dt$($_.Name)"
            'Category' = $_.Category
            'Description' = $_.Description
            'Internal' = $_.Name
        }
    } | Sort-Object Category, 'Tool Name'

    $selected = $toolsForGrid | Out-GridView -Title "Select Tools to Add to Profile" -OutputMode Multiple

    if (-not $selected) {
        Write-Host 'No tools selected.' -ForegroundColor $Colors.Yellow
        exit 0
    }

    return $selected.Internal
}

# Check if Docker is installed
function Test-DockerInstalled {
    try {
        $null = docker --version 2>$null
        return $true
    }
    catch {
        return $false
    }
}

# Initialize profile
function Initialize-Profile {
    if (-not (Test-Path $PROFILE)) {
        New-Item -Path $PROFILE -ItemType File -Force | Out-Null
        Write-Host 'Created PowerShell profile' -ForegroundColor $Colors.Green
    }
    else {
        Write-Host 'Found PowerShell profile' -ForegroundColor $Colors.Green
    }
}

# Backup profile
function Backup-Profile {
    $timestamp = Get-Date -Format 'yyyyMMddHHmmss'
    $backupPath = "$PROFILE.backup.$timestamp"
    Copy-Item -Path $PROFILE -Destination $backupPath -Force
    Write-Host "Backed up profile" -ForegroundColor $Colors.Green
}

# Check if Docker Toolbox exists
function Test-DockerToolboxExists {
    $content = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
    return $content -match '# Docker Toolbox functions'
}

# Remove old section
function Remove-OldDockerToolbox {
    $content = Get-Content $PROFILE -Raw
    $pattern = '(?s)# Docker Toolbox functions.*?# End Docker Toolbox functions\r?\n'
    $newContent = $content -replace $pattern, ''
    Set-Content -Path $PROFILE -Value $newContent -NoNewline
}

# Add tools to profile
function Add-ToolsToProfile {
    param([string[]]$ToolNames, [hashtable]$Definitions)

    Write-Host "`nAdding functions to profile..." -ForegroundColor $Colors.Blue
    Backup-Profile

    if (Test-DockerToolboxExists) {
        Remove-OldDockerToolbox
    }

    $functions = @()
    $functions += ''
    $functions += '# Docker Toolbox functions'
    $functions += "# Added: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
    $functions += ''

    # Convert hashtables to PSCustomObjects for proper grouping
    $selectedToolsInfo = $AllTools | Where-Object { $_.Name -in $ToolNames } | ForEach-Object {
        [PSCustomObject]@{
            Category = $_.Category
            Name = $_.Name
            Description = $_.Description
        }
    }

    $categories = $selectedToolsInfo | Group-Object Category

    foreach ($category in $categories) {
        $categoryName = $category.Name
        if ([string]::IsNullOrWhiteSpace($categoryName)) {
            $categoryName = 'Other Tools'
        }
        $functions += "# $categoryName"
        foreach ($tool in $category.Group) {
            $def = $Definitions[$tool.Name]
            if ($def) {
                $functions += $def
                Write-Host "  + dt$($tool.Name)" -ForegroundColor $Colors.Green
            }
        }
        $functions += ''
    }

    $functions += '# End Docker Toolbox functions'
    $functions += ''

    $functions | ForEach-Object { Add-Content -Path $PROFILE -Value $_ }
    Write-Host "`nFunctions saved to profile!" -ForegroundColor $Colors.Green
}

# Show summary
function Show-Summary {
    param([string[]]$ToolNames)

    Write-Host "`n$('=' * 60)" -ForegroundColor $Colors.Green
    Write-Host "Added $($ToolNames.Count) functions to profile" -ForegroundColor $Colors.Green
    Write-Host "$('=' * 60)" -ForegroundColor $Colors.Green
    Write-Host ''
    Write-Host 'To load the functions now, run:' -ForegroundColor $Colors.Yellow
    Write-Host '  . $PROFILE' -ForegroundColor $Colors.Magenta
    Write-Host ''
    Write-Host 'Or restart PowerShell.' -ForegroundColor $Colors.Yellow
    Write-Host ''
    Write-Host 'To see all loaded functions:' -ForegroundColor $Colors.Yellow
    Write-Host '  Get-Command dt* -CommandType Function' -ForegroundColor $Colors.Magenta
    Write-Host ''
    Write-Host 'To add/remove tools later:' -ForegroundColor $Colors.Yellow
    Write-Host '  Run this installer again (.\install-interactive.ps1)' -ForegroundColor $Colors.Magenta
    Write-Host '  Or manually edit: notepad $PROFILE' -ForegroundColor $Colors.Magenta
    Write-Host ''
}

# Main
Show-Banner

if ($PSVersionTable.PSVersion.Major -lt 5) {
    Write-Host 'Error: PowerShell 5.1+ required' -ForegroundColor Red
    exit 1
}

Write-Host 'Checking Docker...' -ForegroundColor $Colors.Blue
if (-not (Test-DockerInstalled)) {
    Write-Host 'Error: Docker not installed' -ForegroundColor Red
    exit 1
}

Write-Host 'Docker found' -ForegroundColor $Colors.Green
Write-Host ''

Write-Host 'NOTICE: Tools use official Docker images and are tested, but provided' -ForegroundColor $Colors.Yellow
Write-Host '        "as-is". Verify tools meet your requirements. See README.md' -ForegroundColor $Colors.Yellow
Write-Host ''

Initialize-Profile
Write-Host ''

Write-Host 'Loading tool definitions from docker-dev-tools.md...' -ForegroundColor $Colors.Blue
$definitions = Get-ToolDefinitions
Write-Host "Found $($definitions.Count) tool definitions" -ForegroundColor $Colors.Green
Write-Host ''

$selectedTools = Show-ToolSelection

Write-Host "`nSelected $($selectedTools.Count) functions to add" -ForegroundColor $Colors.Blue
$confirm = Read-Host 'Add these functions to your profile? [Y/n]'

if ($confirm -match '^[Nn]') {
    Write-Host 'Cancelled' -ForegroundColor $Colors.Yellow
    exit 0
}

Add-ToolsToProfile -ToolNames $selectedTools -Definitions $definitions
Show-Summary -ToolNames $selectedTools

Write-Host 'Press any key to exit...'
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown')
