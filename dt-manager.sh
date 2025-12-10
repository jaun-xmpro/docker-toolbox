#!/usr/bin/env bash
#
# Docker Toolbox Manager - Shell Functions
# Provides management commands for Docker Toolbox aliases
#

# List all dt- aliases
dt-list() {
    echo "Installed Docker Toolbox aliases:"
    echo ""
    alias | grep "^alias dt-" | sed 's/alias /  /' | sed "s/=.*//" | sort
    echo ""
    echo "Usage: <alias-name> [args]"
    echo "Example: dt-python --version"
}

# Show info about a specific tool
dt-info() {
    if [ -z "$1" ]; then
        echo "Usage: dt-info <tool-name>"
        echo "Example: dt-info python"
        return 1
    fi

    local tool="dt-$1"
    local alias_def=$(alias "$tool" 2>/dev/null)

    if [ -z "$alias_def" ]; then
        echo "Tool '$tool' not found"
        echo "Run 'dt-list' to see available tools"
        return 1
    fi

    echo "Tool: $tool"
    echo ""
    echo "Definition:"
    echo "$alias_def" | sed 's/alias [^=]*=//' | sed "s/^'/  /" | sed "s/'$//"
    echo ""

    # Extract Docker image from the alias
    local image=$(echo "$alias_def" | grep -oP 'docker run[^'"'"']*?\K[a-z0-9/_.-]+:[a-z0-9._-]+|docker run[^'"'"']*?\K[a-z0-9/_-]+(?=\s)' | head -1)
    if [ -n "$image" ]; then
        echo "Docker Image: $image"

        # Check if image is pulled
        if docker images "$image" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null | grep -q "$image"; then
            local size=$(docker images "$image" --format "{{.Size}}" 2>/dev/null)
            echo "Status: Pulled (Size: $size)"
        else
            echo "Status: Not pulled yet (will download on first use)"
        fi
    fi
}

# Search for tools in config file
dt-search() {
    if [ -z "$1" ]; then
        echo "Usage: dt-search <keyword>"
        echo "Example: dt-search python"
        return 1
    fi

    echo "Searching for '$1' in Docker Toolbox aliases:"
    echo ""
    alias | grep "^alias dt-" | grep -i "$1" | sed 's/alias /  /' | sort
}

# Update Docker images for installed tools
dt-update() {
    echo "Updating Docker images for installed tools..."
    echo ""

    local images=$(alias | grep "^alias dt-" | grep -oP 'docker run[^'"'"']*?\K[a-z0-9/_.-]+:[a-z0-9._-]+|docker run[^'"'"']*?\K[a-z0-9/_-]+(?=\s)' | sort -u)

    if [ -z "$images" ]; then
        echo "No Docker Toolbox images found"
        return 0
    fi

    echo "Found images:"
    echo "$images" | sed 's/^/  /'
    echo ""

    read -p "Pull latest versions? [y/N]: " confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Update cancelled"
        return 0
    fi

    echo ""
    while IFS= read -r image; do
        echo "Pulling $image..."
        docker pull "$image"
        echo ""
    done <<< "$images"

    echo "Update complete!"
}

# Show installed Docker images for dt- tools
dt-images() {
    echo "Docker images used by Docker Toolbox:"
    echo ""

    local images=$(alias | grep "^alias dt-" | grep -oP 'docker run[^'"'"']*?\K[a-z0-9/_.-]+:[a-z0-9._-]+|docker run[^'"'"']*?\K[a-z0-9/_-]+(?=\s)' | sort -u)

    if [ -z "$images" ]; then
        echo "No Docker Toolbox images found"
        return 0
    fi

    echo "Image                                    Status       Size"
    echo "─────────────────────────────────────────────────────────────"

    while IFS= read -r image; do
        if docker images "$image" --format "{{.Repository}}:{{.Tag}}" 2>/dev/null | grep -q "$image"; then
            local size=$(docker images "$image" --format "{{.Size}}" 2>/dev/null)
            printf "%-40s %-12s %s\n" "$image" "Pulled" "$size"
        else
            printf "%-40s %-12s %s\n" "$image" "Not pulled" "-"
        fi
    done <<< "$images"
}

# Show help
dt-help() {
    cat << 'EOF'
Docker Toolbox Manager Commands:

  dt-list              List all installed Docker Toolbox aliases
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
EOF
}

# Export functions
export -f dt-list dt-info dt-search dt-update dt-images dt-help
