local colors = require('colors') 
local composer = require('composer')
local timer = require('timer');
local scene = composer.newScene()
local spawnedBoxes  = 0; --variable representing the number of boxes that have been spawned
local randX; --variable used to hold the x coordinate of a random location on screen to spwan the box and to reduce the length of the box spawning 
local randY; --variable used to hold the y coordinate of a random location on screen to spwan the box and to reduce the length of the box spawning 
-- local gameStart = false;
local i = 0; -- variable to be used as  a counter to run through the clickTimes array
local createBox; --variable to store the value used to check and create a colored box based on a random value
local blueBox -- variable used to hold th evalue of the blue box that is created by the CreateBlueBox function
local redBox --variable used to hold the value of the red box that is created by the CreateRedBox function
local t = 0 -- variable used to hold the value of the timer gathered from the system.Timer function
local newTime -- variable  used to hold the value of the difference in time from the start of the timer to the end
local timeToSpawn -- variable used to hold the random value of when to spawn the next box needed
local boxTimer -- variable used to hold the amount of time a box will exist before remmoving itself from the game

local score = { 		--array used to store the values of the number of correct and incorrect taps
	correctTaps = 0,	-- and the average response time for each tap
	badTaps = 0,
	averageResponseTime=0
}
local clickTimes = {   } 	-- array used to store the values of response times for each click
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

	--print(event.phase)
	if event.phase == "ended" and spawnedBoxes ~= 10 then		--check to see if they finished their click and if it has not hit the limited number of boxes
		if event.target == blueBox then				--if the box tapped was blue then increase the number of correct taps
			score.correctTaps = score.correctTaps + 1
	    else							-- if the box tapped was red then increase the number of incorrect taps
	    	score.badTaps = score.badTaps + 1
	    end
	   clickTimes[i] = system.getTimer() - t;			--calculate the amount of time to respond to box spanws
	   i = i+1;							--move to the next index of the array
	   event.target:removeSelf();				--remove the tapped box
	   game();						--call the game function to create a new box
           timer.cancel(boxTimer)				--cancel the timer for the box's self-elimination
	elseif spawnedBoxes == 10 then				--if the number of boxes spawned was the limit
		event.target:removeSelf();			-- remove the last spawned box
		timer.cancel( boxTimer )			--cancel the timer for the box's self-elimination 
		local totalTime = 0;				-- variable to hold the total amount of time that has passed between each box spawn and the person's reaction time
		local timeCount = 0;				-- variable to hold the amount of times that they have responded to use to calculate the average response time
		for k,time in pairs(clickTimes) do		-- loop through our table and calculate the total response time
			totalTime = totalTime + time		
			timeCount = timeCount + 1		-- increase the amount of times that they have responded to use to calculate the average response time
		end
		score.averageResponseTime = totalTime / timeCount	--calculate the average response time and store it in the table
		endGame(score)					-- pass the score table to the ednGame function
	end	
end
----------------------------------------------------------------------------------------------------------------------------------
-- function used to create a red Box as chosen by the game() function
----------------------------------------------------------------------------------------------------------------------------------
local function CreateRedBox()				
	t = system.getTimer();				--get the current time
	spawnedBoxes = spawnedBoxes + 1;		--increase the counter for the amount of times a box has been spawned
	randX = math.random( 0, display.contentWidth);	--randomly generate the x coordinate of the box to be spawned
	randY = math.random( 0, display.contentHeight);	--randomly genreate the y coordinate of the box to be spawned
	redBox = display.newRoundedRect( randX, randY, 100, 100, 10 )	--create the rectangle
	redBox:setFillColor(1,0,0);			-- set the color to be red
	redBox:addEventListener("touch", tapSq)		--create the event listener to listen for the touch event
	boxTimer = timer.performWithDelay( 2000, function() remove = redBox:removeSelf(); game() end)	--create a timed delay that will eliminate a box and then recall the box call

end 

----------------------------------------------------------------------------------------------------------------------------------
-- function used to create a blue Box as chosen by the game() function
----------------------------------------------------------------------------------------------------------------------------------

local function CreateBlueBox()
	t = system.getTimer();				--get the current time
	spawnedBoxes = spawnedBoxes + 1;		--increase the counter for the amount of times a box has been spawned
	randX = math.random( 0, display.contentWidth);	--randomly generate the x coordinate of the box to be spawned
	randY = math.random( 0, display.contentHeight);	--randomly genreate the y coordinate of the box to be spawned
	blueBox = display.newRect( randX, randY, 100, 100 )	--create the rectangle
	blueBox:setFillColor(0,0,1);			-- set the color to be blue
	blueBox:addEventListener("touch",tapSq)		--create the event listener to listen for the touch event
	boxTimer = timer.performWithDelay( 2000, function() remove = blueBox:removeSelf(); game() end)	--create a timed delay that will eliminate a box and then recall the box call
end

------------------------------------------------------------------------------------------------------
--game function used to spawn the boxes based on a random variable 
------------------------------------------------------------------------------------------------------

function game()
		createBox = math.random( 0, 1 )
		if spawnedBoxes == 10 then 					--check to see if the number of boxes spanwed is equivalent to the desired amount
			endGame(score)						--then call the end game function passing the score table
		elseif createBox == 0 then					--create a blue box based after a delay of .5s to 5s
			timeToSpawn = math.random(500, 5000)
			timer.performWithDelay( timeToSpawn, CreateBlueBox);
		else								--create a red box based after a delay of .5s to 5s
			timeToSpawn = math.random(500, 5000)
			timer.performWithDelay( timeToSpawn, CreateRedBox);
		end
end

game();


end

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
