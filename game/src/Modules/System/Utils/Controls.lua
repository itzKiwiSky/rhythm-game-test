local InputController = {}
InputController.actions = {}
InputController.joysticks = {}

local ActionBind = {}
ActionBind.__index = ActionBind

function ActionBind.new(name, bindings)
    local self = setmetatable({}, ActionBind)
    self.name = name
    self.binds = bindings or {}
    self.pressed = false
    return self
end

function ActionBind:update()
    
end

function InputController.addJoystick(joystick)
    table.insert(InputController.joysticks, joystick)
end

function InputController.removeJoystick(joystick)
    for i, j in ipairs(InputController.joysticks) do
        if j == joystick then
            table.remove(InputController.joysticks, i)
            break
        end
    end
end

return InputController