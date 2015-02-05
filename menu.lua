local colors = require( 'colors' )
local composer = require( "composer" )
local scene = composer.newScene()

local background, button, label

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   function newGame()                                                            --function to send the scene to the game scene
      composer.gotoScene( 'game', {
         effect = "fade",
         time = 300
      });
   end

   local sceneGroup = self.view                             -- get the scene to refere to itself and set it to a variable to be used to change the background
   local params = event.params;                             -- 

   local x = display.actualContentWidth / 2;                --x is the center of the screen on the x axis
   local y = display.actualContentHeight / 2;               --y is the center of the screen on the y axis


   background = display.newRect( sceneGroup, x, y, display.actualContentWidth, display.actualContentHeight )   --set the background to be the entire screen
   button = display.newRoundedRect( sceneGroup, x, y, 400, 120, 10 )                                           --set the button to the center of the sreen
   label = display.newText( sceneGroup, 'I\'m Ready!', x, y, native.systemFontBold, 40 )                       --set the text to be overlayed over the button
   background:setFillColor( colors.darkBlue.r, colors.darkBlue.g, colors.darkBlue.b )                          -- set the background to the appropriate colors
   label:setFillColor( colors.white.r, colors.white.g, colors.white.b )                                        -- set the color of the text to the appropriate value
   button:setFillColor( colors.brightBlue.r, colors.brightBlue.g, colors.brightBlue.b )                        -- set the button to the appropriate colors
   button:addEventListener( 'tap', newGame )                                                                   -- ste a listener for the button that we have created

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

---------------------------------------------------------------------------------

return scene
