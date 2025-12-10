#Requires -Version 5.1
<#
.SYNOPSIS
    Docker Toolbox Manager - PowerShell Functions
.DESCRIPTION
    Provides management commands for Docker Toolbox functions
.NOTES
    Source this file in your PowerShell profile or run directly
#>

# List all dt- functions
function dt-list {
    Write-Host "Installed Docker Toolbox functions:" -ForegroundColor Cyan
    Write-Host ""

    $dtFunctions = Get-Command -Name "dt-*" -CommandType Function -ErrorAction SilentlyContinue |
                   Where-Object { $_.Source -eq '' } |
                   Sort-Object Name

    if ($dtFunctions.Count -eq 0) {
        Write-Host "  No Docker Toolbox functions found" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Run the installer to add tools: .\install.ps1"
        return
    }

    foreach ($func in $dtFunctions) {
        Write-Host "  $($func.Name)" -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Usage: <function-name> [args]" -ForegroundColor Gray
    Write-Host "Example: dt-python --version" -ForegroundColor Gray
}

# Show info about a specific tool
function dt-info {
    param(
        [Parameter(Mandatory=$true)]
        [string]$ToolName
    )

    # Add dt- prefix if not present
    if (-not $ToolName.StartsWith("dt-")) {
        $ToolName = "dt-$ToolName"
    }

    $func = Get-Command -Name $ToolName -CommandType Function -ErrorAction SilentlyContinue

    if (-not $func) {
        Write-Host "Tool '$ToolName' not found" -ForegroundColor Red
        Write-Host "Run 'dt-list' to see available tools"
        return
    }

    Write-Host "Tool: $($func.Name)" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Definition:" -ForegroundColor White

    $definition = $func.Definition
    Write-Host "  $definition" -ForegroundColor Gray
    Write-Host ""

    # Extract Docker image from the definition
    if ($definition -match 'docker run[^"]*?([a-z0-9/_.-]+:[a-z0-9._-]+)') {
        $image = $Matches[1]
    } elseif ($definition -match 'docker run[^"]*?([a-z0-9/_-]+)\s') {
        $image = $Matches[1]
    }

    if ($image) {
        Write-Host "Docker Image: $image" -ForegroundColor White

        # Check if image is pulled
        $imageInfo = docker images $image --format "{{.Repository}}:{{.Tag}}" 2>$null | Where-Object { $_ -eq $image }

        if ($imageInfo) {
            $size = docker images $image --format "{{.Size}}" 2>$null
            Write-Host "Status: Pulled (Size: $size)" -ForegroundColor Green
        } else {
            Write-Host "Status: Not pulled yet (will download on first use)" -ForegroundColor Yellow
        }
    }
}

# Search for tools
function dt-search {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Keyword
    )

    Write-Host "Searching for '$Keyword' in Docker Toolbox functions:" -ForegroundColor Cyan
    Write-Host ""

    $dtFunctions = Get-Command -Name "dt-*" -CommandType Function -ErrorAction SilentlyContinue |
                   Where-Object { $_.Name -like "*$Keyword*" } |
                   Sort-Object Name

    if ($dtFunctions.Count -eq 0) {
        Write-Host "  No functions found matching '$Keyword'" -ForegroundColor Yellow
        return
    }

    foreach ($func in $dtFunctions) {
        Write-Host "  $($func.Name)" -ForegroundColor Green
    }
}

# Update Docker images for installed tools
function dt-update {
    Write-Host "Updating Docker images for installed tools..." -ForegroundColor Cyan
    Write-Host ""

    $dtFunctions = Get-Command -Name "dt-*" -CommandType Function -ErrorAction SilentlyContinue |
                   Where-Object { $_.Source -eq '' }

    if ($dtFunctions.Count -eq 0) {
        Write-Host "No Docker Toolbox functions found" -ForegroundColor Yellow
        return
    }

    # Extract unique Docker images
    $images = @()
    foreach ($func in $dtFunctions) {
        $definition = $func.Definition
        if ($definition -match 'docker run[^"]*?([a-z0-9/_.-]+:[a-z0-9._-]+)') {
            $images += $Matches[1]
        } elseif ($definition -match 'docker run[^"]*?([a-z0-9/_-]+)\s') {
            $images += $Matches[1]
        }
    }

    $images = $images | Select-Object -Unique | Sort-Object

    if ($images.Count -eq 0) {
        Write-Host "No Docker images found" -ForegroundColor Yellow
        return
    }

    Write-Host "Found images:" -ForegroundColor White
    foreach ($image in $images) {
        Write-Host "  $image" -ForegroundColor Gray
    }
    Write-Host ""

    $confirm = Read-Host "Pull latest versions? [y/N]"
    if ($confirm -notmatch '^[Yy]$') {
        Write-Host "Update cancelled" -ForegroundColor Yellow
        return
    }

    Write-Host ""
    foreach ($image in $images) {
        Write-Host "Pulling $image..." -ForegroundColor Cyan
        docker pull $image
        Write-Host ""
    }

    Write-Host "Update complete!" -ForegroundColor Green
}

# Show installed Docker images for dt- tools
function dt-images {
    Write-Host "Docker images used by Docker Toolbox:" -ForegroundColor Cyan
    Write-Host ""

    $dtFunctions = Get-Command -Name "dt-*" -CommandType Function -ErrorAction SilentlyContinue |
                   Where-Object { $_.Source -eq '' }

    if ($dtFunctions.Count -eq 0) {
        Write-Host "No Docker Toolbox functions found" -ForegroundColor Yellow
        return
    }

    # Extract unique Docker images
    $images = @()
    foreach ($func in $dtFunctions) {
        $definition = $func.Definition
        if ($definition -match 'docker run[^"]*?([a-z0-9/_.-]+:[a-z0-9._-]+)') {
            $images += $Matches[1]
        } elseif ($definition -match 'docker run[^"]*?([a-z0-9/_-]+)\s') {
            $images += $Matches[1]
        }
    }

    $images = $images | Select-Object -Unique | Sort-Object

    if ($images.Count -eq 0) {
        Write-Host "No Docker images found" -ForegroundColor Yellow
        return
    }

    Write-Host ("{0,-40} {1,-12} {2}" -f "Image", "Status", "Size") -ForegroundColor White
    Write-Host ("─" * 65) -ForegroundColor Gray

    foreach ($image in $images) {
        $imageInfo = docker images $image --format "{{.Repository}}:{{.Tag}}" 2>$null | Where-Object { $_ -eq $image }

        if ($imageInfo) {
            $size = docker images $image --format "{{.Size}}" 2>$null
            Write-Host ("{0,-40} {1,-12} {2}" -f $image, "Pulled", $size) -ForegroundColor Green
        } else {
            Write-Host ("{0,-40} {1,-12} {2}" -f $image, "Not pulled", "-") -ForegroundColor Yellow
        }
    }
}

# Show help
function dt-help {
    Write-Host @"

Docker Toolbox Manager Commands:

  dt-list              List all installed Docker Toolbox functions
  dt-info <tool>       Show detailed info about a specific tool
  dt-search <keyword>  Search for tools containing keyword
  dt-images            Show Docker images used by installed tools
  dt-update            Pull latest versions of all tool images
  dt-help              Show this help message

Examples:
  dt-list                    # List all tools
  dt-info python             # Show info about dt-python
  dt-search jupyter          # Search for jupyter tools
  dt-images                  # Show image status
  dt-update                  # Update all images

Tool Usage:
  dt-<tool> [args]           # Use any installed tool
  dt-python --version        # Example: check Python version
  dt-node app.js             # Example: run Node.js script

Documentation:
  https://github.com/jaun-xmpro/docker-toolbox

"@ -ForegroundColor White
}

# Export module members if running as module
if ($MyInvocation.InvocationName -ne '.') {
    Export-ModuleMember -Function dt-list, dt-info, dt-search, dt-update, dt-images, dt-help
}
