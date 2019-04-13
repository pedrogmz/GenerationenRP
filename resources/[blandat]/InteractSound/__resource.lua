
------
-- InteractSound by Scott
-- Verstion: v0.0.1
------

-- Manifest Version
resource_manifest_version '77731fab-63ca-442c-a67b-abc70f28dfa5'

-- Client Scripts
client_script 'client/main.lua'

-- Server Scripts
server_script 'server/main.lua'

-- NUI Default Page
ui_page('client/html/index.html')

-- Files needed for NUI
-- DON'T FORGET TO ADD THE SOUND FILES TO THIS!
files({
    'client/html/index.html',
    -- Begin Sound Files Here...
    -- client/html/sounds/ ... .ogg
    'client/html/sounds/on.ogg',
    'client/html/sounds/off.ogg',
    'client/html/sounds/detector.ogg',
    'client/html/sounds/demo.ogg',
    'client/html/sounds/cell.ogg',
    'client/html/sounds/cuffs.ogg',
    'client/html/sounds/vakt.ogg',
    'client/html/sounds/saw.ogg',
    'client/html/sounds/tanten.ogg',
    'client/html/sounds/klockor.ogg'
})
