if not game:IsLoaded() then
    game.Loaded:Wait()
end

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local backpack = player:FindFirstChild("Backpack")
if not backpack then return end

-- Create the tool
local tool = Instance.new("Tool")
tool.Name = "Troll"
tool.RequiresHandle = false
tool.Parent = backpack

-- Toggle state
local isFloating = false
local storedOffsets = {}  -- Store original offsets
local camera = workspace.CurrentCamera

tool.Activated:Connect(function()
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if not character or not humanoidRootPart or not humanoid then return end

    isFloating = not isFloating -- Toggle state

    if isFloating then
        -- Store original offsets and move parts up for others
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                storedOffsets[part] = part.Position - humanoidRootPart.Position
                part.Position = part.Position + Vector3.new(0, 10000, 0) -- Move up for others
            end
        end

        -- Keep updating position to allow movement
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not isFloating or not character or not humanoidRootPart then
                connection:Disconnect()
                return
            end

            for part, offset in pairs(storedOffsets) do
                if part and part:IsA("BasePart") then
                    part.Position = humanoidRootPart.Position + offset + Vector3.new(0, 10000, 0)
                end
            end
        end)

        -- Keep camera at the ground
        local groundPosition = humanoidRootPart.Position
        game:GetService("RunService").RenderStepped:Connect(function()
            if isFloating then
                camera.CFrame = CFrame.new(groundPosition + Vector3.new(0, 5, 0)) -- Keep camera at ground level
            end
        end)
    else
        -- Restore normal positioning
        for part, offset in pairs(storedOffsets) do
            if part and part:IsA("BasePart") then
                part.Position = humanoidRootPart.Position + offset
            end
        end
        storedOffsets = {}  -- Clear stored positions
    end
end)
