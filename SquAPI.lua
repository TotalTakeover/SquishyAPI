--[[--------------------------------------------------------------------------------------
███████╗ ██████╗ ██╗   ██╗██╗███████╗██╗  ██╗██╗   ██╗     █████╗ ██████╗ ██╗
██╔════╝██╔═══██╗██║   ██║██║██╔════╝██║  ██║╚██╗ ██╔╝    ██╔══██╗██╔══██╗██║
███████╗██║   ██║██║   ██║██║███████╗███████║ ╚████╔╝     ███████║██████╔╝██║
╚════██║██║▄▄ ██║██║   ██║██║╚════██║██╔══██║  ╚██╔╝      ██╔══██║██╔═══╝ ██║
███████║╚██████╔╝╚██████╔╝██║███████║██║  ██║   ██║       ██║  ██║██║     ██║
╚══════╝ ╚══▀▀═╝  ╚═════╝ ╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝       ╚═╝  ╚═╝╚═╝     ╚═╝
--]] --------------------------------------------------------------------------------------ANSI Shadow

-- Author: Squishy
-- Discord tag: @mrsirsquishy

-- Version: 1.2.0
-- Legal: ARR

-- Special Thanks to
-- FOX (@bitslayn) for doing all the work for proper annotations and the module system, as well as for fleshing out some functionality.
-- @jimmyhelp for errors and just generally helping me get things working.


-- IMPORTANT FOR NEW USERS!!! READ THIS!!!

-- Thank you for using SquAPI! Unless you're experienced and wish to actually modify the functionality
-- of this script, I wouldn't recommend snooping around.
-- Don't know exactly what you're doing? this site contains a guide on how to use!(also linked on github):
-- https://mrsirsquishy.notion.site/Squishy-API-Guide-3e72692e93a248b5bd88353c96d8e6c5

-- this SquAPI file does have some mini-documentation on paramaters if you need like a quick reference, but
-- do not modify, and do not copy-paste code from this file unless you are an avid scripter who knows what they are doing.


-- Don't be afraid to ask me for help, just make sure to provide as much info as possible so I or someone can help you faster.






--setup stuff

---@class SquAPI
local squapi = {}


-- SQUAPI CONTROL VARIABLES AND CONFIG ----------------------------------------------------------
-- these variables can be changed to control certain features of squapi.


--when true it will automatically tick and update all the functions, when false it won't do that.<br>
--if false, you can run each objects respective tick/update functions on your own - better control.
squapi.autoFunctionUpdates = true





-- FUNCTIONS --------------------------------------------------------------------------------------------------------------



-- Require modules (could not have been made without FOX's foundation)
local modulesPath = "./SquAPI_modules"
local moduleNames = {
    "arm",
    "animateTexture",
    "bewb",
    "bounceWalk",
    "crouch",
    "ear",
    "eye",
    "FPHand",
    "hoverPoint",
    "leg",
    "randimation",
    "smoothHead",
    "tail",
    "taur",
    "squishy",
}
local tick = {}
local render = {}

for _, moduleName in pairs(moduleNames) do

  local script = modulesPath .. "."  .. moduleName

  if pcall(require, script) then

    local module = require(script)
    squapi[moduleName] = module
    
    if type(module) == "table" then
      if module.tick then
          table.insert(tick, module)
      end

      if module.render then
          table.insert(render, module)
      end
    end
  end
end


-- AUTO FUNCTION UPDATES --------------------------------------------------------------------------------------------

if squapi.autoFunctionUpdates then
  function events.tick()
    for _, v in ipairs(tick) do
        for _, object in ipairs(v.all) do
            object:tick()
        end
    end
  end

  function events.render(dt, context)
    for _, v in ipairs(render) do
        for _, object in ipairs(v.all) do
            object:render(dt, context)
        end
    end
  end
end

return squapi