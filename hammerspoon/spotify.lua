-- From https://github.com/AWildDevAppears/hammerspoon-config/blob/master/spotify.lua

local spotify = {}

function spotify.playing(prefix)
    local album = hs.spotify.getCurrentAlbum()
    local artist = hs.spotify.getCurrentArtist()
    local track = hs.spotify.getCurrentTrack()
    local message = prefix .. artist .. " - " .. track .. " - " .. album

    hs.alert.show(message)
end

function spotify.toggle()
    if (hs.spotify.isPlaying()) then
        spotify.playing("Paused: ")
        hs.spotify.pause()
    else
        spotify.playing("Playing: ")
        hs.spotify.play()
    end
end

function spotify.nextNotify()
    hs.spotify.next()
    hs.timer.doAfter(0.5, function() spotify.playing("Playing: ") end)
end

function spotify.previousNotify()
    hs.spotify.previous()
    hs.timer.doAfter(0.5, function() spotify.playing("Playing: ") end)
end

return spotify
