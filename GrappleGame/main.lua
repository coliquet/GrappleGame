function love.load()
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 9.81*64, true)

    winWidth, winHeight = love.graphics.getDimensions()

    speed = 60000
    grappleSpeed = 400

    D1x = 300
    D1y = 200

    danielType = "static"

    objects = {}

    objects.ground = {}
    objects.ground.body = love.physics.newBody(world, winWidth/2, winHeight-50/2, "static")
    objects.ground.shape = love.physics.newRectangleShape(650, 50)
    objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape)
    objects.ground.fixture:setFriction(0.1)
    
    objects.ball = {}
    objects.ball.body = love.physics.newBody(world, winWidth/2, winHeight/2, "dynamic")
    objects.ball.shape = love.physics.newCircleShape(20)
    objects.ball.fixture = love.physics.newFixture(objects.ball.body, objects.ball.shape, 1)
    objects.ball.fixture:setRestitution(0.9)
    objects.ball.fixture:setFriction(0.1)

    objects.daniel = {}
    objects.daniel.body = love.physics.newBody(world, D1x, D1y, danielType)
    objects.daniel.shape = love.physics.newRectangleShape(0, 0, 25, 25)
    objects.daniel.fixture = love.physics.newFixture(objects.daniel.body, objects.daniel.shape, 1)
    objects.daniel.fixture:setFriction(0.5)

    objects.block1 = {}
    objects.block1.body = love.physics.newBody(world, 170, 400, "dynamic")
    objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
    objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 0.5)
    objects.block1.fixture:setFriction(0.1)
    
    objects.block2 = {}
    objects.block2.body = love.physics.newBody(world, 500, 400, "dynamic")
    objects.block2.shape = love.physics.newRectangleShape(0, 0, 50, 100)
    objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 1.5)
    objects.block2.fixture:setFriction(0.1)

    love.graphics.setBackgroundColor(0.41, 0.53, 0.97)
    love.window.setMode(650, 650, {resizable=true, vsync=0, minwidth=400, minheight=400})

    love.joystick.loadGamepadMappings("gamecontrollerdb.txt")
end

function love.update(dt)
    world:update(dt)

    local joysticks = love.joystick.getJoysticks()
    if #joysticks > 0 then
        local joystick = joysticks[1]

        grappleAngle = math.atan2(objects.ball.body:getX() - objects.daniel.body:getX(), objects.ball.body:getY() - objects.daniel.body:getY())

        local triggerleft = joystick:getGamepadAxis("triggerleft")
        local triggerright = joystick:getGamepadAxis("triggerright")

        if not joystick then return end

        --debug
        if joystick:isGamepadDown("a") then
            objects.ball.body:applyForce(dt*speed*joystick:getGamepadAxis("leftx"), dt*speed*joystick:getGamepadAxis("lefty"))
            if joystick:isGamepadDown("dpup") then
                speed = speed + 1000
            elseif joystick:isGamepadDown("dpdown") then
                speed = speed - 1000
            elseif joystick:isGamepadDown("dpright") then
                speed = 60000
            elseif joystick:isGamepadDown("dpleft") then
                objects.ball.body:setPosition(winWidth/2, winHeight/2)
                objects.ball.body:setLinearVelocity(0, 0)
            end
        elseif joystick:isGamepadDown("b") then
            if joystick:isGamepadDown("dpup") then
                grappleSpeed = grappleSpeed + 50
            elseif joystick:isGamepadDown("dpdown") then
                grappleSpeed = grappleSpeed - 50
            elseif joystick:isGamepadDown("dpright") then
                grappleSpeed = 400
            end
        elseif joystick:isGamepadDown("y") then
            if joystick:isGamepadDown("dpup") then

            elseif joystick:isGamepadDown("dpdown") then

            elseif joystick:isGamepadDown("dpright") then
                objects.block2.body:setPosition(winWidth/2, winHeight/2)
                objects.block2.body:setLinearVelocity(0, 0)
            elseif joystick:isGamepadDown("dpleft") then
                objects.block1.body:setPosition(winWidth/2, winHeight/2)
                objects.block1.body:setLinearVelocity(0, 0)
            end
        elseif joystick:isGamepadDown("x") then
            if joystick:isGamepadDown("dpup") then

            elseif joystick:isGamepadDown("dpdown") then

            elseif joystick:isGamepadDown("dpright") then
                objects.daniel.body:setPosition(winWidth/2, winHeight/2)
                objects.daniel.body:setLinearVelocity(0, 0)
            elseif joystick:isGamepadDown("dpleft") then
                if danielType == "dynamic" then
                    danielType = "static"
                elseif danielType == "static" then
                    danielType = "dynamic"
                end
            end
        end

        if triggerleft > 0.1 then
            objects.ball.body:applyForce(-grappleSpeed*triggerleft*math.sin(grappleAngle), -grappleSpeed*math.cos(grappleAngle))
            objects.daniel.body:applyForce(grappleSpeed*math.sin(grappleAngle), grappleSpeed*math.cos(grappleAngle))
        end
        if joystick:isGamepadDown("leftshoulder") then
            objects.ball.body:applyForce(grappleSpeed*math.sin(grappleAngle), grappleSpeed*math.cos(grappleAngle))
            objects.daniel.body:applyForce(-grappleSpeed*triggerleft*math.sin(grappleAngle), -grappleSpeed*math.cos(grappleAngle))
        end
        if joystick:getGamepadAxis("triggerright") > 0 then
            
        elseif joystick:isGamepadDown("rightshoulder") then

        end
    end

    --Keyboard Controls
--     if love.keyboard.isDown("right") then
--         objects.ball.body:applyForce(400, 0)
--     elseif love.keyboard.isDown("left") then
--         objects.ball.body:applyForce(-400, 0)
--     end
--     --reset
--     if love.keyboard.isDown("r") then
--         objects.ball.body:setPosition(650/2, 650/2)
--         objects.ball.body:setLinearVelocity(0, 0)
--     end
end

function love.draw()
    love.graphics.setColor(0.28, 0.63, 0.05)
    love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints()))
    love.graphics.setColor(0.76, 0.18, 0.05)
    love.graphics.circle("fill", objects.ball.body:getX(), objects.ball.body:getY(), objects.ball.shape:getRadius())

    love.graphics.setColor(0.5, 0.5, 0.5)
    love.graphics.polygon("fill", objects.daniel.body:getWorldPoints(objects.daniel.shape:getPoints()))
    
    love.graphics.setColor(0, 0, 0)
    love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
    love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))

    local x, y = objects.ball.body:getX(), objects.ball.body:getY()
    local angle = objects.ball.body:getAngle()
    local dx, dy = math.cos(angle) * 20, math.sin(angle) * 20
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.line(x, y, x + dx, y + dy)
end