--[[
    Your love2d game start here
]]

local u_Debug = require 'util.debug'

local l_vec = require 'lib.vec3'
local l_Draw_Engine = require 'lib.draw_engine'
local l_WorldAttr = require 'lib.world_attributes'

local o_Game_State = require 'obj.game_state'
local o_Actor = require 'obj.actor'
local o_Entity = require 'obj.entity'

local o_Map = require 'obj.map'

love.graphics.setDefaultFilter('nearest', 'nearest')

function love.load()

    test_actor = o_Actor(l_vec.vec3(5, 5.5, 2))

    table.insert(o_Game_State.world_entities, test_actor)
    
    test_map = o_Map("maps.testmap")
    l_Draw_Engine.load_map(test_map)

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    l_Draw_Engine.resize(w, h)
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
        l_WorldAttr.offset_x = l_WorldAttr.offset_x + 10
    elseif love.keyboard.isDown("right") then
        l_WorldAttr.offset_x = l_WorldAttr.offset_x - 10
    end

    if love.keyboard.isDown("up") then
        l_WorldAttr.offset_y = l_WorldAttr.offset_y + 10
    elseif love.keyboard.isDown("down") then
        l_WorldAttr.offset_y = l_WorldAttr.offset_y - 10
    end

    --test_actor:update(dt)

    if u_Debug.debug_mode then
        if love.keyboard.isDown("0") then u_Debug.only_draw_layer = 0 end
        if love.keyboard.isDown("1") then u_Debug.only_draw_layer = 1 end
        if love.keyboard.isDown("2") then u_Debug.only_draw_layer = 2 end
        if love.keyboard.isDown("3") then u_Debug.only_draw_layer = 3 end
        if love.keyboard.isDown("4") then u_Debug.only_draw_layer = 4 end
        if love.keyboard.isDown("5") then u_Debug.only_draw_layer = 5 end
        if love.keyboard.isDown("6") then u_Debug.only_draw_layer = 6 end
        if love.keyboard.isDown("7") then u_Debug.only_draw_layer = 7 end
        if love.keyboard.isDown("8") then u_Debug.only_draw_layer = 8 end
    end

    -- Debug

    if love.keyboard.wasPressed("rshift") then
        u_Debug.debug_mode = not u_Debug.debug_mode
    end

    test_actor:update(dt)

    l_Draw_Engine.update(dt)

    -- Reset pressed keys
    love.keyboard.keysPressed = {}
end

function love.draw()
    -- draw your stuff here
    l_Draw_Engine.draw( )

    love.graphics.print(love.timer.getFPS(), 0, 0)
end

