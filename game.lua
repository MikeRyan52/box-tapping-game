local colors = require('colors')
local composer = require('composer')
local timer = require('timer');
local scene = composer.newScene()

---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   function endGame()
      composer.gotoScene( 'gameover', {
         effect = 'fade',
         time = 300,
         params = {
            correctTaps = 7,
            badTaps = 4,
            averageResponseTime = 0.23
         }
      });

      composer.removeScene( 'menu', false )
   end

   local sceneGroup = self.view
   local params = event.params;

   local x = display.actualContentWidth / 2;
   local y = display.actualContentHeight / 2;

   local background = display.newRect( sceneGroup, x, y, display.actualContentWidth, display.actualContentHeight )

   background:setFillColor( colors.darkBlue.r, colors.darkBlue.g, colors.darkBlue.b )

   timer.performWithDelay( 2500, endGame )
end

-- "scene:show()"
function scene:show( event )

   local sceneGroup = self.view
   local phase = event.phase

   if ( phase == "did" ) then
      -- Called when the scene is now on screen.
      -- Insert code here to make the scene come alive.
      -- Example: start timers, begin animation, play audio, etc.
   end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )

---------------------------------------------------------------------------------

return scene