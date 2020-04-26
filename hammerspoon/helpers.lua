-- From https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/

function stopApp(name)
  app = hs.application.get(name)
  if app and app:isRunning() then
    app:kill()
  end
end

function forceKillProcess(name)
  hs.execute("pkill " .. name)
end

function startApp(name)
  hs.application.open(name)
end
