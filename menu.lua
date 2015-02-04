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

   function newGame()
      composer.gotoScene( 'game', {
         effect = "fade",
         time = 300
      });
   end

   local sceneGroup = self.view
   local params = event.params;

   local x = display.actualContentWidth / 2;
   local y = display.actualContentHeight / 2;


   background = display.newRect( sceneGroup, x, y, display.actualContentWidth, display.actualContentHeight )
   button = display.newRoundedRect( sceneGroup, x, y, 400, 120, 10 )
   label = display.newText( sceneGroup, 'I\'m Ready!', x, y, native.systemFontBold, 40 )

   background:setFillColor( colors.darkBlue.r, colors.darkBlue.g, colors.darkBlue.b )
   label:setFillColor( colors.white.r, colors.white.g, colors.white.b )
   button:setFillColor( colors.brightBlue.r, colors.brightBlue.g, colors.brightBlue.b )
   button:addEventListener( 'tap', newGame )

   -- Initialize the scene here.
   -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )

---------------------------------------------------------------------------------

return scene