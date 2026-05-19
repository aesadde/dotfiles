#!/usr/bin/env bash
#
# macOS defaults — extracted from current system (2026-05-18)
# Run on a fresh Mac after installing apps. Requires logout/restart for some.
#
# Based on the old ~/dotfiles/osx script, updated to match actual current prefs.

# Ask for sudo upfront
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Disable menu bar transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Auto-switch between light and dark mode
defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true

# Hide menu bar in fullscreen
defaults write NSGlobalDomain AppleMenuBarVisibleInFullscreen -bool false

# Don't minimize on double-click
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Disable desktop tinting reduction
defaults write NSGlobalDomain AppleReduceDesktopTinting -bool false

# Click scrollbar to jump to the spot
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true

# Show scrollbars when scrolling
defaults write NSGlobalDomain AppleShowScrollBars -string "WhenScrolling"

# Show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Set highlight color to gray
defaults write NSGlobalDomain AppleHighlightColor -string "0.500000 0.500000 0.500000 Other"

# 24-hour time
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

# Temperature in Fahrenheit
defaults write NSGlobalDomain AppleTemperatureUnit -string "Fahrenheit"

# Subpixel font rendering on non-Apple LCDs
defaults write NSGlobalDomain AppleFontSmoothing -int 2

# Anti-aliasing threshold
defaults write NSGlobalDomain AppleAntiAliasingThreshold -int 4

# Fast window resize
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Disable window opening animations
defaults write NSGlobalDomain NSAutomaticWindowAnimationsEnabled -bool false

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Save to disk, not iCloud, by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Display ASCII control characters using caret notation
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Disable Resume system-wide
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true

# Disable smart quotes (annoying when typing code)
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Enable auto-capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true

# Enable period substitution (double-space = period)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Enable spell correction
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool true

# Enable text completion
defaults write NSGlobalDomain NSAutomaticTextCompletionEnabled -bool true

###############################################################################
# Keyboard, Trackpad, Mouse                                                   #
###############################################################################

# Full keyboard access for all controls (Tab in modal dialogs)
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Blazingly fast key repeat
defaults write NSGlobalDomain KeyRepeat -float 2
defaults write NSGlobalDomain InitialKeyRepeat -float 15

# Fn key = normal function keys (not special features)
defaults write NSGlobalDomain com.apple.keyboard.fnState -bool false

# Tap to click
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Mouse tracking speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float 0.5

# Disable scroll wheel acceleration
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.0

# Trackpad tracking speed
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 0.6875

# Force click enabled
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true

# Spring loading for directories
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.833

# Zoom with Ctrl + scroll
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true

###############################################################################
# Sound                                                                       #
###############################################################################

# Disable feedback sound when changing volume
defaults write NSGlobalDomain com.apple.sound.beep.feedback -int 0

# Disable screen flash on alert
defaults write NSGlobalDomain com.apple.sound.beep.flash -int 0

# UI sounds enabled
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -int 1

###############################################################################
# Language & Region                                                           #
###############################################################################

defaults write NSGlobalDomain AppleLanguages -array "en-US" "it-US" "es-US"
defaults write NSGlobalDomain AppleLocale -string "en_US"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Inches"
defaults write NSGlobalDomain AppleMetricUnits -bool false

###############################################################################
# Finder                                                                      #
###############################################################################

# Allow quitting via ⌘Q (hides desktop icons)
defaults write com.apple.finder QuitMenuItem -bool true

# Disable Finder animations
defaults write com.apple.finder DisableAllAnimations -bool true

# New window opens Desktop
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/"

# Don't show drives on desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Show status bar and path bar
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Full POSIX path in title bar
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Search current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# No warning on file extension change
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Icon view by default
defaults write com.apple.finder FXPreferredViewStyle -string "icnv"

# Expand File Info panes
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Avoid .DS_Store on network volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Show ~/Library
chflags nohidden ~/Library

###############################################################################
# Screen                                                                      #
###############################################################################

# Require password after sleep/screensaver
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 30

###############################################################################
# Terminal / TextEdit / Activity Monitor                                      #
###############################################################################

# UTF-8 only in Terminal.app
defaults write com.apple.terminal StringEncodings -array 4

# Plain text mode for TextEdit
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Activity Monitor: show main window, CPU icon, all processes, sort by CPU
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true
defaults write com.apple.ActivityMonitor IconType -int 5
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

###############################################################################
# Kill affected apps                                                          #
###############################################################################

for app in "Activity Monitor" "cfprefsd" "Dock" "Finder" "SystemUIServer" "Terminal"; do
    killall "${app}" > /dev/null 2>&1
done
echo "Done. Some changes require logout/restart."
