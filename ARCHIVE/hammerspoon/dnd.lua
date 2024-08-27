function enableDND()
    toggleDND("Focus")
end

function disableDND()
    toggleDND("Do Not Disturb")
end

-- applescript to toggle DND
-- TODO: close menu at end of script
function toggleDND(key)
    hs.osascript.applescript(
            string.format(
            [[
    tell application "System Events"
    tell its application process "Control Center"
        tell its menu bar 1
            click its menu bar item "Control Center"
        end tell

        tell its window "Control Center"
            set uiElems to its UI elements
            repeat with elem in uiElems
                if name of elem contains "%s" then
                    click elem
                end if
            end repeat
        end tell
    end tell
    end tell
                        ]]
    , key))
end