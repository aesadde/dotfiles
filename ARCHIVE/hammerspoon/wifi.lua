-- From: https://medium.com/@robhowlett/hammerspoon-the-best-mac-software-youve-never-heard-of-40c2df6db0f8
local wifiMenu = hs.menubar.new()
function ssidChangedCallback()
    SSID = hs.wifi.currentNetwork()
    if SSID == nil then
        SSID = "off"
    end
    wifiMenu:setTitle("(" .. SSID .. ")" )
end
wifiWatcher = hs.wifi.watcher.new(ssidChangedCallback)
wifiWatcher:start()
ssidChangedCallback()

-- toggleWifi sets the Wifi Power according to the boolean value in `toggle`
function toggleWifi(toggle)
    power = hs.wifi.setPower(toggle) -- wifi on/off
    if power then
        msg = "wifi: off"
        if toggle then
            msg = "wifi: on"
        end
        hs.alert.show(msg)
    end
end