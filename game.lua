local colors = require('colors')
local composer = require('composer')
local timer = require('timer');
local scene = composer.newScene()
local spawnedBoxes  = 0;
local randX;
local randY;
local gameStart = false;
local i = 0;
local createBox;
local xx = display.contentWidth / 2;
local yy = display.contentHeight / 2;
local blueBox
local redBox
local intermediateTime
local t = 0
local newTime
local timeToSpawn
local boxTimer
local score = {
	correctTaps = 0,
	badTaps = 0,
	averageResponseTime=0
}
local clickTimes = {   }
local i = 0
---------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE
-- unless "composer.removeScene()" is called.
---------------------------------------------------------------------------------

-- local forward references should go here

---------------------------------------------------------------------------------

-- "scene:create()"
function scene:create( event )

   function endGame(score)
      composer.gotoScene( 'gameover', {
         effect = 'fade',
         time = 300,
         params = score
         -- params = {
         --    correctTaps = 7,
         --    badTaps = 4,
         --    averageResponseTime = 0.23
         -- }
      });

      composer.removeScene( 'menu', false )
   end
local function tapSq(event)

	print(event.phase)
	if event.phase == "ended" and spawnedBoxes ~= 10 then
		if event.target == blueBox then
			score.correctTaps = score.correctTaps + 1
	    elseif event.taget == redBox then
	    	score.badTaps = score.badTaps + 1
	    end
	   clickTimes[i] = system.getTimer() - t;
	   i = i+1;
		event.target:removeSelf();
		game();
		timer.cancel(boxTimer)
	elseif spawnedBoxes == 10 then
		event.target:removeSelf();
		timer.cancel( boxTimer )
		local counter = spawnedBoxes
		-- while counter > 0 do
		--   score.averageResponseTime = score.averageResponseTime + clickTimes[counter] 
		--    counter = counter - 1;
		-- end
		local totalTime = 0;
		local timeCount = 0;
		for k,time in pairs(clickTimes) do
			totalTime = totalTime + time
			timeCount = timeCount + 1
		end
		score.averageResponseTime = totalTime / timeCount
		-- score.averageResponseTime = averageResponseTime / spawnedBoxes
		endGame(score)
	end
end

local function CreateRedBox()
	t = system.getTimer();
	spawnedBoxes = spawnedBoxes + 1;
	randX = math.random( 0, display.contentWidth);
	randY = math.random( 0, display.contentHeight);
	redBox = display.newRoundedRect( randX, randY, 100, 100, 10 )
	redBox:setFillColor(1,0,0);
	redBox:addEventListener("touch", tapSq)
	boxTimer = timer.performWithDelay( 2000, function() remove = redBox:removeSelf(); game() end)

end 

local function CreateBlueBox()
	t = system.getTimer();
	spawnedBoxes = spawnedBoxes + 1;
	randX = math.random( 0, display.contentWidth);
	randY = math.random( 0, display.contentHeight);
	blueBox = display.newRect( randX, randY, 100, 100 )
	blueBox:setFillColor(0,0,1);
	blueBox:addEventListener("touch",tapSq)
	boxTimer = timer.performWithDelay( 2000, function() remove = blueBox:removeSelf(); game() end)
end

function game()
		createBox = math.random( 0, 1 )
		if spawnedBoxes == 10 then 
			endGame(score)
		end
		if createBox == 0 then
			timeToSpawn = math.random(500, 5000)
			timer.performWithDelay( timeToSpawn, CreateBlueBox);
		else
			timeToSpawn = math.random(500, 5000)
			timer.performWithDelay( timeToSpawn, CreateRedBox);
		end
end

game();


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
