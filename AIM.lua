local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local p = game:GetService("Players")
local lp = p.LocalPlayer
local mouse = lp:GetMouse()

getgenv().aimToggle = false

local AIM = {
	aimKey = "LeftAlt",
	maxDist = 200,
	fovMax = 100,
}

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = true
fovCircle.Radius = aimSettings.fovMax
fovCircle.Position = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)
fovCircle.Thickness = 0.75


function getPlayer()
	local cPlayer = nil
	local cDist = math.huge
	
	for _,v in pairs(p:GetPlayers()) do
		if v ~= lp and v.Team ~= lp.Team and v.Character.Humanoid.Health > 0 then
		    local p2D, onS = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
			local mousePos = Vector2.new(mouse.X,mouse.Y)
			local playerPos = Vector2.new(p2D.X,p2D.Y)
			local fovDist = (mousePos - playerPos).Magnitude
			local Dist = (lp.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
			if onS then
    			if Dist <= aimSettings.maxDist and fovDist < aimSettings.fovMax then
    				cDist = Dist
    				cPlayer = v
    			end
		    end
		end
	end
	return cPlayer
end

function AIM:Toggle(bool)
    if bool == true then
        getgenv().aimToggle = true 
    else
        getgenv().aimToggle = false
    end
end

getgenv().aimCheck = false

UIS.InputBegan:Connect(function(i)
    if getgenv().aimToggle == true then
	if i.KeyCode == Enum.KeyCode[aimSettings.aimKey] then
		getgenv().aimCheck = true
		while task.wait() do
    		camera.CFrame = CFrame.new(camera.CFrame.Position,getPlayer().Character.Head.Position)
    	    if getgenv().aimCheck == false then return end
    	end
	end
end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode[aimSettings.aimKey] then
    	getgenv().aimCheck = false
    end
end)
