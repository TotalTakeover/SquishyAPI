---@meta _
-- local squassets
-- local assetPath = "./SquAssets"
-- if pcall(require, assetPath) then squassets = require(assetPath) end
-- assert(squassets, "§4The base module requires SquAssets, which was not found!§c")

---@class base
local base = {}
base.all = {}

---*CONSTRUCTOR


function base:new()
    ---@class SquAPI.base
    local self = {}




    self = setmetatable(self, {__index = base})
    table.insert(base.all, self)
    return self
end


--*CONTROL FUNCTIONS

---base enable handling
function base:disable() self.enabled = false return self end
function base:enable() self.enabled = true return self end
function base:toggle() self.enabled = not self.enabled return self end

---@param bool boolean
function base:setEnabled(bool)
    self.enabled = bool or false
    return self
end



--*UPDATE FUNCTIONS



return base