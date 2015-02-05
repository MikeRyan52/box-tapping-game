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
local background 		-- create a background for the game
local scoreUI = {
	badTaps = {
		box = false,
		val = false
	},
	correctTaps = {
		box = false,
		val = false
	},
	averageResponseTime = {
		box = false,
		val = false
	}
}
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
 local sceneGroup = self.view				--tell the scene to refer to itself

local x = display.actualContentWidth / 2;
local y = ( display.actualContentHeight / 2 ) - 150
local background
background = display.newRect( sceneGroup, x, y + 150, display.actualContentWidth, display.actualContentHeight ) --create a background during the game
background:setFillColor( colors.darkBlue.r, colors.darkBlue.g, colors.darkBlue.b ) 				--color the background to the desired color


local function drawUI()
	local width = display.actualContentWidth / 3
	local height = 100
	local x = 0
	local y = display.actualContentHeight - 50

	if(scoreUI.badTaps.box) then
		scoreUI.badTaps.box:removeSelf()
		scoreUI.badTaps.val:removeSelf()
		scoreUI.correctTaps.box:removeSelf()
		scoreUI.correctTaps.val:removeSelf()
		scoreUI.averageResponseTime.box:removeSelf()
		scoreUI.averageResponseTime.val:removeSelf()
	end

	x = width / 2
	scoreUI.correctTaps.box = display.newRect( sceneGroup, x, y, width, height )
	scoreUI.correctTaps.box:setFillColor( colors.brightBlue.r, colors.brightBlue.g, colors.brightBlue.b )
	scoreUI.correctTaps.val = display.newText({
		parent = sceneGroup,
		text = score.correctTaps,
		x = x,
		y = y,
		width = width,
		align = 'center',
		font = native.systemFont,
		fontSize = 50
	})
	scoreUI.correctTaps.val:setFillColor( 1, 1, 1 )

	x = width + ( width / 2 )
	local averageResponseTimeText

	if(score.averageResponseTime == 0) then
		averageResponseTimeText = '0s'
	else
		averageResponseTimeText = ( math.ceil( score.averageResponseTime / 10 ) / 100 ) .. 's'
	end
	scoreUI.averageResponseTime.box = display.newRect( sceneGroup, x, y, width, height )
	scoreUI.averageResponseTime.box:setFillColor( colors.grey.r, colors.grey.g, colors.grey.b )
	scoreUI.averageResponseTime.val = display.newText({
		parent = sceneGroup,
		text = averageResponseTimeText,
		x = x,
		y = y,
		width = width,
		align = 'center',
		font = native.systemFont,
		fontSize = 50
	})
	scoreUI.averageResponseTime.val:setFillColor( 0.3, 0.3, 0.3 )

	x = ( width * 2 ) + ( width / 2 )
	scoreUI.badTaps.box = display.newRect( sceneGroup, x, y, width, height )
	scoreUI.badTaps.box:setFillColor( colors.red.r, colors.red.g, colors.red.b )
	scoreUI.badTaps.val = display.newText({
		parent = sceneGroup,
		text = score.badTaps,
		x = x,
		y = y,
		width = width,
		align = 'center',
		font = native.systemFont,
		fontSize = 50
	})
	scoreUI.badTaps.val:setFillColor( 1, 1, 1 )
end

function measureAverageResponseTimes()
	local totalTime = 0;				-- variable to hold the total amount of time that has passed between each box spawn and the person's reaction time
	local timeCount = 0;				-- variable to hold the amount of times that they have responded to use to calculate the average response time
	for k,time in pairs(clickTimes) do		-- loop through our table and calculate the total response time
		totalTime = totalTime + time		
		timeCount = timeCount + 1		-- increase the amount of times that they have responded to use to calculate the average response time
	end
	score.averageResponseTime = totalTime / timeCount	--calculate the average response time and store it in the table
end


local function tapSq(event)
	

	--print(event.phase)
	if event.phase == "ended" and spawnedBoxes ~= 10 then		--check to see if they finished their click and if it has not hit the limited number of boxes
		if event.target.colorscheme == blueBox.colorscheme then				--if the box tapped was blue then increase the number of correct taps
			score.correctTaps = score.correctTaps + 1
	    else							-- if the box tapped was red then increase the number of incorrect taps
	    	score.badTaps = score.badTaps + 1
	    end
	   clickTimes[i] = system.getTimer() - t;			--calculate the amount of time to respond to box spanws
	   i = i+1;							--move to the next index of the array
	   event.target:removeSelf();				--remove the tapped box
	   measureAverageResponseTimes()
	   game();						--call the game function to create a new box
       timer.cancel(boxTimer)				--cancel the timer for the box's self-elimination
	elseif spawnedBoxes == 10 then				--if the number of boxes spawned was the limit
		event.target:removeSelf();			-- remove the last spawned box
		timer.cancel( boxTimer )			--cancel the timer for the box's self-elimination 
		measureAverageResponseTimes()
		
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
	redBox:setFillColor(colors.red.r,colors.red.g,colors.red.b);-- set the color to be red
	redbox.colorscheme = {colors.red.r,colors.red.g,colors.red.b};
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
	blueBox:setFillColor(colors.brightblue.r,colors.brightblue.g,colors.brightblue.b);	-- set the color to be blue
	bluebox.colorscheme = {colors.brightBlue.r,colors.brightBlue.g,colors.brightBlue.b};
	blueBox:addEventListener("touch",tapSq)		--create the event listener to listen for the touch event
	boxTimer = timer.performWithDelay( 2000, function() remove = blueBox:removeSelf(); game() end)	--create a timed delay that will eliminate a box and then recall the box call
end

------------------------------------------------------------------------------------------------------
--game function used to spawn the boxes based on a random variable 
------------------------------------------------------------------------------------------------------

function game()
		drawUI()
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
