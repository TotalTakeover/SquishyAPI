---@meta _
local squassets
local assetPath = "./SquAssets"
if pcall(require, assetPath) then squassets = require(assetPath) end
assert(squassets, "§4The ear module requires SquAssets, which was not found!§c")


---@class ear
local ear = {}
ear.all = {}

---*CONSTRUCTOR
---@param leftEar ModelPart The left ear's model path.
---@param rightEar? ModelPart The right ear's model path, if you don't have a right ear, just leave this blank or set to nil.
---@param rangeMultiplier? number Defaults to `1`, how far the ears should rotate with your head.
---@param horizontalEars? boolean Defaults to `false`, if you have elf-like ears(ears that stick out horizontally), set this to true.
---@param bendStrength? number Defaults to `2`, how much the ears should move when you move.
---@param doEarFlick? boolean Defaults to `true`, whether or not the ears should randomly flick.
---@param earFlickChance? number Defaults to `400`, how often the ears should flick in ticks, timer is random between 0 to n ticks.
---@param earStiffness? number Defaults to `0.1`, how stiff the ears should be.
---@param earBounce? number Defaults to `0.8`, how bouncy the ears should be.
---@return SquAPI.Ear
function ear:new(leftEar, rightEar, rangeMultiplier, horizontalEars, bendStrength, doEarFlick,
                        earFlickChance, earStiffness, earBounce)
    ---@class SquAPI.ear
    local self = {}

    assert(leftEar, "§4The first ear's model path is incorrect.§c")
    self.leftEar = leftEar
    self.rightEar = rightEar
    self.horizontalEars = horizontalEars
    self.rangeMultiplier = rangeMultiplier or 1
    if self.horizontalEars then self.rangeMultiplier = self.rangeMultiplier / 2 end
    self.bendStrength = bendStrength or 2
    earStiffness = earStiffness or 0.1
    earBounce = earBounce or 0.8

    if doEarFlick == nil then doEarFlick = true end
    self.doEarFlick = doEarFlick
    self.earFlickChance = earFlickChance or 400

    self.eary = squassets.BERP:new(earStiffness, earBounce)
    self.earx = squassets.BERP:new(earStiffness, earBounce)
    self.earz = squassets.BERP:new(earStiffness, earBounce)
    self.targets = { 0, 0, 0 }
    self.oldpose = "STANDING"

    self.enabled = true

    self = setmetatable(self, {__index = ear})
    table.insert(ear.all, self)
    return self
end


--*CONTROL FUNCTIONS

---ear enable handling
function ear:disable() self.enabled = false return self end
function ear:enable() self.enabled = true return self end
function ear:toggle() self.enabled = not self.enabled return self end

---@param bool boolean
function ear:setEnabled(bool)
    self.enabled = bool or false
    return self
end



--*UPDATE FUNCTIONS

function ear:tick()
    if self.enabled then
      local vel = math.min(math.max(-0.75, squassets.forwardVel()), 0.75)
      local yvel = math.min(math.max(-1.5, squassets.verticalVel()), 1.5) * 5
      local svel = math.min(math.max(-0.5, squassets.sideVel()), 0.5)
      local headrot = squassets.getHeadRot()
      local bend = self.bendStrength
      if headrot[1] < -22.5 then bend = -bend end

      --gives the ears a short push when crouching/uncrouching
      local pose = player:getPose()
      if pose == "CROUCHING" and self.oldpose == "STANDING" then
        self.eary.vel = self.eary.vel + 5 * self.bendStrength
      elseif pose == "STANDING" and self.oldpose == "CROUCHING" then
        self.eary.vel = self.eary.vel - 5 * self.bendStrength
      end
      self.oldpose = pose

      --main physics
      if self.horizontalEars then
        local rot = 10 * bend * (yvel + vel * 10) + headrot[1] * self.rangeMultiplier
        local addrot = headrot[2] * self.rangeMultiplier
        self.targets[2] = rot + addrot
        self.targets[3] = -rot + addrot
      else
        self.targets[1] = headrot[1] * self.rangeMultiplier + 2 * bend * (yvel + vel * 15)
        self.targets[2] = headrot[2] * self.rangeMultiplier - svel * 100 * self.bendStrength
        self.targets[3] = self.targets[2]
      end

      --ear flicking
      if self.doEarFlick then
        if math.random(0, self.earFlickChance) == 1 then
          if math.random(0, 1) == 1 then
            self.earx.vel = self.earx.vel + 50
          else
            self.earz.vel = self.earz.vel - 50
          end
        end
      end
    else
      self.leftEar:setOffsetRot(0, 0, 0)
      self.rightEar:setOffsetRot(0, 0, 0)
    end
end


---@param dt number Tick delta
function ear:render(dt, _)
    if self.enabled then
      self.eary:berp(self.targets[1], dt)
      self.earx:berp(self.targets[2], dt)
      self.earz:berp(self.targets[3], dt)

      local rot3 = self.earx.pos / 4
      local rot3b = self.earz.pos / 4

      if self.horizontalEars then
        local y = self.eary.pos / 4
        self.leftEar:setOffsetRot(y, self.earx.pos / 3, rot3)
        if self.rightEar then
          self.rightEar:setOffsetRot(y, self.earz.pos / 3, rot3b)
        end
      else
        self.leftEar:setOffsetRot(self.eary.pos, rot3, rot3)
        if self.rightEar then
          self.rightEar:setOffsetRot(self.eary.pos, rot3b, rot3b)
        end
      end
    end
end

return ear