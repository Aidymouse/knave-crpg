--[[
    Your love2d game start here
]]

local Debug = require 'util.debug'

local l_vec = require 'lib.vec3'
local DrawEngine = require 'lib.draw_engine'
local WorldAttr = require 'lib.world_attributes'

local o_Game_State = require 'obj.game_state'
local o_Actor = require 'obj.actor'
local Entity = require 'entity.entity'

local Map = require 'obj.map'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()

    --test_actor = o_Actor(l_vec.vec3(5, 5.5, 2))

    --print(te1 < te2)

    --table.insert(o_Game_State.world_entities, test_actor)
    
    test_map = Map("maps.new_style_test_map")
    DrawEngine.load_map(test_map)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    DrawEngine.resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end

    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.mousepressed(x, y)
    print( test_map:get_hovered_pos( love.mouse.getXYOffset() ) )
end

function love.update(dt)
    -- change some values based on your actions

    -- Basic camera for testing
    if love.keyboard.isDown("left") then
        WorldAttr.offset_x = WorldAttr.offset_x + 10
    elseif love.keyboard.isDown("right") then
        WorldAttr.offset_x = WorldAttr.offset_x - 10
    end

    if love.keyboard.isDown("up") then
        WorldAttr.offset_y = WorldAttr.offset_y + 10
    elseif love.keyboard.isDown("down") then
        WorldAttr.offset_y = WorldAttr.offset_y - 10
    end

    --test_actor:update(dt)

    if Debug.debug_mode then
        if love.keyboard.isDown("0") then Debug.only_draw_layer = 0 end
        if love.keyboard.isDown("1") then Debug.only_draw_layer = 1 end
        if love.keyboard.isDown("2") then Debug.only_draw_layer = 2 end
        if love.keyboard.isDown("3") then Debug.only_draw_layer = 3 end
        if love.keyboard.isDown("4") then Debug.only_draw_layer = 4 end
        if love.keyboard.isDown("5") then Debug.only_draw_layer = 5 end
        if love.keyboard.isDown("6") then Debug.only_draw_layer = 6 end
        if love.keyboard.isDown("7") then Debug.only_draw_layer = 7 end
        if love.keyboard.isDown("8") then Debug.only_draw_layer = 8 end
    end

    -- Debug

    if love.keyboard.wasPressed("rshift") then
        Debug.debug_mode = not Debug.debug_mode
    end

    --test_actor:update(dt)

    DrawEngine.update(dt)

    -- Reset pressed keys
    love.keyboard.keysPressed = {}
end

function love.draw()
    -- draw your stuff here
    DrawEngine.draw( )

    love.graphics.print(love.timer.getFPS(), 0, 0)
end

