----------------------------------------------------------------------------------------------------
-- Load Dependencies
require "wifi"
require "bluetooth"

----------------------------------------------------------------------------------------------------
-- Global Settings
local log = hs.logger.new('hammerspoon','debug')
local hyper = {"cmd", "alt", "ctrl","shift"}

local app_list = {
  b = '/Applications/Brave Browser.app',
  c = '/Applications/Visual Studio Code.app',
  e = '/Applications/Evernote.app',
  t = '/Applications/iTerm.app',
  n = '/Applications/Notion.app',
  m = '/Applications/Spotify.app',
  s = '/Applications/Slack.app',
  R = "/Applications/Roam/Roam.app"
}

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
Install:andUse("HammerText")

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
-- Window Layouts
-- Monitors
current_layout = hs.menubar.new()

units = {
  right30       = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right70       = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70        = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left30        = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50         = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50         = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  bot80         = { x = 0.00, y = 0.20, w = 1.00, h = 0.80 },
  bot87         = { x = 0.00, y = 0.20, w = 1.00, h = 0.87 },
  bot90         = { x = 0.00, y = 0.20, w = 1.00, h = 0.90 },
  upright30     = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright30    = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  upleft70      = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
  botleft70     = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  right70top80  = { x = 0.70, y = 0.00, w = 0.30, h = 0.80 },
  maximum       = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  center        = { x = 0.25, y = 0.00, w = 0.50, h = 1.00 }
}

macbook_monitor = "Color LCD"
second_monitor = 'HP VH240a'
maing_monitor = "LG ULTRAWIDE"

-- WRITING LAYOUT
local writing_layout = {
  {"Roam", nil, main_monitor, units.center, nil, nil},
  {"Dictionary", nil, main_monitor, hs.layout.left25, nil, nil},
  {"Spotify", nil, second_monitor,    units.top50,   nil, nil},

}

hs.hotkey.bind(hyper, '1', function()
  hs.application.launchOrFocus("Dictionary")
  hs.application.launchOrFocus("Spotify")
  hs.application.launchOrFocus("Roam")
  hs.layout.apply(writing_layout)
  current_layout:setTitle("WRITING MODE")
end)

-- TERMINAL LAYOUT
local terminal_layout = {
  {"Slack", nil, main_monitor,    hs.layout.right50,   nil, nil},
  {"iTerm2", nil, main_monitor, hs.layout.left50, nil, nil},
}

hs.hotkey.bind(hyper, '2', function()
  hs.application.launchOrFocus("Slack")
  hs.application.launchOrFocus("iTerm")
  hs.layout.apply(terminal_layout)
  current_layout:setTitle("TERMINAL MODE")
end)

local reading_layout = {
  {"Roam", nil, main_monitor, hs.layout.left50, nil, nil},
  {"Brave Browser", nil, main_monitor,    hs.layout.right50,   nil, nil},
}

hs.hotkey.bind(hyper, '3', function()
  hs.application.launchOrFocus("Roam")
  hs.application.launchOrFocus("Brave Browser")
  hs.layout.apply(reading_layout)
  current_layout:setTitle("READING MODE")
end)

----------------------------------------------------------------------------------------------------
-- Register lock screen
-- hslock_keys = hslock_keys or {hyper, "L"}
-- if string.len(hslock_keys[2]) > 0 then
--     spoon.ModalMgr.supervisor:bind(hslock_keys[1], hslock_keys[2], "Lock Screen", function()
--         os.execute("/System/Library/CoreServices/Menu\\ Extras/User.menu/Contents/Resources/CGSession -suspend")
--     end)
-- end
----------------------------------------------------------------------------------------------------
-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
