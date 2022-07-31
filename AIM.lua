local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local p = game:GetService("Players")
local lp = p.LocalPlayer
local mouse = lp:GetMouse()

local AIM = {
	aimKey = "LeftAlt",
	maxDist = 200,
	fovMax = 100,
	fovVis = false,
	aimState = false,
	aimSpot = "Head"
}

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = AIM.fovVis
fovCircle.Radius = AIM.fovMax
fovCircle.Position = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
fovCircle.Thickness = 1

function getPlayer()
	local cPlayer = nil
	local cDist = math.huge
	
	for i,v in pairs(p:GetPlayers()) do
		if v ~= lp and v ~= nil and v.Team ~= lp.Team and v.Character.Humanoid.Health > 0 then
		    local p2D, onS = camera:WorldToViewportPoint(v.Character.Head.Position)
			local mousePos = Vector2.new(mouse.X,mouse.Y)
			local playerPos = Vector2.new(p2D.X,p2D.Y)
			local fovDist = (mousePos - playerPos).Magnitude
			local Dist = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if onS then
    			if Dist <= AIM.maxDist and fovDist < AIM.fovMax then
    				cDist = Dist
    				cPlayer = v
    			end
		    end
		end
	end
	return cPlayer
end

getgenv().aimCheck = false
UIS.InputBegan:Connect(function(inpt)
    if AIM.aimState == true then
	if inpt.KeyCode == Enum.KeyCode[AIM.aimKey] then
		getgenv().aimCheck = true
		while task.wait() do
		    if getPlayer() ~= nil then
            	camera.CFrame = CFrame.new(camera.CFrame.Position,getPlayer().Character[AIM.aimSpot].Position)
                if getgenv().aimCheck == false then return end
            end
		end
    end
end
end)

UIS.InputEnded:Connect(function(inpt)
    if inpt.KeyCode == Enum.KeyCode[AIM.aimKey] then
    	getgenv().aimCheck = false
    end
end)

return AIM
