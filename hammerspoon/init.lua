-- global
local hyper = {"cmd", "alt", "ctrl","shift"}
local log = hs.logger.new('hammerspoon','debug')

----------------------------------------------------------------------------------------------------
-- Load Dependencies
require "wifi"
require "airpods"
-- require "reminders"

-- Reload config
hs.hotkey.bind(hyper, "R", function()
  hs.reload()
end)
hs.notify.new({title="Hammerspoon", informativeText="Config loaded"}):send()

----------------------------------------------------------------------------------------------------
-- Load Spoons
if not hspoon_list then
    hspoon_list = {
        "HSearch",
        "WinWin",
    }
end

-- Load those Spoons
for _, v in pairs(hspoon_list) do
    hs.loadSpoon(v)
end

----------------------------------------------------------------------------------------------------
-- Window Management
hs.window.animationDuration = 0

hs.hotkey.bind(hyper, "h", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToUnit(hs.layout.left50)
end)
hs.hotkey.bind(hyper, "j", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToUnit(hs.layout.maximized)
end)
hs.hotkey.bind(hyper, "k", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToScreen(win:screen():next())
end)
hs.hotkey.bind(hyper, "l", function()
  local win = hs.window.focusedWindow();
  if not win then return end
win:moveToUnit(hs.layout.right50)
end)

hs.hotkey.bind(hyper, "f", function() hs.hints.windowHints() end)

----------------------------------------------------------------------------------------------------
-- App shortcuts
local applicationHotkeys = {
  b = '/Applications/Brave Browser.app',
  c = '/Applications/Visual Studio Code.app',
  e = '/Applications/Evernote.app',
  t = '/Applications/iTerm.app',
  n = '/Applications/Notion.app',
  m = '/Applications/Spotify.app',
  s = '/Applications/Slack.app',
}
for key, app in pairs(applicationHotkeys) do
  hs.hotkey.bind(hyper, key, function()
    hs.application.launchOrFocus(app)
  end)
end

----------------------------------------------------------------------------------------------------
-- Connect Airpods
hs.hotkey.bind(hyper, "x", function()
  local ok, output = airPods("Alberto’s AirPods Pro")
  if ok then
    hs.alert.show(output)
  else
    hs.alert.show("Couldn't connect to AirPods!")
  end
end)

----------------------------------------------------------------------------------------------------
-- Reminders
-- FIXME: NOT WORKING
-- hs.hotkey.bind(hyper, "t", addReminder)
