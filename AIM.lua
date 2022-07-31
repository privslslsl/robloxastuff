-- Local Vars

local rs = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local p = game:GetService("Players")
local lp = p.LocalPlayer
local mouse = lp:GetMouse()

--- AIM Specific Settings

local AIM = {
    aimKey = "LeftAlt",
    aimActivated = false,
	maxDist = 200,
	fovMax = 100,
	fovVis = true,
	aimState = false,
	aimSpot = "Head",
	teamCheck = true,
}

--- Drawing Circle (FOV)

local fovC = Drawing.new("Circle")
fovC.Visible = AIM.fovVis
fovC.Radius = AIM.fovMax
fovC.Color = Color3.fromRGB(255,255,255)
fovC.Thickness = 1.15
fovC.Position = Vector2.new(camera.ViewportSize.X/2,camera.ViewportSize.Y/2)

--- Aimbot/Aimkey Control

UIS.InputBegan:Connect(function(inpt)
    if inpt.UserInputType == Enum.UserInputType.MouseButton2 then
        AIM.aimActivated = true
    end
end)

UIS.InputEnded:Connect(function(inpt)
    if inpt.UserInputType == Enum.UserInputType.MouseButton2 then
        AIM.aimActivated = false
    end
end)
rs.RenderStepped:Connect(function()
    local cPlayer = nil
    local cDist = math.huge
    	
    if AIM.aimActivated then
    	    
    	   for i,v in next, p:GetChildren() do
    	       if v ~= lp and v ~= nil then

    	           if AIM.teamCheck == true and v.Team ~= lp.Team or AIM.teamCheck == false then

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
    	    end
        if cPlayer ~= nil and AIM.aimState == true then
            camera.CFrame = CFrame.new(camera.CFrame.Position, cPlayer.Character[AIM.aimSpot].Position)
        end
    end
end)
return AIM
