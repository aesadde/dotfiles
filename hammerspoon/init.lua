----------------------------------------------------------------------------------------------------
-- Load Dependencies
require "wifi"
require "bluetooth"
local spotify = require "spotify"


----------------------------------------------------------------------------------------------------
-- Global Settings
local log = hs.logger.new('hammerspoon','debug')
local hyper = {"cmd", "alt", "ctrl","shift"}

hs.hotkey.alertDuration=0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- Reload config
hs.hotkey.bind(hyper, "R", "Reload Configuration", function() hs.reload() end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

----------------------------------------------------------------------------------------------------
-- Load Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

Install=spoon.SpoonInstall -- make more readable

-- Autoreload
Install:andUse("ReloadConfiguration")
spoon.ReloadConfiguration:start()

Install:andUse("TextClipboardHistory",
               {
                 disable = false,
                 config = {
                   show_in_menubar = true,
                 },
                 hotkeys = {
                   toggle_clipboard = { hyper, "v" } },
                 start = true,
               }
)

Install:andUse("KSheet",
               {
                 hotkeys = {
                   toggle = { hyper, "/" }
}})

Install:andUse("TimeMachineProgress",
               {
                 start = true
               }
)

Install:andUse("ModalMgr")
Install:andUse("WinWin")

----------------------------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "f", function() hs.hints.windowHints() end)

spoon.ModalMgr:new("appM")
local appModal = spoon.ModalMgr.modal_list["appM"]
appModal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"appM"}) end)
appModal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
appM_keys = appM_keys or {hyper, "A"}
if string.len(appM_keys[2]) > 0 then
spoon.ModalMgr.supervisor:bind(appM_keys[1], appM_keys[2], "Enter App Environment", function()
      hs.alert.show("Entering appM...")
      spoon.ModalMgr:deactivateAll()
      spoon.ModalMgr:activate({"appM"}, "#FFBD2E")
  end)
end

-- App shortcuts
local app_list = {
  b = '/Applications/Brave Browser.app',
  c = '/Applications/Visual Studio Code.app',
  e = '/Applications/Evernote.app',
  t = '/Applications/iTerm.app',
  n = '/Applications/Notion.app',
  m = '/Applications/Spotify.app',
  s = '/Applications/Slack.app',
}
for key, app in pairs(app_list) do
   appModal:bind('', key, app, function()
            hs.application.launchOrFocus(app)
            spoon.ModalMgr:deactivate({"appM"})
        end)
end

----------------------------------------------------------------------------------------------------
-- Connect Airpods
--
spoon.ModalMgr:new("bluetoothM")
local cmodal = spoon.ModalMgr.modal_list["bluetoothM"]
cmodal:bind('', 'escape', 'Deactivate appM', function() spoon.ModalMgr:deactivate({"bluetoothM"}) end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)

bm_keys = bm_keys or {hyper, "B"}
if string.len(bm_keys[2]) > 0 then
spoon.ModalMgr.supervisor:bind(bm_keys[1], bm_keys[2], "Enter Bluetooth Environment", function()
      hs.alert.show("Entering bluetoothM...")
      spoon.ModalMgr:deactivateAll()
      spoon.ModalMgr:activate({"bluetoothM"}, "#FFBD2E")
  end)
end

b_list = {
  { key = "P", name = "Alberto’s AirPods Pro", title = "Airpods" },
  { key = "B", name = "audifonos aes", title = "Bose" },
  { key = "M", name = "Bose Revolve SoundLink", title = "Speaker" },
}

for _, v in ipairs(b_list) do
cmodal:bind('', v.key, v.title, function()
  local ok, output = connectBluetooth(v.name)
  if ok then
    hs.alert.show(output)
  else
    hs.alert.show("Couldn't connect to " + v.title)
  end
  spoon.ModalMgr:deactivate({"bluetoothM"})
end)
end

----------------------------------------------------------------------------------------------------
-- Register lock screen
-- hslock_keys = hslock_keys or {hyper, "L"}
-- if string.len(hslock_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "Lock Screen", function()
--         os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
--     end)
-- end

----------------------------------------------------------------------------------------------------
-- Spotify Keys
--
hs.hotkey.bind({}, "f7", function()
  spotify.previousNotify()
end)

hs.hotkey.bind({}, "f8", function()
  spotify.toggle()
end)

hs.hotkey.bind({}, "f9", function()
  spotify.nextNotify()
end)
----------------------------------------------------------------------------------------------------
-- resizeM modal environment
if spoon.WinWin then
    spoon.ModalMgr:new("resizeM")
    local cmodal = spoon.ModalMgr.modal_list["resizeM"]
    cmodal:bind('', 'escape', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'Q', 'Deactivate resizeM', function() spoon.ModalMgr:deactivate({"resizeM"}) end)
    cmodal:bind('', 'tab', 'Toggle Cheatsheet', function() spoon.ModalMgr:toggleCheatsheet() end)
    cmodal:bind('', 'A', 'Move Leftward', function() spoon.WinWin:stepMove("left") end, nil, function() spoon.WinWin:stepMove("left") end)
    cmodal:bind('', 'D', 'Move Rightward', function() spoon.WinWin:stepMove("right") end, nil, function() spoon.WinWin:stepMove("right") end)
    cmodal:bind('', 'W', 'Move Upward', function() spoon.WinWin:stepMove("up") end, nil, function() spoon.WinWin:stepMove("up") end)
    cmodal:bind('', 'S', 'Move Downward', function() spoon.WinWin:stepMove("down") end, nil, function() spoon.WinWin:stepMove("down") end)
    cmodal:bind('', 'H', 'Lefthalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfleft") end)
    cmodal:bind('', 'L', 'Righthalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfright") end)
    cmodal:bind('', 'K', 'Uphalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfup") end)
    cmodal:bind('', 'J', 'Downhalf of Screen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("halfdown") end)
    cmodal:bind('', 'Y', 'NorthWest Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNW") end)
    cmodal:bind('', 'O', 'NorthEast Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerNE") end)
    cmodal:bind('', 'U', 'SouthWest Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSW") end)
    cmodal:bind('', 'I', 'SouthEast Corner', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("cornerSE") end)
    cmodal:bind('', 'F', 'Fullscreen', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("fullscreen") end)
    cmodal:bind('', 'C', 'Center Window', function() spoon.WinWin:stash() spoon.WinWin:moveAndResize("center") end)
    cmodal:bind('', '=', 'Stretch Outward', function() spoon.WinWin:moveAndResize("expand") end, nil, function() spoon.WinWin:moveAndResize("expand") end)
    cmodal:bind('', '-', 'Shrink Inward', function() spoon.WinWin:moveAndResize("shrink") end, nil, function() spoon.WinWin:moveAndResize("shrink") end)
    cmodal:bind('shift', 'H', 'Move Leftward', function() spoon.WinWin:stepResize("left") end, nil, function() spoon.WinWin:stepResize("left") end)
    cmodal:bind('shift', 'L', 'Move Rightward', function() spoon.WinWin:stepResize("right") end, nil, function() spoon.WinWin:stepResize("right") end)
    cmodal:bind('shift', 'K', 'Move Upward', function() spoon.WinWin:stepResize("up") end, nil, function() spoon.WinWin:stepResize("up") end)
    cmodal:bind('shift', 'J', 'Move Downward', function() spoon.WinWin:stepResize("down") end, nil, function() spoon.WinWin:stepResize("down") end)
    cmodal:bind('', 'left', 'Move to Left Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("left") end)
    cmodal:bind('', 'right', 'Move to Right Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("right") end)
    cmodal:bind('', 'up', 'Move to Above Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("up") end)
    cmodal:bind('', 'down', 'Move to Below Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("down") end)
    cmodal:bind('', 'space', 'Move to Next Monitor', function() spoon.WinWin:stash() spoon.WinWin:moveToScreen("next") end)
    cmodal:bind('', '[', 'Undo Window Manipulation', function() spoon.WinWin:undo() end)
    cmodal:bind('', ']', 'Redo Window Manipulation', function() spoon.WinWin:redo() end)
    cmodal:bind('', '`', 'Center Cursor', function() spoon.WinWin:centerCursor() end)

    -- Register resizeM with modal supervisor
    hsresizeM_keys = hsresizeM_keys or {hyper, "R"}
    if string.len(hsresizeM_keys[2]) > 0 then
        spoon.ModalMgr.supervisor:bind(hsresizeM_keys[1], hsresizeM_keys[2], "Enter resizeM Environment", function()
            -- Deactivate some modal environments or not before activating a new one
            spoon.ModalMgr:deactivateAll()
            -- Show an status indicator so we know we're in some modal environment now
            spoon.ModalMgr:activate({"resizeM"}, "#B22222")
        end)
    end
end

----------------------------------------------------------------------------------------------------
-- -- Register Hammerspoon console
-- hsconsole_keys = hsconsole_keys or {"opt", "Z"}
-- if string.len(hsconsole_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hsconsole_keys[1], hsconsole_keys[2], "Toggle Hammerspoon Console", function() hs.toggleConsole() end)
-- end

----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
