-----------------------------------------------------------------------------------------
--
-- main.lua
-------------------------------------------------------------------------------------------
--
-- main.lua
--
local function characterCollision( self, event )
 
    if ( event.phase == "began" ) then
        print( self.id .. ": I did not hit her " .. event.other.id )
 
    elseif ( event.phase == "ended" ) then
        print( self.id .. ": I did not! " .. event.other.id )
    end
end
--
local playerBullets = {}

 local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )
   -- Shows collision engine outlines only---------------------------------------------------------------------------------


local theGround1 = display.newImageRect( "land.png", 10000 , 600 )
theGround1.x = 520
theGround1.y = display.contentHeight
theGround1.id = "the ground"
physics.addBody( theGround1, "static", { 
    friction = 0.5, 
    bounce = 0.3 
    } )

local sheetOptionsIdle =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetIdleKnight = graphics.newImageSheet( "knightIdle.png", sheetOptionsIdle )
theGround1.x = 1000
theGround1.y = 1800
theGround1.id = "the ground"

local sheetOptionsWalk =
{
    width = 587,
    height = 707,
    numFrames = 10
}
local sheetWalkingKnight = graphics.newImageSheet( "knightWalking.png", sheetOptionsWalk )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetIdleKnight
    },
    {
        name = "walk",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 0,
        sheet = sheetWalkingKnight
    }
}

local knight = display.newSprite( sheetIdleKnight, sequence_data )
knight.x = centerX
knight.y = centerY

knight:play()

physics.addBody( knight, "dynamic", { 
    density = 3.0, 
   friction = 0.5, 
    bounce = 0.3 
   } )


display.setStatusBar(display.HiddenStatusBar)
 
centerX = display.contentWidth * .5
centerY = display.contentHeight * .5

local sheetOptionsIdleNinja =
{
    width = 232,
    height = 439,
    numFrames = 10
}
local sheetIdleNinja = graphics.newImageSheet( "ninjaBoyIdle.png", sheetOptionsIdleNinja )
theGround1.x = 1000
theGround1.y = 1800
theGround1.id = "the ground"

local sheetOptionsDead =
{
    width = 482,
    height = 498,
    numFrames = 10,


        name = "Dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetNinjaDead
    }


local sheetNinjaDead = graphics.newImageSheet( "ninjaBoyDead.png", sheetOptionsDead )


-- sequences table
local sequence_data = {
    -- consecutive frames sequence
    {
        name = "idle",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetIdleNinja
    },
    {
        name = "Dead",
        start = 1,
        count = 10,
        time = 800,
        loopCount = 1,
        sheet = sheetNinjaDead
    }
}

local Ninja = display.newSprite( sheetIdleNinja, sequence_data )
Ninja.x = centerX
Ninja.y = centerY

Ninja:play()

physics.addBody( Ninja, "dynamic", { 
    density = 3.0, 
   friction = 0.5, 
    bounce = 0.3 
   } )

-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheetNinja() 
    Ninja:setSequence( "Dead" )
    Ninja:play()
    print("Dead")
end

timer.performWithDelay( 2000, swapSheetNinja )




-- After a short time, swap the sequence to 'seq2' which uses the second image sheet
local function swapSheet()
    knight:setSequence( "walk" )
    knight:play()
    print("walk")
end

timer.performWithDelay( 2000, swapSheet )



local dPad = display.newImage( "d-pad.png" )
dPad.x = 150
dPad.y = display.contentHeight - 140
dPad.alpha = 0.50
dPad.id = "d-pad"

local upArrow = display.newImage( "upArrow.png" )
upArrow.x = 150
upArrow.y = display.contentHeight - 250
upArrow.id = "up arrow"

local downArrow = display.newImage( "downArrow.png" )
downArrow.x = 150
downArrow.y = display.contentHeight + -30
downArrow.id = "down arrow"

local leftArrow = display.newImage( "leftArrow.png" )
leftArrow.x = 40
leftArrow.y = display.contentHeight - 140
leftArrow.id = "left arrow"

local rightArrow = display.newImage( "rightArrow.png" )
rightArrow.x = 260
rightArrow.y = display.contentHeight - 140
rightArrow.id = "right arrow"

local BUTTON = display.newImageRect( "JUMP.png", 100,100 )
BUTTON.x = display.contentWidth - 1390
BUTTON.y = display.contentHeight - 130
BUTTON.id = "BUTTON"
BUTTON.alpha = 0.5

local shootButton = display.newImageRect( "Butta.png", 150, 150 )
shootButton.x = display.contentWidth - 1000
shootButton.y = display.contentHeight - 80
shootButton.id = "shootButton"
shootButton.alpha = 0.5


function checkPlayerBulletsOutOfBounds()
    -- check if any bullets have gone off the screen
    local bulletCounter

    if #playerBullets > 0 then
        for bulletCounter = #playerBullets, 1 ,-1 do
            if playerBullets[bulletCounter].x > display.contentWidth + 1000 then
                playerBullets[bulletCounter]:removeSelf()
                playerBullets[bulletCounter] = nil
                table.remove(playerBullets, bulletCounter)
                print("remove bullet")
            end
        end
    end
end

local physics = require( "physics" )

physics.start()
physics.setGravity( 0, 25 ) -- ( x, y )


function shootButton:touch( event )
    if ( event.phase == "began" ) then
        -- make a bullet appear
        local aSingleBullet = display.newImage( "blade.png" )
        aSingleBullet.x = knight.x+100
        aSingleBullet.y = knight.y
        physics.addBody( aSingleBullet, 'dynamic' )
        -- Make the object a "bullet" type object
        aSingleBullet.isBullet = true
        aSingleBullet.gravityScale = 0.5
        aSingleBullet.id = "bullet"
        aSingleBullet:setLinearVelocity( -1000, 1000 )

        table.insert(playerBullets,aSingleBullet)
        print("# of bullet: " .. tostring(#playerBullets))
    end

    return true
end




function upArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
        	x = 0, -- move 0 in the x direction 
        	y = -70, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function downArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
        	x = 0, -- move 0 in the x direction 
        	y = 50, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function leftArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
        	x = -50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function rightArrow:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
        	x = 50, -- move 0 in the x direction 
        	y = 0, -- move up 50 pixels
        	time = 100 -- move in a 1/10 of a second
        	} )
    end

    return true
end

function BUTTON:touch( event )
    if ( event.phase == "ended" ) then
        -- move the character up
        transition.moveBy( knight, { 
            x = 50, -- move 0 in the x direction 
            y = -50, -- move down 50 pixels
            time = 100 -- move in a 1/10 of a second
            } )
    end


    return true
end







function checkCharacterPosition( event )
    -- check every frame to see if character has fallen
    if knight.y > display.contentHeight + 500 then
        knight.x = display.contentCenterX - 200
        knight.y = display.contentCenterY
    end
end



upArrow:addEventListener( "touch", upArrow )
downArrow:addEventListener( "touch", downArrow )
leftArrow:addEventListener( "touch", leftArrow )
rightArrow:addEventListener( "touch", rightArrow )

BUTTON:addEventListener( "touch", BUTTON )
shootButton:addEventListener( "touch", shootButton )

Runtime:addEventListener( "enterFrame", checkCharacterPosition )
Runtime:addEventListener( "enterFrame", checkPlayerBulletsOutOfBounds )