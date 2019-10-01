--modulo principal para a execucao do love

local scene, player
local Scene = {}
Scene.__index = Scene
local Player = {}
Player.__index = Player
local Strongneg = {}
Strongneg.__index = Strongneg
local Strongpos = {}
Strongpos.__index = Strongpos
local Simplepos = {}
Simplepos.__index = Simplepos
local Slowpos = {}
Slowpos.__index = Slowpos
local Simpleneg = {}
Simpleneg.__index = Simpleneg
local Large = {}
Large.__index = Large
local p1 = {}
local st_neg = {}
local st_pos = {}
local sp_pos = {}
local sl_pos = {}
local sp_neg = {}
local lrg = {}

local triangle = {
   x1  = 0,
   y1 = -4,
   x2  = 2,
   y2 = 4,
   x3 = -2,
   y3 = 4,
}
local camera = {}

function camera:set()
   love.graphics.push()
   love.graphics.rotate(-self.rotation)
   love.graphics.scale(1 / self.scaleX, 1 / self.scaleY)
   love.graphics.translate(-self.x, -self.y)
end

function camera:unset()
   love.graphics.pop()
end

function camera:move(dx, dy)
   self.x = self.x + (dx or 0)
   self.y = self.y + (dy or 0)
end

function camera:rotate(dr)
   self.rotation = self.rotation + dr
end

function camera:scale(sx, sy)
   sx = sx or 1
   self.scaleX = self.scaleX * sx
   self.scaleY = self.scaleY * (sy or sx)
end

function camera:setPosition(x, y)
   self.x = x or self.x
   self.y = y or self.y
end

function camera:setScale(sx, sy)
   self.scaleX = sx or self.scaleX
   self.scaleY = sy or self.scaleY
end

local function random_circle(min, max, length)
   local coord = love.math.random(min, max)
   while ((coord + length > max) or (coord - length < min)) do
      coord = love.math.random(min, max)
   end
   return coord
end

function love.load(arg)
   local width = love.graphics.getWidth()
   local height = love.graphics.getHeight()
   camera.x = -width/2
   camera.y = -height/2
   camera.scaleX = 1
   camera.scaleY = 1
   camera.rotation = 0
   scene = arg[1]
   scene = setmetatable(assert(love.filesystem.load(scene))(), Scene)
   player = setmetatable(assert(love.filesystem.load("entity/player.lua"))(), Player)
   p1.x = 0
   p1.y = 0
   p1.vx = 0
   p1.vy = 0
   p1.accel = player.control.acceleration
   p1.max_sp = player.control.max_speed
   p1.fstr = player.field.strength
   p1.raio = 10
   local strongneg = setmetatable(assert(love.filesystem.load("entity/strongneg.lua"))(), Strongneg)
   for i = 1, scene[2].n do
      st_neg[i] = {}
      st_neg[i].raio = strongneg.body.size
      st_neg[i].x = random_circle(-850, 850, strongneg.body.size)
      st_neg[i].y = random_circle(-850, 850, strongneg.body.size)
      st_neg[i].fstr = strongneg.field.strength
   end
   local strongpos = setmetatable(assert(love.filesystem.load("entity/strongpos.lua"))(), Strongpos)
   for i = 1, scene[3].n do
      st_pos[i] = {}
      st_pos[i].raio = strongneg.body.size
      st_pos[i].x = random_circle(-850, 850, st_pos[i].raio)
      st_pos[i].y = random_circle(-850, 850, st_pos[i].raio)
      st_pos[i].fstr = strongpos.field.strength
      st_pos[i].cstr = strongpos.charge.strength
   end
   local simplepos = setmetatable(assert(love.filesystem.load("entity/simplepos.lua"))(), Simplepos)
   for i = 1, scene[4].n do
      sp_pos[i] = {}
      sp_pos[i].raio = 10
      sp_pos[i].x = random_circle(-850, 850, sp_pos[i].raio)
      sp_pos[i].y = random_circle(-850, 850, sp_pos[i].raio)
      sp_pos[i].cstr = simplepos.charge.strength
   end
   local slowpos = setmetatable(assert(love.filesystem.load("entity/slowpos.lua"))(), Slowpos)
   for i = 1, scene[5].n do
      sl_pos[i] = {}
      sl_pos[i].raio = slowpos.body.size
      sl_pos[i].x = random_circle(-850, 850, sl_pos[i].raio)
      sl_pos[i].y = random_circle(-850, 850, sl_pos[i].raio)
      sl_pos[i].cstr = slowpos.charge.strength
   end
   local simpleneg = setmetatable(assert(love.filesystem.load("entity/simpleneg.lua"))(), Simpleneg)
   for i = 1, scene[6].n do
      sp_neg[i] = {}
      sp_neg[i].raio = 10
      sp_neg[i].x = random_circle(-850, 850, sp_neg[i].raio)
      sp_neg[i].y = random_circle(-850, 850, sp_neg[i].raio)
      print(sp_neg[i].x)
      print(sp_neg[i].y)
      sp_neg[i].cstr = simpleneg.charge.strength
   end
   local large = setmetatable(assert(love.filesystem.load("entity/large.lua"))(), Large)
   for i = 1, scene[7].n do
      lrg[i] = {}
      lrg[i].raio = large.body.size
      lrg[i].x = random_circle(-850, 850, lrg[i].raio)
      lrg[i].y = random_circle(-850, 850, lrg[i].raio)
   end
end

function love.update(dt)
   if love.keyboard.isDown("right") then
      if p1.vx <= p1.max_sp then
         p1.vx = p1.vx + p1.accel * dt
      end
      local pos_vxt = (p1.vx * dt)
      p1.x = p1.x + pos_vxt
      triangle.x1 = triangle.x1 + pos_vxt
      triangle.x2 = triangle.x2 + pos_vxt
      triangle.x3 = triangle.x3 + pos_vxt
      camera.x = camera.x + pos_vxt
   elseif love.keyboard.isDown("left") then
      if p1.vx >= -p1.max_sp then
         p1.vx = p1.vx - p1.accel * dt
      end
      local neg_vxt = (p1.vx * dt)
      p1.x = p1.x + neg_vxt
      triangle.x1 = triangle.x1 + neg_vxt
      triangle.x2 = triangle.x2 + neg_vxt
      triangle.x3 = triangle.x3 + neg_vxt
      camera.x = camera.x + neg_vxt
   end
   if love.keyboard.isDown("up") then
      if p1.vy >= -p1.max_sp then
         p1.vy = p1.vy - p1.accel * dt
      end
      local neg_vyt = (p1.vy * dt)
      p1.y = p1.y + neg_vyt
      triangle.y1 = triangle.y1 + neg_vyt
      triangle.y2 = triangle.y2 + neg_vyt
      triangle.y3 = triangle.y3 + neg_vyt
      camera.y = camera.y + neg_vyt
   elseif love.keyboard.isDown("down") then
      if p1.vy <= p1.max_sp then
         p1.vy = p1.vy + p1.accel * dt
      end
      local pos_vyt = (p1.vy * dt)
      p1.y = p1.y + pos_vyt
      triangle.y1 = triangle.y1 + pos_vyt
      triangle.y2 = triangle.y2 + pos_vyt
      triangle.y3 = triangle.y3 + pos_vyt
      camera.y = camera.y + pos_vyt
   end
end

function love.draw()
   camera:set()
   love.graphics.setColor(1, 1, 1)
   for i = 1, 7 do
      if (scene[i].n > 0) then
         for j = 1, scene[i].n do
            if (scene[i].entity == "player") then
               love.graphics.setColor(0, 0, 1)
               love.graphics.circle("line", p1.x, p1.y, p1.raio)
            elseif (scene[i].entity == "strongneg") then
               love.graphics.setColor(1, 0, 0)
               love.graphics.circle("line", st_neg[j].x, st_neg[j].y, st_neg[j].raio)
            elseif (scene[i].entity == "strongpos") then
               love.graphics.setColor(0, 1, 0)
               love.graphics.circle("line", st_pos[j].x, st_pos[j].y, st_pos[j].raio)
            elseif (scene[i].entity == "simplepos") then
               love.graphics.setColor(0, .2, .1)
               love.graphics.circle("line", sp_pos[j].x, sp_pos[j].y, sp_pos[j].raio)
            elseif (scene[i].entity == "slowpos") then
               love.graphics.setColor(1, .5, 0)
               love.graphics.circle("line", sl_pos[j].x, sl_pos[j].y, sl_pos[j].raio)
            elseif (scene[i].entity == "simpleneg") then
               love.graphics.setColor(.5, 0, 1)
               love.graphics.circle("line", sp_neg[j].x, sp_neg[j].y, sp_neg[j].raio)
            elseif (scene[i].entity == "large") then
               love.graphics.setColor(.4, .2, .7)
               love.graphics.circle("line", lrg[j].x, lrg[j].y, lrg[j].raio)
            end
         end
      end
   end
   love.graphics.setColor(1, 1, 1)
   love.graphics.polygon('fill', triangle.x1, triangle.y1, triangle.x2, triangle.y2, triangle.x3, triangle.y3)
   love.graphics.circle("line", 0, 0, 1000)
   camera:unset()
end
