-- From https://zzamboni.org/post/my-hammerspoon-configuration-with-commentary/

function stopApp(name)
  app = hs.application.get(name)
  if not app then
      app = hs.application.find(name)
  end
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

units = {
  right30 = { x = 0.70, y = 0.00, w = 0.30, h = 1.00 },
  right70 = { x = 0.30, y = 0.00, w = 0.70, h = 1.00 },
  left70 = { x = 0.00, y = 0.00, w = 0.70, h = 1.00 },
  left30 = { x = 0.00, y = 0.00, w = 0.30, h = 1.00 },
  top50 = { x = 0.00, y = 0.00, w = 1.00, h = 0.50 },
  bot50 = { x = 0.00, y = 0.50, w = 1.00, h = 0.50 },
  bot80 = { x = 0.00, y = 0.20, w = 1.00, h = 0.80 },
  bot87 = { x = 0.00, y = 0.20, w = 1.00, h = 0.87 },
  bot90 = { x = 0.00, y = 0.20, w = 1.00, h = 0.90 },
  upright30 = { x = 0.70, y = 0.00, w = 0.30, h = 0.50 },
  botright30 = { x = 0.70, y = 0.50, w = 0.30, h = 0.50 },
  upleft70 = { x = 0.00, y = 0.00, w = 0.70, h = 0.50 },
  botleft70 = { x = 0.00, y = 0.50, w = 0.70, h = 0.50 },
  right70top80 = { x = 0.70, y = 0.00, w = 0.30, h = 0.80 },
  maximum = { x = 0.00, y = 0.00, w = 1.00, h = 1.00 },
  center = { x = 0.25, y = 0.00, w = 0.50, h = 1.00 }
}

