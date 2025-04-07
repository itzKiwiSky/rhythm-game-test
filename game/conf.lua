function love.conf(w)
    --% Window %--
    w.window.width          =       1280
    w.window.height         =       768
    w.window.icon           =       "icon.png"
    w.window.title          =       "untitled game"
    w.window.x              =       nil
    w.window.y              =       nil
    w.window.borderless     =       false
    w.window.resizable      =       true
    w.window.fullscreen     =       false
    w.window.depth          =       love._version_major >= 12 and true or 16
    w.window.vsync          =       0
    w.highdpi               =       true

    --% Debug %--
    w.console               =       not love.filesystem.isFused()

    --% Storage %--
    w.externalstorage       =       true
    w.identity              =       "com.kiwistaion.factory"

    --% Modules %--
    w.modules.audio         =       true
    w.modules.data          =       true
    w.modules.event         =       true
    w.modules.font          =       true
    w.modules.graphics      =       true
    w.modules.image         =       true
    w.modules.joystick      =       true
    w.modules.keyboard      =       true
    w.modules.math          =       true
    w.modules.mouse         =       true
    w.modules.physics       =       true
    w.modules.sound         =       true
    w.modules.system        =       true
    w.modules.thread        =       true
    w.modules.timer         =       true
    w.modules.touch         =       true
    w.modules.video         =       true
    w.modules.window        =       true
end