#!/usr/bin/env bash
set -euo pipefail

DOTF="$(cd "$(dirname "$0")" && pwd)"

info()  { printf "\033[1;34m→\033[0m %s\n" "$1"; }
ok()    { printf "\033[1;32m✓\033[0m %s\n" "$1"; }
warn()  { printf "\033[1;33m!\033[0m %s\n" "$1"; }
err()   { printf "\033[1;31m✗\033[0m %s\n" "$1"; }

# Symlink helper: creates link, backs up existing files
link_file() {
    local src="$1" dst="$2"
    local dst_dir="$(dirname "$dst")"

    [[ ! -d "$dst_dir" ]] && mkdir -p "$dst_dir"

    if [[ -L "$dst" ]]; then
        local current="$(readlink "$dst")"
        if [[ "$current" == "$src" ]]; then
            ok "already linked: $dst"
            return
        fi
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        warn "backing up $dst → ${dst}.bak"
        mv "$dst" "${dst}.bak"
    fi

    ln -s "$src" "$dst"
    ok "linked: $dst → $src"
}

# ─── Homebrew ────────────────────────────────────────────────────────────────

install_homebrew() {
    if command -v brew &>/dev/null; then
        ok "Homebrew already installed"
    else
        info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        eval "$(/opt/homebrew/bin/brew shellenv)"
        ok "Homebrew installed"
    fi
}

install_packages() {
    if [[ ! -f "$DOTF/Brewfile" ]]; then
        err "No Brewfile found"; return 1
    fi
    info "Installing packages from Brewfile..."
    brew bundle --file="$DOTF/Brewfile" --no-lock
    ok "Packages installed"
}

# ─── Symlinks ────────────────────────────────────────────────────────────────

link_dotfiles() {
    info "Linking dotfiles..."

    # Shell
    link_file "$DOTF/zshrc"       "$HOME/.zshrc"
    link_file "$DOTF/p10k.zsh"    "$HOME/.p10k.zsh"
    link_file "$DOTF/aliases"     "$HOME/.aliases"

    # Git
    link_file "$DOTF/gitconfig"   "$HOME/.gitconfig"
    link_file "$DOTF/gitignore"   "$HOME/.gitignore"

    # Tmux
    link_file "$DOTF/tmux/tmux.conf" "$HOME/.tmux.conf"

    # Neovim
    link_file "$DOTF/nvim"        "$HOME/.config/nvim"

    # Ghostty
    link_file "$DOTF/ghostty/config" "$HOME/.config/ghostty/config"

    # Karabiner
    link_file "$DOTF/karabiner.json" "$HOME/.config/karabiner/karabiner.json"

    ok "All dotfiles linked"
}

# ─── macOS defaults ──────────────────────────────────────────────────────────

apply_macos_defaults() {
    info "Applying macOS defaults..."

    if [[ -f "$DOTF/macos/defaults.sh" ]]; then
        bash "$DOTF/macos/defaults.sh"
    fi

    for plist in dock screencapture trackpad window-manager; do
        local file="$DOTF/macos/${plist}.plist"
        if [[ -f "$file" ]]; then
            local domain
            case "$plist" in
                dock)           domain="com.apple.dock" ;;
                screencapture)  domain="com.apple.screencapture" ;;
                trackpad)       domain="com.apple.AppleMultitouchTrackpad" ;;
                window-manager) domain="com.apple.WindowManager" ;;
            esac
            defaults import "$domain" "$file"
            ok "imported $plist"
        fi
    done

    killall Dock Finder SystemUIServer 2>/dev/null || true
    ok "macOS defaults applied"
}

# ─── Shell ───────────────────────────────────────────────────────────────────

setup_shell() {
    # Set zsh as default shell if it isn't already
    if [[ "$SHELL" != */zsh ]]; then
        info "Changing default shell to zsh..."
        chsh -s "$(which zsh)"
        ok "Default shell set to zsh"
    else
        ok "Shell is already zsh"
    fi
}

# ─── Secrets reminder ────────────────────────────────────────────────────────

remind_secrets() {
    echo ""
    info "Manual steps remaining:"
    echo "  1. Create ~/.env.local with API keys (LINEAR_API_KEY, etc.)"
    echo "  2. Copy SSH keys or generate new ones"
    echo "  3. Copy ~/.claude/ settings (or scp from old machine)"
    echo "  4. Run 'p10k configure' if prompt looks wrong"
    echo "  5. Open Ghostty/tmux to verify theme"
    echo ""
}

# ─── Main ────────────────────────────────────────────────────────────────────

usage() {
    echo "Usage: ./setup.sh [command]"
    echo ""
    echo "Commands:"
    echo "  all       Run full setup (default)"
    echo "  link      Symlink dotfiles only"
    echo "  brew      Install Homebrew + packages"
    echo "  macos     Apply macOS defaults"
    echo "  shell     Set default shell to zsh"
    echo ""
}

main() {
    local cmd="${1:-all}"

    case "$cmd" in
        all)
            install_homebrew
            install_packages
            link_dotfiles
            setup_shell
            apply_macos_defaults
            remind_secrets
            ;;
        link)   link_dotfiles ;;
        brew)   install_homebrew && install_packages ;;
        macos)  apply_macos_defaults ;;
        shell)  setup_shell ;;
        -h|--help|help) usage ;;
        *)
            err "Unknown command: $cmd"
            usage
            exit 1
            ;;
    esac
}

main "$@"
