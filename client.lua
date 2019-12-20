

-- CHANGE SETTINGS HERE --

idleThreshold = 1500 -- How long to wait until applying idle camera? In miliseconds (1s = 1000ms) [DEFAULT = 1500]
zoom = 15.0 		 -- How much to zoom in? [DEFAULT = 15.0]
heightDecrease = 0.5 -- How much to lower camera? Should be directly related to zoom. [DEFAULT = 0.5]
transitionTime = 500 -- How quickly to transition into the idle camera? In miliseconds [DEFAULT = 500]

-- OKAY END OF SETTINGS YOU ARE NOT ALLOWED TO CONTINUE --


idleCounter = 0
activated = false
mainCam = 0

countingIdle = false
timer = GetGameTimer()

Citizen.CreateThread(function()
	while true do Wait(0)
		
		-- if GetEntitySpeed(PlayerPedId()) == 0.0 and IsPedActiveInScenario(PlayerPedId()) then
		if math.floor(GetEntitySpeed(PlayerPedId())) == 0 then
			if countingIdle == false then
				countingIdle = true
				timer = GetGameTimer()
			end
			idleCounter = GetGameTimer() - timer
		else
			if countingIdle == true then
				countingIdle = false
				idleCounter = 0
			end
		end
	
		if idleCounter > idleThreshold and activated == false then
			activated = true
			mainCam = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
			RenderScriptCams(true, 1, transitionTime,  true,  true)
		elseif idleCounter < idleThreshold and activated == true then
			activated = false
			RenderScriptCams(false, 1, transitionTime,  true,  true)
			DestroyCam(mainCam, false)
		end
		
		processCamera(mainCam) -- thank god this doesn't error when mainCam doesn't exist
	
	end
end)

function processCamera(cam)
	local rotx, roty, rotz = table.unpack(GetEntityRotation(PlayerPedId()))
	local camX, camY, camZ = table.unpack(GetGameplayCamCoord())
	local camRX, camRY, camRZ = GetGameplayCamRelativePitch(), 0.0, GetGameplayCamRelativeHeading()
	local camF = GetGameplayCamFov()
	local camRZ = (rotz+camRZ)
	
	SetCamCoord(cam, camX, camY, camZ-heightDecrease)
	SetCamRot(cam, camRX, camRY, camRZ)
	SetCamFov(cam, camF-zoom)
end
