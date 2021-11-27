----------------------------------------------------------------------------------------------------
-- Load Dependencies
require "wifi"
require "bluetooth"
require "layouts"

----------------------------------------------------------------------------------------------------
-- Global Settings
local log = hs.logger.new('hammerspoon', 'debug')
local hyper = { "cmd", "alt", "ctrl", "shift" }

 --set a minimal style for all alerts and print them at the top of the screen
hs.alert.defaultStyle = {
    strokeWidth = 2,
    strokeColor = { white = 0, alpha = 0 },
    fillColor = { white = 1, alpha = 0.5 },
    textColor = { black = 1, alpha = 1 },
    textFont = ".AppleSystemUIFont",
    textSize = 18,
    radius = 2,
    atScreenEdge = 0, -- 1 for top, 2 for bottom
    fadeInDuration = 0.15,
    fadeOutDuration = 0.15,
    padding = nil,
}

hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- Reload config
hs.hotkey.bind(hyper, "R", "Reload Configuration", function()
    hs.reload()
end)
hs.notify.new({ title = "Hammerspoon", informativeText = "Config loaded" }):send()

----------------------------------------------------------------------------------------------------
-- Load Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.use_syncinstall = true

Install = spoon.SpoonInstall -- make more readable

-- Autoreload
Install:andUse("ReloadConfiguration")
spoon.ReloadConfiguration:start()

Install:andUse("TimeMachineProgress",
        {
            start = true
        }
)

Install:andUse("ModalMgr")
Install:andUse("WinWin")
Install:andUse("HammerText")

----------------------------------------------------------------------------------------------------
hs.hotkey.bind(hyper, "f", function()
    hs.hints.windowHints()
end)
----------------------------------------------------------------------------------------------------
-- Connect Airpods
--
spoon.ModalMgr:new("bluetoothM")
local cmodal = spoon.ModalMgr.modal_list["bluetoothM"]
cmodal:bind('', 'escape', 'Deactivate appM', function()
    spoon.ModalMgr:deactivate({ "bluetoothM" })
end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
    spoon.ModalMgr:toggleCheatsheet()
end)

bm_keys = bm_keys or { hyper, "B" }
if string.len(bm_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(bm_keys[1], bm_keys[2], "Enter Bluetooth Environment", function()
        hs.alert.show("Entering bluetoothM...")
        spoon.ModalMgr:deactivateAll()
        spoon.ModalMgr:activate({ "bluetoothM" }, "#FFBD2E")
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
        spoon.ModalMgr:deactivate({ "bluetoothM" })
    end)
end

----------------------------------------------------------------------------------------------------
-- Layout Menubar
--
layout = {}
function layout:new()
    local this = { workspace = "", profile = "", menu = hs.menubar.new() }

    function this:Set(workspace, profile)
        if workspace ~= "" then
            this.workspace = workspace
        end
        if profile ~= "" then
            this.profile = profile
        end

        if self.workspace ~= "" then
            title = self.workspace
        end

        if self.profile ~= "" then
            if title ~= "" then
                title = title .. " - "
            end
            title = title .. self.profile
        end

        self.menu:setTitle(title)
    end

    return this
end

current_layout = layout:new()
current_layout:Set("none", "none")

----------------------------------------------------------------------------------------------------
-- Switch Brave Profiles
spoon.ModalMgr:new("braveM")
local cmodal = spoon.ModalMgr.modal_list["braveM"]
cmodal:bind('', 'escape', 'Deactivate appM', function()
    spoon.ModalMgr:deactivate({ "braveM" })
end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
    spoon.ModalMgr:toggleCheatsheet()
end)

br_keys = br_keys or { hyper, "P" }
if string.len(br_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(br_keys[1], br_keys[2], "Enter Brave Environment", function()
        hs.alert.show("Entering braveM...")
        spoon.ModalMgr:deactivateAll()
        spoon.ModalMgr:activate({ "braveM" }, "#FFBD2E")
    end)
end

br_list = {
    { key = "p", name = "Personal", params = { "Profiles", "alberto" } },
    { key = "a", name = "Akorda", params = { "Profiles", "akorda" } },
    { key = "i", name = "Incognito", params = { "File", "New Private Window" } },
    { key = "m", name = "Moonshot", params = { "Profiles", "moonshot" } },
    { key = "c", name = "Crypto", params = { "Profiles", "crypto" } },
    { key = "t", name = "Tiny Rockets - Meaningful", params = { "Profiles", "meaningful" } },
}

for _, v in ipairs(br_list) do
    cmodal:bind('', v.key, v.title, function()
        hs.application.launchOrFocus("Brave Browser")
        local brave = hs.application.find("Brave Browser")
        brave:selectMenuItem(v.params, true)
        current_layout:Set("", v.name)
        spoon.ModalMgr:deactivate({ "braveM" })
    end)
end

----------------------------------------------------------------------------------------------------
-- Workspaces

hs.application.enableSpotlightForNameSearches(true)

spoon.ModalMgr:new("workspaceM")
local cmodal = spoon.ModalMgr.modal_list["workspaceM"]
cmodal:bind('', 'escape', 'Deactivate appM', function()
    spoon.ModalMgr:deactivate({ "workspaceM" })
end)
cmodal:bind('', 'tab', 'Toggle Cheatsheet', function()
    spoon.ModalMgr:toggleCheatsheet()
end)

w_keys = w_keys or { hyper, "W" }
if string.len(w_keys[2]) > 0 then
    spoon.ModalMgr.supervisor:bind(w_keys[1], w_keys[2], "Enter Workspaces", function()
        hs.alert.show("Entering workspaceM...")
        spoon.ModalMgr:deactivateAll()
        spoon.ModalMgr:activate({ "workspaceM" }, "#FFBD2E")
    end)
end

w_list = {
    {
        key = "w", name = "writing", apps = {
        { name = "Logseq", main = true, position = hs.layout.maximized },
        { name = "Dictionary", main = true, position = hs.layout.left25 },
        { name = "Spotify", main = false, position = units.top50 },
    }, wifi = false,
    },
    {
        key = "p", name = "programming", apps = {
        { name = "/Users/aesadde/Applications/JetBrains Toolbox/GoLand.app", main = true, position = hs.layout.maximized },
        { name = "Slack", main = false, position = units.top50 },
        { name = "Spotify", main = false, position = units.bottom50 },
    }, wifi = true,
    }
}

function applyLayout(params)

    main_monitor = hs.screen.primaryScreen():name()
    second_monitor = main_monitor
    multi = #hs.screen.allScreens() > 1
    if multi then
        second_monitor = hs.screen.allScreens()[2]:name()
    end
    hs.alert.show(string.format("using multiple monitors: %s", multi))

    layout = {}
    for _, v in ipairs(params.apps) do
        monitor = main_monitor
        position = hs.layout.maximized
        if multi then
            position = v.position
            if not v.main then
                monitor = second_monitor
            end
        end
        startApp(v.name)
        l = { v.name, nil, monitor, position, nil, nil }
        print(string.format("%s: %s, %s", v.name, monitor, position))
        table.insert(layout, l)
    end
    hs.layout.apply(layout)
    hs.application.launchOrFocus(params.apps[1].name)

    toggleWifi(params.wifi)
end

for _, v in ipairs(w_list) do
    cmodal:bind('', v.key, v.name, function()
        current_layout:Set(v.name, "")
        applyLayout(v)
        spoon.ModalMgr:deactivate({ "workspaceM" })
    end)
end

-- Finally we initialize ModalMgr supervisor
spoon.ModalMgr.supervisor:enter()
